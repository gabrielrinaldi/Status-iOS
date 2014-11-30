//
//  ServicesViewController.h
//  Status
//
//  Created by Gabriel Rinaldi on 12/30/13.
//  Copyright (c) 2013 Gabriel Rinaldi. All rights reserved.
//

#pragma mark ServicesViewController

@interface ServicesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *servicesTableView;
@property (strong, nonatomic) IBOutlet UIProgressView *progressView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *progressViewBottomConstraint;

@end
