//
//  STAppDelegate.h
//  Status
//
//  Created by Gabriel Rinaldi on 12/30/13.
//  Copyright (c) 2013 Gabriel Rinaldi. All rights reserved.
//

#pragma mark STAppDelegate

@interface STAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic, readonly) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic, readonly) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;

@end
