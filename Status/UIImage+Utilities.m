//
//  UIImage+Utilities.m
//  Status
//
//  Created by Gabriel Rinaldi on 12/30/13.
//  Copyright (c) 2013 Gabriel Rinaldi. All rights reserved.
//

#import "UIImage+Utilities.h"

#pragma mark UIImage (Utilities)

@implementation UIImage (Utilities)

#pragma mark - Image with color

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

@end
