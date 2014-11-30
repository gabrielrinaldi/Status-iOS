//
//  Parser.h
//  Status
//
//  Created by Gabriel Rinaldi on 1/12/14.
//  Copyright (c) 2014 Gabriel Rinaldi. All rights reserved.
//

@class AFHTTPRequestOperation;

#pragma mark Parser

@interface Parser : NSObject

@property (strong, nonatomic) NSURL *URL;

- (id)initWithURL:(NSURL *)URL;
- (AFHTTPRequestOperation *)syncOperationWithSuccess:(void (^)(NSDictionary *service))success failure:(void (^)(NSError *))failure;

@end
