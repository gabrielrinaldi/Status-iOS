//
//  ServicesViewController.m
//  Status
//
//  Created by Gabriel Rinaldi on 12/30/13.
//  Copyright (c) 2013 Gabriel Rinaldi. All rights reserved.
//

#import <SVPullToRefresh/SVPullToRefresh.h>
#import "STAppDelegate.h"
#import "Services.h"
#import "ServiceTableViewCell.h"
#import "ServicesViewController.h"

static NSString *kServiceCellReuseIdentifier = @"ServiceCellReuseIdentifier";

#pragma mark ServicesViewController (Private)

@interface ServicesViewController () <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic, readonly) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic, readonly) UIBarButtonItem *settingsBarButtonItem;
@property (strong, nonatomic, readonly) UIBarButtonItem *addBarButtonItem;
@property (strong, nonatomic, readonly) UIBarButtonItem *editBarButtonItem;
@property (strong, nonatomic, readonly) UIBarButtonItem *doneBarButtonItem;

- (void)configureCell:(ServiceTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end

#pragma mark - ServicesViewController

@implementation ServicesViewController

#pragma mark - Getters/Setters

@synthesize fetchedResultsController;
@synthesize settingsBarButtonItem;
@synthesize addBarButtonItem;
@synthesize editBarButtonItem;
@synthesize doneBarButtonItem;

- (NSFetchedResultsController *)fetchedResultsController {
    if (!fetchedResultsController) {
        STAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *managedObjectContext = appDelegate.managedObjectContext;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Service"];

        NSSortDescriptor *typeSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"statusType" ascending:YES];
        NSSortDescriptor *nameSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        fetchRequest.sortDescriptors = @[ typeSortDescriptor, nameSortDescriptor ];
        fetchRequest.includesPendingChanges = NO;

        fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:@"statusType" cacheName:nil];
        fetchedResultsController.delegate = self;

        NSError *error;
        if (![fetchedResultsController performFetch:&error]) {
            // TODO: Handle error
        }
    }

    return fetchedResultsController;
}

- (UIBarButtonItem *)settingsBarButtonItem {
    return [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"SettingsIcon"] style:UIBarButtonItemStylePlain target:self action:nil];
}

- (UIBarButtonItem *)addBarButtonItem {
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:nil];
}

- (UIBarButtonItem *)editBarButtonItem {
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(edit)];
}

- (UIBarButtonItem *)doneBarButtonItem {
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
}

#pragma mark - Button actions

- (void)edit {
    [self.servicesTableView setEditing:YES animated:YES];

    [self.navigationItem setLeftBarButtonItem:self.addBarButtonItem animated:YES];
    [self.navigationItem setRightBarButtonItem:self.doneBarButtonItem animated:YES];
}

- (void)done {
    [self.servicesTableView setEditing:NO animated:YES];

    [self.navigationItem setLeftBarButtonItem:self.settingsBarButtonItem animated:YES];
    [self.navigationItem setRightBarButtonItem:self.editBarButtonItem animated:YES];
}

- (void)refresh {
    self.progressView.progress = 0;

    [[Services sharedServices] syncWithProgressBlock:^(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations) {
        [self.progressView setProgress:((float)numberOfFinishedOperations / (float)totalNumberOfOperations) animated:YES];
    } completionBlock:^(NSArray *operations) {
        [self.servicesTableView.pullToRefreshView stopAnimating];

        self.progressView.tintColor = [Services colorForServiceStatusType:ServiceStatusOK];
    }];
}

#pragma mark - Cell

- (void)configureCell:(ServiceTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Service *service = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.service = service;
}

#pragma mark - Table view data sorce

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([[self.fetchedResultsController sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
        return [sectionInfo numberOfObjects];
    }

    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ([[self.fetchedResultsController sections] count] > 0) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];

        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
        headerView.backgroundColor = [Services colorForServiceStatusType:[[sectionInfo name] intValue]];

        return headerView;
    }

    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ServiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kServiceCellReuseIdentifier];

    [self configureCell:cell atIndexPath:indexPath];

    return cell;
}

#pragma mark - Table view delegate

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    
}

#pragma mark - Fetched results controller delegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.servicesTableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.servicesTableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeDelete:
            [self.servicesTableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    UITableView *tableView = self.servicesTableView;

    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeUpdate:
            [self configureCell:(ServiceTableViewCell *)[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;

        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.servicesTableView endUpdates];
}

#pragma mark - View lifecycle

- (void)loadView {
    [super loadView];

    self.title = NSLocalizedString(@"ServicesScreenTitle", @"Screen titles");
    self.view.backgroundColor = [UIColor colorWithRed:0.14 green:0.14 blue:0.14 alpha:1.0];

    self.navigationItem.leftBarButtonItem = self.settingsBarButtonItem;
    self.navigationItem.rightBarButtonItem = self.editBarButtonItem;

    [self.servicesTableView registerClass:[ServiceTableViewCell class] forCellReuseIdentifier:kServiceCellReuseIdentifier];
    self.servicesTableView.backgroundColor = [UIColor colorWithRed:0.14 green:0.14 blue:0.14 alpha:1.0];
    self.servicesTableView.separatorColor = [UIColor colorWithRed:0.18 green:0.18 blue:0.18 alpha:1.0];
    self.servicesTableView.tableFooterView = [UIView new];

    __block ServicesViewController *safeSelf = self;
    [self.servicesTableView addPullToRefreshWithActionHandler:^{
        [safeSelf refresh];
    }];

//    self.progressView.tintColor = [UIColor colorWithRed:0.35 green:0.60 blue:0.66 alpha:1.0];
    self.progressView.progressTintColor = [UIColor colorWithRed:0.35 green:0.60 blue:0.66 alpha:1.0];
//    self.progressView.trackTintColor = [UIColor clearColor];

    [self.servicesTableView triggerPullToRefresh];
}

@end
