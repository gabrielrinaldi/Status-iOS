//
//  Services.h
//  Status
//
//  Created by Gabriel Rinaldi on 1/9/14.
//  Copyright (c) 2014 Gabriel Rinaldi. All rights reserved.
//

#import "Service.h"

#pragma mark Services

@interface Services : NSObject

@property (strong, nonatomic, readonly) NSOperationQueue *syncOperationQueue;

+ (instancetype)sharedServices;
+ (UIColor *)colorForServiceStatusType:(ServiceStatusType)statusType;
- (void)syncWithProgressBlock:(void (^)(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations))progressBlock completionBlock:(void (^)(NSArray *operations))completionBlock;

@end
