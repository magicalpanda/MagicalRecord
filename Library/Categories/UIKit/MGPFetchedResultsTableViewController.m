//
//  MGPTableViewController.m
//  NSBrief
//
//  Created by Saul Mora on 1/27/13.
//  Copyright (c) 2013 Magical Panda Software. All rights reserved.
//

#import "MGPFetchedResultsTableViewController.h"
#import "UITableViewCell+MGPAdditions.h"
#import "MGPDelegateManager.h"


@interface MGPFetchedResultsTableViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) UITableViewStyle style;
@property (nonatomic, strong) MGPDelegateManager *delegateManager;


- (NSFetchedResultsController *) fetchedResultsControllerForTableView:(UITableView *)tableView;
- (void) configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath usingResults:(NSFetchedResultsController *)results;

@end


@implementation MGPFetchedResultsTableViewController

- (id) init;
{
    return [self initWithStyle:UITableViewStylePlain];
}

- (id) initWithStyle:(UITableViewStyle)style;
{
    self = [super init];
    if (self)
    {
        _style = style;
        _delegateManager = [[MGPDelegateManager alloc] init];
    }
    return self;
}

-(void)setDelegate:(id)delegate;
{
    self.delegateManager.proxiedObject = delegate;
}

-(id)delegate;
{
    return self.delegateManager.proxiedObject;
}

-(void)loadView;
{
    UIView *container = [[UIView alloc] initWithFrame:CGRectZero];
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:self.style];

    tableView.autoresizingMask =
        UIViewAutoresizingFlexibleBottomMargin |
        UIViewAutoresizingFlexibleHeight |
        UIViewAutoresizingFlexibleLeftMargin |
        UIViewAutoresizingFlexibleRightMargin |
        UIViewAutoresizingFlexibleTopMargin |
        UIViewAutoresizingFlexibleWidth;

    tableView.delegate = self;
    tableView.dataSource = self;

    [container addSubview:tableView];
    
    self.tableView = tableView;
    self.view = container;
}

-(void)viewWillLayoutSubviews;
{
    //    [super viewWillLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

- (void)viewDidAppear:(BOOL)animated;
{
    [super viewDidAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:animated];
}

- (NSFetchedResultsController *) fetchedResultsControllerForTableView:(UITableView *)tableView;
{
    return self.fetchedResultsController;
}

- (UITableView *) tableViewForResultsController:(NSFetchedResultsController *)controller;
{
    return controller == self.fetchedResultsController ? self.tableView : self.searchDisplayController.searchResultsTableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger count = [[[self fetchedResultsControllerForTableView:tableView] sections] count];

    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = 0;
    NSFetchedResultsController *fetchController = [self fetchedResultsControllerForTableView:tableView];
    NSArray *sections = [fetchController sections];
    if(sections.count > 0)
    {
        id <NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:section];
        numberOfRows = [sectionInfo numberOfObjects];
    }

    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSFetchedResultsController *results = [self fetchedResultsControllerForTableView:tableView];

    Class tableCellClass = [self cellTypeForResults:results] ?: [UITableViewCell class];
    UITableViewCell *cell = [tableCellClass cellForTableView:tableView];
    [self configureCell:cell atIndexPath:indexPath usingResults:results];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [self.delegate tableView:tableView didSelectRowAtIndexPath:indexPath usingResults:[self fetchedResultsControllerForTableView:tableView]];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSFetchedResultsController *results = [self fetchedResultsControllerForTableView:tableView];
    return [self tableView:tableView heightForRowAtIndexPath:indexPath usingResults:results];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
{
    NSFetchedResultsController *results = [self fetchedResultsControllerForTableView:tableView];
    id<NSFetchedResultsSectionInfo> sectionInfo = [[results sections] objectAtIndex:section];
    return [sectionInfo name];
}

- (Class) cellTypeForResults:(NSFetchedResultsController *)results;
{
    return [UITableViewCell class];
}

- (void) configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath usingResults:(NSFetchedResultsController *)results;
{
    [self.delegate configureCell:cell forObject:[results objectAtIndexPath:indexPath] atIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath usingResults:(NSFetchedResultsController *)results;
{
    return tableView.rowHeight;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    UITableView *tableView = [self tableViewForResultsController:controller];
    [tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type
{
    UITableView *tableView = [self tableViewForResultsController:controller];

    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeDelete:
            [tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)theIndexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = [self tableViewForResultsController:controller];

    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:theIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:theIndexPath] atIndexPath:theIndexPath usingResults:controller];
            break;

        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:theIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    UITableView *tableView = [self tableViewForResultsController:controller];
    [tableView endUpdates];
}

@end
