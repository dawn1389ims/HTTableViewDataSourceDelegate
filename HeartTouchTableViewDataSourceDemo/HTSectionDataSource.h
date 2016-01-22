//
//  HTSectionDataSource.h
//  HeartTouchTableViewDataSourceDemo
//
//  Created by 志强 on 16/1/18.
//  Copyright © 2016年 志强. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTSectionDataSource : NSObject

- (NSInteger)section;

- (NSInteger)itemCount;

- (UITableViewCell *)tableView:(UITableView *)tableView
             cellForRowAtIndex:(NSInteger)index;

@end
