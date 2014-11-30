//
//  StatusPageParser.m
//  Status
//
//  Created by Gabriel Rinaldi on 1/12/14.
//  Copyright (c) 2014 Gabriel Rinaldi. All rights reserved.
//

#import <AFNetworking/AFHTTPRequestOperation.h>
#import "Service.h"
#import "StatusPageParser.h"

#pragma mark StatusPageParser

@implementation StatusPageParser

#pragma mark - Sync

- (AFHTTPRequestOperation *)syncOperationWithSuccess:(void (^)(NSDictionary *service))success failure:(void (^)(NSError *))failure {
    NSURLRequest *request = [NSURLRequest requestWithURL:self.URL];

    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    requestOperation.responseSerializer = [AFJSONResponseSerializer serializer];

    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableDictionary *service = [NSMutableDictionary dictionary];
        if ([responseObject[@"status"][@"indicator"] isEqualToString:@"none"]) {
            service[@"motd"] = responseObject[@"status"][@"description"];
            service[@"statusType"] = @(ServiceStatusOK);
        }

        if (success) {
            success(service);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];

    return requestOperation;
}

@end
