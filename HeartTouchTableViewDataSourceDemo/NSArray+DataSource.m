//
//  NSArray+DataSource.m
//  Demo
//
//  Created by 志强 on 16/1/18.
//  Copyright © 2016年 forkingdog. All rights reserved.
//

#import "NSArray+DataSource.h"
/**
 *  NSArray 暂时不支持二维数组的。
 *  sectionCount > 1时，这个array是二维(2D)数组，同时支持两种情况需要鉴别二维和一维，略纠结，等后面有需要时再实现
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
