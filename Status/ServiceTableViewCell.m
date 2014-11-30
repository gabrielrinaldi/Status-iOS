//
//  ServiceTableViewCell.m
//  Status
//
//  Created by Gabriel Rinaldi on 12/30/13.
//  Copyright (c) 2013 Gabriel Rinaldi. All rights reserved.
//

#import "AppearanceManager.h"
#import "Service.h"
#import "ServiceTableViewCell.h"

#pragma mark ServiceTableViewCell (Private)

@interface ServiceTableViewCell () <ServiceDelegate> @end

#pragma mark - ServiceTableViewCell

@implementation ServiceTableViewCell

#pragma mark - Getters/Setters

- (void)setService:(Service *)service {
    _service = service;

    _service.delegate = self;

    [self updateCell];

    if (_service.isUpdating) {
        [self serviceDidStartUpdate:_service];
    }
}

#pragma mark - Initialization

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [[AppearanceManager defaultManager] backgroundColor];

        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.showsReorderControl = YES;

        UIImage *accessoryImage = [[UIImage imageNamed:@"DetailIndicator"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        UIImageView *accessoryImageView = [[UIImageView alloc] initWithImage:accessoryImage];
        self.accessoryView = accessoryImageView;

        self.textLabel.font = [UIFont fontWithName:@"Montserrat" size:16];
        self.textLabel.textColor = [[AppearanceManager defaultManager] textColor];
        self.textLabel.backgroundColor = [UIColor clearColor];

        self.detailTextLabel.font = [UIFont fontWithName:@"Montserrat" size:16];
        self.detailTextLabel.textColor = [[AppearanceManager defaultManager] lightTextColor];
        self.detailTextLabel.backgroundColor = [UIColor clearColor];
    }

    return self;
}

#pragma mark - Update cell

- (void)updateCell {
    UIImage *accessoryImage = [[UIImage imageNamed:@"DetailIndicator"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIImageView *accessoryImageView = [[UIImageView alloc] initWithImage:accessoryImage];
    self.accessoryView = accessoryImageView;

    self.textLabel.text = self.service.name;
    self.detailTextLabel.text = self.service.motd;
}

#pragma mark 

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];

    [UIView animateWithDuration:0.25 animations:^{
        if (highlighted) {
            self.backgroundColor = [UIColor colorWithRed:0.13 green:0.49 blue:0.36 alpha:1.0];
            self.detailTextLabel.textColor = [[AppearanceManager defaultManager] backgroundColor];
        } else {
            self.backgroundColor = [UIColor colorWithRed:0.14 green:0.14 blue:0.14 alpha:1.0];
            self.detailTextLabel.textColor = [[AppearanceManager defaultManager] lightTextColor];
        }
    }];
}

#pragma mark - Service delegate

- (void)serviceDidStartUpdate:(Service *)service {
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [activityIndicatorView startAnimating];
    self.accessoryView = activityIndicatorView;
}

- (void)service:(Service *)service didUpdateWithError:(NSError *)error {
    [self updateCell];
}

- (void)prepareForReuse {
    [super prepareForReuse];

    self.service.delegate = nil;
}

@end
