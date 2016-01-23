//
//  NSArray+DataSource.m
//  Demo
//
//  Created by 志强 on 16/1/18.
//  Copyright © 2016年 forkingdog. All rights reserved.
//

#import "NSArray+DataSource.h"
/**
 *  NSArray 暂时不支持二维数组的。有需要支持sectinCount > 1的情况需要在需要的类中实现下面的接口
 *  一维数组的sectionCount 永远为 1
 */

@implementation NSArray (DataSource)

- (NSUInteger)ht_sectionCount
{
    return 1;
}

- (NSUInteger)ht_rowCountAtSectionIndex:(NSUInteger)section
{
    NSAssert(section == 0, @"Only support 1D array temporary!");
    return self.count;
}

- (id)ht_itemAtSection:(NSUInteger)section rowIndex:(NSUInteger)row
{
    NSAssert(section == 0, @"Only support 1D array temporary!");
    return [self objectAtIndex:row];
}

@end
