//
//  NSManagedObject+MagicalFetching.m
//  MagicalRecord
//
//  Created by Saul Mora on 9/15/13.
//  Copyright (c) 2013 Magical Panda Software LLC. All rights reserved.
//

#import "NSManagedObject+MagicalFetching.h"
#import "NSManagedObject+MagicalRequests.h"
#import "NSFetchedResultsController+MagicalFetching.h"

#import "MagicalRecordStack.h"

@implementation NSManagedObject (MagicalFetching)

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR

+ (NSString *) MR_fileCacheNameForObject:(id)object;
{
    SEL selector = @selector(fetchedResultsControllerCacheName);
    if ([object respondsToSelector:selector])
    {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[object methodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:object];
        [invocation invoke];
        NSString *returnValue = nil;
        [invocation getReturnValue:&returnValue];
        return returnValue;
    }
    return [NSString stringWithFormat:@"MagicalRecord-Cache-%@", NSStringFromClass([object class])];
}

+ (NSFetchedResultsController *) MR_fetchController:(NSFetchRequest *)request delegate:(id<NSFetchedResultsControllerDelegate>)delegate useFileCache:(BOOL)useFileCache groupedBy:(NSString *)groupKeyPath inContext:(NSManagedObjectContext *)context
{
    NSString *cacheName = useFileCache ? [self MR_fileCacheNameForObject:delegate] : nil;

	NSFetchedResultsController *controller =
    [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                        managedObjectContext:context
                                          sectionNameKeyPath:groupKeyPath
                                                   cacheName:cacheName];
    controller.delegate = delegate;

    return controller;
}

+ (NSFetchedResultsController *) MR_fetchAllGroupedBy:(NSString *)group withPredicate:(NSPredicate *)searchTerm sortedBy:(NSString *)sortTerm ascending:(BOOL)ascending delegate:(id<NSFetchedResultsControllerDelegate>)delegate inContext:(NSManagedObjectContext *)context
{
	NSFetchRequest *request = [self MR_requestAllSortedBy:sortTerm
                                                ascending:ascending
                                            withPredicate:searchTerm];

    NSFetchedResultsController *controller = [self MR_fetchController:request
                                                             delegate:delegate
                                                         useFileCache:NO
                                                            groupedBy:group
                                                            inContext:context];

    [controller MR_performFetch];
    return controller;
}

+ (NSFetchedResultsController *) MR_fetchAllGroupedBy:(NSString *)group withPredicate:(NSPredicate *)searchTerm sortedBy:(NSString *)sortTerm ascending:(BOOL)ascending delegate:(id)delegate
{
	return [self MR_fetchAllGroupedBy:group
                        withPredicate:searchTerm
                             sortedBy:sortTerm
                            ascending:ascending
                             delegate:delegate
                            inContext:[[MagicalRecordStack defaultStack] context]];
}

+ (NSFetchedResultsController *) MR_fetchAllGroupedBy:(NSString *)group withPredicate:(NSPredicate *)searchTerm sortedBy:(NSString *)sortTerm ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context;
{
    return [self MR_fetchAllGroupedBy:group
                        withPredicate:searchTerm
                             sortedBy:sortTerm
                            ascending:ascending
                             delegate:nil
                            inContext:context];
}

+ (NSFetchedResultsController *) MR_fetchAllGroupedBy:(NSString *)group withPredicate:(NSPredicate *)searchTerm sortedBy:(NSString *)sortTerm ascending:(BOOL)ascending
{
    return [self MR_fetchAllGroupedBy:group
                        withPredicate:searchTerm
                             sortedBy:sortTerm
                            ascending:ascending
                            inContext:[[MagicalRecordStack defaultStack] context]];
}


+ (NSFetchedResultsController *) MR_fetchAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm groupBy:(NSString *)groupingKeyPath inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [self MR_requestAllSortedBy:sortTerm
                                                ascending:ascending
                                            withPredicate:searchTerm];

	NSFetchedResultsController *controller = [self MR_fetchController:request
                                                             delegate:nil
                                                         useFileCache:NO
                                                            groupedBy:groupingKeyPath
                                                            inContext:[[MagicalRecordStack defaultStack] context]];

    [controller MR_performFetch];
    return controller;
}

+ (NSFetchedResultsController *) MR_fetchAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm groupBy:(NSString *)groupingKeyPath;
{
    return [self MR_fetchAllSortedBy:sortTerm
                           ascending:ascending
                       withPredicate:searchTerm
                             groupBy:groupingKeyPath
                           inContext:[[MagicalRecordStack defaultStack] context]];
}

+ (NSFetchedResultsController *) MR_fetchAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm groupBy:(NSString *)groupingKeyPath delegate:(id<NSFetchedResultsControllerDelegate>)delegate inContext:(NSManagedObjectContext *)context;
{
	return [self MR_fetchAllGroupedBy:groupingKeyPath
                        withPredicate:searchTerm
                             sortedBy:sortTerm
                            ascending:ascending
                             delegate:delegate
                            inContext:context];
}

+ (NSFetchedResultsController *) MR_fetchAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm groupBy:(NSString *)groupingKeyPath delegate:(id<NSFetchedResultsControllerDelegate>)delegate;
{
	return [self MR_fetchAllSortedBy:sortTerm
                           ascending:ascending
                       withPredicate:searchTerm
                             groupBy:groupingKeyPath
                            delegate:delegate
                           inContext:[[MagicalRecordStack defaultStack] context]];
}

#endif
@end
