//
//  MyInterestList+HTTableViewDataSource.m
//  HeartTouchTableViewDataSourceDemo
//
//  Created by 志强 on 16/1/21.
//  Copyright © 2016年 志强. All rights reserved.
//

#import "MyInterestList+HTTableViewDataSource.h"
#import "MyTableViewCellModel.h"
#import <objc/runtime.h>


@implementation MyInterestList (HTTableViewDataSource)

- (NSUInteger)ht_sectionCount
{
    return [[self interestListDataArray] count];
}

- (NSUInteger)ht_rowCountAtSectionIndex:(NSUInteger)section
{
    NSArray * list = [self interestListDataArray][section];
    return list.count;
}

- (id)ht_itemAtSection:(NSUInteger)section rowIndex:(NSUInteger)row
{
    return [self interestListDataArray][section][row];
}

@end
