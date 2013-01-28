//
//  MGPTableViewCell.m
//  NSBrief
//
//  Created by Saul Mora on 1/27/13.
//  Copyright (c) 2013 Magical Panda Software. All rights reserved.
//

#import "UITableViewCell+MGPAdditions.h"

@implementation UITableViewCell (MGPAdditions)


+ (NSString *)cellIdentifier;
{
    return NSStringFromClass([self class]);
}

+ (UINib *) nib;
{
    UINib *nib = [UINib nibWithNibName:[self cellIdentifier] bundle:[NSBundle mainBundle]];
    return nib;
}

+ (id) cellForTableView:(UITableView *)tableView;
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[self cellIdentifier]];
    if (cell == nil)
    {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[self cellIdentifier]];
    }
    return cell;
}

+ (id) cellForTableView:(UITableView *)tableView usingNib:(UINib *)nib;
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[self cellIdentifier]];
    if (cell == nil)
    {
        NSArray *views = [nib instantiateWithOwner:nil options:nil];
        cell = [views lastObject];
    }
    return cell;
}

@end
