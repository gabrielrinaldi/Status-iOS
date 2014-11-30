//
//  AppearanceManager.h
//  Status
//
//  Created by Gabriel Rinaldi on 1/14/14.
//  Copyright (c) 2014 Gabriel Rinaldi. All rights reserved.
//

#pragma mark AppearanceManager

@interface AppearanceManager : NSObject

@property (strong, nonatomic, readonly) UIColor *tintColor;
@property (strong, nonatomic, readonly) UIColor *accentColor;
@property (strong, nonatomic, readonly) UIColor *backgroundColor;
@property (strong, nonatomic, readonly) UIColor *highlightedBackgroundColor;
@property (strong, nonatomic, readonly) UIColor *textColor;
@property (strong, nonatomic, readonly) UIColor *lightTextColor;
@property (strong, nonatomic, readonly) UIColor *disabledColor;
@property (strong, nonatomic, readonly) UIColor *greenColor;
@property (strong, nonatomic, readonly) UIColor *yellowColor;
@property (strong, nonatomic, readonly) UIColor *redColor;

+ (instancetype)defaultManager;

@end
