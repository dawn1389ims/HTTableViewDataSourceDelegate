//
//  HTTableViewCompositeDataSource.m
//  HeartTouchTableViewDataSourceDemo
//
//  Created by 志强 on 16/1/19.
//  Copyright © 2016年 志强. All rights reserved.
//

#import "HTTableViewCompositeDataSourceDelegate.h"
#import "HTTableViewDataSourceDataModelProtocol.h"
#import <objc/runtime.h>

typedef id <UITableViewDataSource, UITableViewDelegate> HTDataSourceType;

@interface HTTableViewCompositeDataSourceDelegate()

/**
 *  data index <--> visible section range 的对应表
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
 *  根据data index <--> visible section range 的对应表查找到section对应的data index和 section的相对值
 */
- (HTDataSourceType)relativeDataSourceForTableViewSection:(NSUInteger)section
                                              trueSection:(NSUInteger*)trueSection
{
    __block NSInteger dataSourceIndex = -1;
    __block NSInteger currentSectionLoc = -1;
    [_dataToSectionMap enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, NSValue * _Nonnull obj, BOOL * _Nonnull stop) {
        NSRange range = [obj rangeValue];
        if (NSLocationInRange(section, range)) {
            currentSectionLoc = range.location;
            dataSourceIndex = [key integerValue];
            *stop = YES;
        }
    }];
    
    if (dataSourceIndex < 0) {
        NSLog(@"can't get right section: %lu from stage list: %@",section, _dataToSectionMap);
        return nil;
    }
    
    HTDataSourceType dataSource = _dataSourceList[dataSourceIndex];
    *trueSection = section - currentSectionLoc;
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

#define CheckProtocolContainSelector(selArg)\
(protocol_getMethodDescription(@protocol(UITableViewDelegate), selArg, NO, YES).name != NULL\
||\
protocol_getMethodDescription(@protocol(UITableViewDataSource), selArg, NO, YES).name != NULL)
/**
 *  没有实现的UITableViewDelegate的方法转发给tableViewDelegate
 */
-(BOOL)respondsToSelector:(SEL)selector
{
#define CheckOverridedSelector(selArg) if (selector == selArg) {return YES;}
    CheckOverridedSelector(@selector(numberOfSectionsInTableView:))
    CheckOverridedSelector(@selector(tableView:numberOfRowsInSection:))
    CheckOverridedSelector(@selector(tableView:cellForRowAtIndexPath:))
    CheckOverridedSelector(@selector(tableView:heightForRowAtIndexPath:))
    
    if (_tableViewDelegate && CheckProtocolContainSelector(selector)) {
        return [_tableViewDelegate respondsToSelector:selector];
    }
    return [super respondsToSelector:selector];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    if (_tableViewDelegate && CheckProtocolContainSelector(aSelector)) {
        return [(NSObject*)_tableViewDelegate methodSignatureForSelector:aSelector];
    }
    return [super methodSignatureForSelector:aSelector];
}

-(void)forwardInvocation:(NSInvocation *)anInvocation
{
    if (_tableViewDelegate && CheckProtocolContainSelector(anInvocation.selector)) {
        return [anInvocation invokeWithTarget:_tableViewDelegate];
    }
    [anInvocation invokeWithTarget:self];
}

@end
