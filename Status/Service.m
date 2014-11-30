//
//  Service.m
//  Status
//
//  Created by Gabriel Rinaldi on 1/12/14.
//  Copyright (c) 2014 Gabriel Rinaldi. All rights reserved.
//

#import <AFNetworking/AFHTTPRequestOperation.h>
#import "Services.h"
#import "HerokuParser.h"
#import "StatusPageParser.h"
#import "Service.h"

#pragma mark Service (Private)

@interface Service ()

@property (assign, nonatomic, getter = isUpdating) BOOL updating;

@end

#pragma mark - Service

@implementation Service

#pragma mark - Getters/Setters

@dynamic name;
@dynamic motd;
@dynamic syncURL;
@dynamic parseType;
@dynamic statusType;
@synthesize updating = _updating;
@synthesize delegate = _delegate;

#pragma mark - Sync

- (AFHTTPRequestOperation *)syncOperationWithSuccess:(void (^)())success failure:(void (^)(NSError *))failure {
    self.updating = YES;
    [self.delegate serviceDidStartUpdate:self];

    Parser *parser;
    switch ([self.parseType integerValue]) {
        case ServiceParseTypeHeroku: {
            parser = [[HerokuParser alloc] initWithURL:[NSURL URLWithString:self.syncURL]];
            break;
        }

        case ServiceParseTypeStatusPage: {
            parser = [[StatusPageParser alloc] initWithURL:[NSURL URLWithString:self.syncURL]];
            break;
        }

        default:
            parser = nil;
            break;
    }

    __block Service *safeSelf = self;
    AFHTTPRequestOperation *requestOperation = [parser syncOperationWithSuccess:^(NSDictionary *service) {
        safeSelf.motd = service[@"motd"];
        safeSelf.statusType = service[@"statusType"];

        NSError *error;
        [safeSelf.managedObjectContext save:&error];
        safeSelf.updating = NO;

        if (error) {
            [safeSelf.delegate service:self didUpdateWithError:error];

            if (failure) {
                failure(error);
            }
        } else {
            [safeSelf.delegate service:self didUpdateWithError:nil];

            if (success) {
                success();
            }
        }
    } failure:^(NSError *error) {
        safeSelf.updating = NO;
        [safeSelf.delegate service:self didUpdateWithError:error];

        if (failure) {
            failure(error);
        }
    }];
    
    return requestOperation;
}

- (void)syncWithSuccess:(void (^)())success failure:(void (^)(NSError *))failure {
    [[[Services sharedServices] syncOperationQueue] addOperation:[self syncOperationWithSuccess:success failure:failure]];
}

@end
