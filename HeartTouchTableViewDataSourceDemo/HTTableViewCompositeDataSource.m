//
//  HTCompositeDataSource.m
//  HeartTouchTableViewDataSourceDemo
//
//  Created by 志强 on 16/1/19.
//  Copyright © 2016年 志强. All rights reserved.
//

#import "HTTableViewCompositeDataSource.h"
#import "MyTableViewCellModel.h"
#import "MyTableViewCell.h"

typedef id <UITableViewDataSource, UITableViewDelegate> HTDataSourceType;

@interface HTTableViewCompositeDataSource()

@property (nonatomic, strong) NSArray <HTDataSourceType > * dataSourceArray;
/**
 *  
 *  根据stage值取得dataSource 对应的 item index表
 *      section所在的stage index就是data source的index
 *  stageList最小元素为1
 */
@property (nonatomic, strong) NSArray <NSNumber *> * sectionStageNumList;

@end

@implementation HTCompositeDataSource

+ (instancetype)dataSourceWithDataSources:(NSArray < HTDataSourceType > *)dataSources;
{
    HTTableViewCompositeDataSource *instance = [HTTableViewCompositeDataSource new];
    if (instance){
        instance.dataSourceArray = dataSources;
    }
    return instance;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger sumSection = 0;
    NSMutableArray * sectionStageNumList = [NSMutableArray new];
    for (int index = 0; index < _dataSourceArray.count; index ++) {
        [sectionStageNumList addObject:@(sumSection)];
        HTDataSourceType arg = _dataSourceArray[index];
        sumSection += [arg numberOfSectionsInTableView:tableView];
    }
    _sectionStageNumList = sectionStageNumList;
    return sumSection;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSUInteger dataSourceIndex = [self dataSourceIndexForTableViewSection:section];
    NSInteger trueSection = section - [_sectionStageNumList[dataSourceIndex] integerValue];
    HTDataSourceType dataSource = _dataSourceArray[dataSourceIndex];
    return [dataSource tableView:tableView numberOfRowsInSection:trueSection];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger dataSourceIndex = [self dataSourceIndexForTableViewSection:indexPath.section];
    NSInteger trueSection = indexPath.section - [_sectionStageNumList[dataSourceIndex] integerValue];
    HTDataSourceType dataSource = _dataSourceArray[dataSourceIndex];
    return [dataSource tableView:tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:trueSection]];
}

/**
 *  比对section，查找台阶值列表，找到正确的dataSource index
 */
- (NSUInteger)dataSourceIndexForTableViewSection:(NSUInteger)section
{
    NSUInteger maxStageNum = -1;
    for (int index = 0; index < _sectionStageNumList.count; index ++) {
        NSUInteger stageNum = [_sectionStageNumList[index] integerValue];
        if (section >= stageNum) {
            maxStageNum = index;
            continue;//继续取得最大的台阶值
        } else {
            break;
        }
    }
    if (maxStageNum == -1) {
        NSAssert2(NO, @"can't get right section: %lu from stage list: %@",section, _sectionStageNumList);
        return -1;
    }
//    NSLog(@"calculate section: %lu ds=====>: %lu",section, maxStageNum);
    return maxStageNum;
}

@end