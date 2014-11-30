//
//  STAppDelegate.m
//  Status
//
//  Created by Gabriel Rinaldi on 12/30/13.
//  Copyright (c) 2013 Gabriel Rinaldi. All rights reserved.
//

#import "ServicesViewController.h"
#import "STAppDelegate.h"

#pragma mark STAppDelegate

@implementation STAppDelegate

#pragma mark - Getters/Setters

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

#pragma mark - Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    ServicesViewController *servicesViewController = [[ServicesViewController alloc] initWithNibName:@"ServicesViewController" bundle:nil];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:servicesViewController];
    navigationController.navigationBar.translucent = NO;

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.tintColor = [UIColor whiteColor];
    self.window.backgroundColor = [UIColor colorWithRed:0.14 green:0.14 blue:0.14 alpha:1.0];
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];

    [self managedObjectContext];

    return YES;
}

#pragma mark - Core Data stack

- (void)saveContext {
    NSError *error;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil && [managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
        // TODO: Reset everything

        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);

        abort();
    }
}

- (NSManagedObjectContext *)managedObjectContext {
    if (!_managedObjectContext) {
        NSPersistentStoreCoordinator *persistentStoreCoordinator = self.persistentStoreCoordinator;
        if (persistentStoreCoordinator) {
            _managedObjectContext = [[NSManagedObjectContext alloc] init];
            _managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator;
        }
    }

    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel {
    if (!_managedObjectModel) {
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Status" withExtension:@"momd"];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }

    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (!_persistentStoreCoordinator) {
        NSError *error;
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:&error]) {
            // TODO: This should never happer, investigate

            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);

            abort();
        }
    }

    return _persistentStoreCoordinator;
}

@end
