//
//  Parser.m
//  Status
//
//  Created by Gabriel Rinaldi on 1/12/14.
//  Copyright (c) 2014 Gabriel Rinaldi. All rights reserved.
//

#import "Parser.h"

#pragma mark Parser

@implementation Parser

#pragma mark - Initialization

- (id)init {
    return [self initWithURL:nil];
}

- (id)initWithURL:(NSURL *)URL {
    self = [super init];
    if (self) {
        self.URL = URL;

        NSAssert(![[[self class] description] isEqualToString:@"Parser"], @"This class has to be subclassed");
    }

    return self;
}

#pragma mark - Sync

- (AFHTTPRequestOperation *)syncOperationWithSuccess:(void (^)(NSDictionary *service))success failure:(void (^)(NSError *))failure {
    @throw [NSException exceptionWithName:@"ParserNotImplemented" reason:@"You need to subclass this method in your parser class" userInfo:nil];

    return nil;
}

@end
