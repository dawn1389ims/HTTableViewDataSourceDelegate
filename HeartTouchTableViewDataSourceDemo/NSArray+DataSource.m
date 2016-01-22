//
//  NSArray+DataSource.m
//  Demo
//
//  Created by 志强 on 16/1/18.
//  Copyright © 2016年 forkingdog. All rights reserved.
//

#import "NSArray+DataSource.h"
#import <objc/runtime.h>
@implementation NSArray (DataSource)

- (NSUInteger)sectionCount
{
    if ([self ht_is2DArray]) {
        return self.count;
    } else {
        return 1;
    }
}

- (NSUInteger)rowCountAtSectionIndex:(NSUInteger)section
{
    NSAssert2(section < self.count, @"section : %lu out bounds: %lu, rowCountAtSectionIndex", self.count, section);
    id item = [self objectAtIndex:section];
    if ([self ht_is2DArray]) {
        if ([item isKindOfClass:[NSArray class]]) {
            NSArray * array = item;
            return array.count;
        } else {
            return 1;
        }
    } else {
        /**
         *  一维数组时，section == 0，返回数组元素个数
         */
        NSAssert2(section == 0, @"not 2d array: %@ access section: %lu", self, section);
        return self.count;
    }
}

- (id)itemAtSection:(NSUInteger)section rowIndex:(NSUInteger)row
{
    NSAssert2(section < self.count, @"section : %lu out bounds: %lu, itemAtSection", self.count, section);
    
    id item = [self objectAtIndex:section];
    if ([self ht_is2DArray]) {
        if ([item isKindOfClass:[NSArray class]]) {
            NSArray * array = item;
            NSAssert2(row < array.count, @"2d array: %@ index out bound: %lu", array, [self indexOfObject:item]);
            return array[row];
        } else {
            NSAssert2(row < self.count, @"array: %@ index out bound: %lu", self, row);
            return item;
        }
    } else {
        NSAssert2(section == 0, @"not 2d array: %@ access section: %lu", self, section);
        return [self objectAtIndex:row];
    }
    
}

- (BOOL)ht_is2DArray
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setHt_is2DArray:(BOOL)is2DArray
{
    objc_setAssociatedObject(self, @selector(ht_is2DArray), @(is2DArray), OBJC_ASSOCIATION_RETAIN);
}

- (void)ht_check2DArray
{
    BOOL is2DArray = NO;
    for (id item in self) {
        if ([item isKindOfClass:[NSArray class]]) {
            is2DArray = YES;
        }
    }
    [self setHt_is2DArray:is2DArray];
}

@end
