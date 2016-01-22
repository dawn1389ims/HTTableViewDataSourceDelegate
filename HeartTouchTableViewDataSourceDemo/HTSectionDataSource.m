//
//  HTSectionDataSource.m
//  HeartTouchTableViewDataSourceDemo
//
//  Created by 志强 on 16/1/18.
//  Copyright © 2016年 志强. All rights reserved.
//

#import "HTSectionDataSource.h"

@interface HTSectionDataSource ()

@property (nonatomic, strong) NSArray * items;

@property (nonatomic, assign) NSInteger section;

@end

@implementation HTSectionDataSource

- (instancetype)initWithSection:(NSInteger)section List:(NSArray*)items
{
    self = [super init];
    if (self) {
        _section = section;
        _items = items;
    }
    return self;
}

- (NSInteger)itemCount
{
    return _items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
             cellForRowAtIndex:(NSInteger)index
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HTTemplateTableViewCell" forIndexPath:[NSIndexPath indexPathForRow:index inSection:_section]];
    
    id model = _items[index];
    
    return cell;
}

@end
