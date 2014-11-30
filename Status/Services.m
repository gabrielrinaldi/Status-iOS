//
//  Services.m
//  Status
//
//  Created by Gabriel Rinaldi on 1/9/14.
//  Copyright (c) 2014 Gabriel Rinaldi. All rights reserved.
//

#import <AFNetworking/AFURLConnectionOperation.h>
#import "STAppDelegate.h"
#import "AppearanceManager.h"
#import "Service.h"
#import "Services.h"

#pragma mark Services (Private)

@interface Services ()

@property (strong, nonatomic) NSOperationQueue *syncOperationQueue;

@end

#pragma mark - Services

@implementation Services

#pragma mark - Shared services

+ (instancetype)sharedServices {
    static Services *_sharedServices = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedServices = [[self alloc] init];
    });

    return _sharedServices;
}

#pragma mark - Helpers

+ (UIColor *)colorForServiceStatusType:(ServiceStatusType)statusType {
    switch (statusType) {
        case ServiceStatusError:
            return [[AppearanceManager defaultManager] redColor];

        case ServiceStatusWarning:
            return [[AppearanceManager defaultManager] yellowColor];

        case ServiceStatusOK:
            return [[AppearanceManager defaultManager] greenColor];

        default:
            return [[AppearanceManager defaultManager] disabledColor];
    }
}

#pragma mark - Initialization

- (id)init {
    self = [super init];
    if (self) {
        STAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *managedObjectContext = appDelegate.managedObjectContext;
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Service" inManagedObjectContext:managedObjectContext];

        NSArray *services = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Services" ofType:@"plist"]];
        for (NSDictionary *serviceDictionary in services) {
            Service *service = [[Service alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:managedObjectContext];
            service.name = serviceDictionary[@"name"];
            service.syncURL = serviceDictionary[@"syncURL"];
            service.parseType = serviceDictionary[@"parseType"];
        }

        [appDelegate saveContext];

        NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
        operationQueue.maxConcurrentOperationCount = 3;
        self.syncOperationQueue = operationQueue;
    }

    return self;
}

#pragma mark - Sync

- (void)syncWithProgressBlock:(void (^)(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations))progressBlock completionBlock:(void (^)(NSArray *operations))completionBlock {
    __block NSUInteger totalOperations = 0;
    __block NSUInteger finishedOperations = 0;

    NSError *error;
    STAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *managedObjectContext = appDelegate.managedObjectContext;
    NSMutableArray *operations = [NSMutableArray array];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Service"];
    NSArray *services = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    for (Service *service in services) {
        [operations addObject:[service syncOperationWithSuccess:^{
            finishedOperations++;

            if (progressBlock) {
                progressBlock(finishedOperations, totalOperations);
            }

            if (finishedOperations == totalOperations) {
                completionBlock([NSArray arrayWithArray:operations]);
            }
        } failure:^(NSError *error) {
            NSLog(@"Error: %@", error);

            // TODO: Handle error
            finishedOperations++;

            if (progressBlock) {
                progressBlock(finishedOperations, totalOperations);
            }

            if (finishedOperations == totalOperations) {
                completionBlock([NSArray arrayWithArray:operations]);
            }
        }]];

        totalOperations++;
    }

    [self.syncOperationQueue addOperations:operations waitUntilFinished:NO];
}

@end
