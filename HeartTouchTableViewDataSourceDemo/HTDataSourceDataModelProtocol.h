//
//  HTDataSourceDataModelProtocol.h
//  HeartTouchTableViewDataSourceDemo
//
//  Created by 志强 on 16/1/21.
//  Copyright © 2016年 志强. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  一个可以展示为列表的对象需要满足的协议。
 */
@protocol HTDataSourceDataModelProtocol <NSObject>

- (NSUInteger)sectionCount;

- (NSUInteger)rowCountAtSectionIndex:(NSUInteger)section;

- (id)itemAtSection:(NSUInteger)section rowIndex:(NSUInteger)row;

@end
