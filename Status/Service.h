//
//  Service.h
//  Status
//
//  Created by Gabriel Rinaldi on 1/12/14.
//  Copyright (c) 2014 Gabriel Rinaldi. All rights reserved.
//

typedef enum {
    ServiceParseTypeHeroku = 0,
    ServiceParseTypeStatusPage = 1,
    ServiceParseTypeUnknown = 777777
} ServiceParseType;

typedef enum {
    ServiceStatusError = 0,
    ServiceStatusWarning = 1,
    ServiceStatusOK = 2,
    ServiceStatusUnknown = 777777
} ServiceStatusType;

@class AFHTTPRequestOperation;
@protocol ServiceDelegate;

#pragma mark Service

@interface Service : NSManagedObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *motd;
@property (nonatomic, retain) NSString *syncURL;
@property (nonatomic, retain) NSNumber *parseType;
@property (nonatomic, retain) NSNumber *statusType;
@property (assign, nonatomic, readonly, getter = isUpdating) BOOL updating;
@property (assign, nonatomic) id <ServiceDelegate> delegate;

- (AFHTTPRequestOperation *)syncOperationWithSuccess:(void (^)())success failure:(void (^)(NSError *))failure;
- (void)syncWithSuccess:(void (^)())success failure:(void (^)(NSError *))failure;

@end

#pragma mark - Service delegate

@protocol ServiceDelegate <NSObject>

- (void)serviceDidStartUpdate:(Service *)service;
- (void)service:(Service *)service didUpdateWithError:(NSError *)error;

@end
