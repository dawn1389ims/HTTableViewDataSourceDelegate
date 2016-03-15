//
//  HTTableViewCompositeDataSource.m
//  HeartTouchTableViewDataSourceDemo
//
//  Created by 志强 on 16/1/19.
//  Copyright © 2016年 志强. All rights reserved.
//

#import "HTTableViewCompositeDataSourceDelegate.h"
#import "HTTableViewDataSourceDataModelProtocol.h"

typedef id <UITableViewDataSource, UITableViewDelegate> HTDataSourceType;

@interface HTTableViewCompositeDataSourceDelegate()

/**
 *  visible section range <--> data index 的对应表
 */
@property (nonatomic, strong) NSDictionary <NSNumber *, NSValue *>* dataToSectionMap;

@end

@implementation HTTableViewCompositeDataSourceDelegate

+ (instancetype)dataSourceWithDataSources:(NSArray <UITableViewDataSource,UITableViewDelegate> *)dataSources;
{
    HTTableViewCompositeDataSourceDelegate *instance = [HTTableViewCompositeDataSourceDelegate new];
    if (instance){
        instance.dataSourceList = dataSources;
    }
    return instance;
}

- (NSInteger)sumSectionCalculateandShuffle:(UITableView*)tableview
{
    NSMutableDictionary * dataToSectionDic = [NSMutableDictionary new];
    NSInteger sumSection = 0;
    NSUInteger dataIndex = 0;
    for (int index = 0; index < _dataSourceList.count; index ++) {
        HTDataSourceType arg = _dataSourceList[index];
        BOOL isVisible = YES;
        if ([arg respondsToSelector:@selector(isHt_Visible)]) {
            id <HTTableViewDataSourceDelegateVisibleProtocol>visibleObj = (id)arg;
            isVisible = [visibleObj isHt_Visible];
        }
        if (isVisible) {
            NSInteger sectionLength = [arg numberOfSectionsInTableView:tableview];
            NSValue *rangeValue = [NSValue valueWithRange:NSMakeRange(sumSection, sectionLength)];
            sumSection += sectionLength;
            [dataToSectionDic setObject:rangeValue forKey:@(dataIndex)];
        }
        dataIndex ++;
    }
    _dataToSectionMap = dataToSectionDic;
    return sumSection;
}
/**
 *  根据section range <--> data index 的对应表查找到section对应的data index和 section的相对值
 */
- (HTDataSourceType)relativeDataSourceForTableViewSection:(NSUInteger)section
                                              trueSection:(NSUInteger*)trueSection
{
    __block NSUInteger dataSourceIndex;
    __block NSRange currentSectionRange;
    [_dataToSectionMap enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, NSValue * _Nonnull obj, BOOL * _Nonnull stop) {
        NSRange range = [obj rangeValue];
        if (NSLocationInRange(section, range)) {
            currentSectionRange = range;
            dataSourceIndex = [key integerValue];
            *stop = YES;
        }
    }];
    NSAssert2(dataSourceIndex >= 0, @"can't get right section: %lu from stage list: %@",section, _dataToSectionMap);
    
    HTDataSourceType dataSource = _dataSourceList[dataSourceIndex];
    *trueSection = section - currentSectionRange.location;
    return dataSource;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self sumSectionCalculateandShuffle:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSUInteger trueSection;
    HTDataSourceType dataSource = [self relativeDataSourceForTableViewSection:section
                                                           trueSection:&trueSection];
    return [dataSource tableView:tableView numberOfRowsInSection:trueSection];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger trueSection;
    HTDataSourceType dataSource = [self relativeDataSourceForTableViewSection:indexPath.section
                                                           trueSection:&trueSection];
    return [dataSource tableView:tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:trueSection]];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger trueSection;
    HTDataSourceType dataSource = [self relativeDataSourceForTableViewSection:indexPath.section
                                                           trueSection:&trueSection];
    return [dataSource tableView:tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:trueSection]];
}


@end