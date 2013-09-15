//
//  MGPTableViewController.h
//  NSBrief
//
//  Created by Saul Mora on 1/27/13.
//  Copyright (c) 2013 Magical Panda Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MGPFetchedResultsTableViewControllerDelegate <NSObject>

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath usingResults:(NSFetchedResultsController *)results;
- (void) configureCell:(UITableViewCell *)cell forObject:(id)object atIndexPath:(NSIndexPath *)indexPath;

@end

@interface MGPFetchedResultsTableViewController : UIViewController<NSFetchedResultsControllerDelegate>

@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, weak) id<MGPFetchedResultsTableViewControllerDelegate> delegate;

@end
