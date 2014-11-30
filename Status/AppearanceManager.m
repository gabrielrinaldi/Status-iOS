//
//  AppearanceManager.m
//  Status
//
//  Created by Gabriel Rinaldi on 1/14/14.
//  Copyright (c) 2014 Gabriel Rinaldi. All rights reserved.
//

#import "UIImage+Utilities.h"
#import "AppearanceManager.h"

#pragma mark AppearanceManager

@implementation AppearanceManager

#pragma mark - Getters/Setters

- (UIColor *)tintColor {
    return [UIColor whiteColor];
}

- (UIColor *)accentColor {
    return [UIColor colorWithRed:0.18 green:0.18 blue:0.18 alpha:1.0];
}

- (UIColor *)backgroundColor {
    return [UIColor colorWithRed:0.14 green:0.14 blue:0.14 alpha:1.0];
}

- (UIColor *)highlightedBackgroundColor {
    return [UIColor colorWithRed:0.13 green:0.49 blue:0.36 alpha:1.0];
}

- (UIColor *)textColor {
    return [UIColor whiteColor];
}

- (UIColor *)lightTextColor {
    return [UIColor colorWithRed:0.40 green:0.40 blue:0.40 alpha:1.0];
}

- (UIColor *)disabledColor {
    return [UIColor colorWithRed:0.35 green:0.60 blue:0.66 alpha:1.0];
}

- (UIColor *)greenColor {
    return [UIColor colorWithRed:0.15 green:0.33 blue:0.36 alpha:1.0];
}

- (UIColor *)yellowColor {
    return [UIColor colorWithRed:0.87 green:0.53 blue:0.31 alpha:1.0];
}

- (UIColor *)redColor {
    return [UIColor colorWithRed:0.90 green:0.43 blue:0.41 alpha:1.0];
}

#pragma mark - Default manager

+ (instancetype)defaultManager {
    static AppearanceManager *_defaultManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _defaultManager = [[self alloc] init];
    });

    return _defaultManager;
}

#pragma mark - Initialization

- (id)init {
    self = [super init];
    if (self) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        [[UINavigationBar appearance] setBarTintColor:self.backgroundColor];
        [[UINavigationBar appearance] setShadowImage:[UIImage imageWithColor:self.accentColor]];
        [[UINavigationBar appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : self.textColor, NSFontAttributeName : [UIFont fontWithName:@"Montserrat-Bold" size:16] }];
    }

    return self;
}

@end
