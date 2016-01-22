//
//  NSArray+DataSource.m
//  Demo
//
//  Created by 志强 on 16/1/18.
//  Copyright © 2016年 forkingdog. All rights reserved.
//

#import "NSArray+DataSource.h"

@implementation NSArray (DataSource)



- (NSUInteger)sectionCount
{
    return 1;
}

- (NSUInteger)rowCountAtSectionIndex:(NSUInteger)section
{
    NSArray(section == 0);
    return self.count;
}

- (id)itemAtSection:(NSUInteger)section rowIndex:(NSUInteger)row
{
    return self[row];
}

@end
