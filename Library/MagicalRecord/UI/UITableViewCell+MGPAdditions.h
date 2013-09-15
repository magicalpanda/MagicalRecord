//
//  MGPTableViewCell.h
//  NSBrief
//
//  Created by Saul Mora on 1/27/13.
//  Copyright (c) 2013 Magical Panda Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (MGPAdditions)

+ (id) cellForTableView:(UITableView *)tableView;
+ (id) cellForTableView:(UITableView *)tableView usingNib:(UINib *)nib;

@end
