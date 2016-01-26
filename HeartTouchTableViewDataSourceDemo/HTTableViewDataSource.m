//
//  HTArrayDataSource.m
//  Demo
//
//  Created by 志强 on 16/1/18.
//  Copyright © 2016年 志强. All rights reserved.
//

#import "HTTableViewDataSource.h"
#import "MyTableViewCellModel.h"
#import "MyTableViewCell.h"
#import "NSArray+DataSource.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "HTTableViewCellModelProtocol.h"

@interface HTTableViewDataSource()

@property (nonatomic, strong) id <HTTableViewDataSourceDataModelProtocol> data;

@property (nonatomic, copy) NSDictionary < NSString * , NSString *> * cellTypeMaps;

@property (nonatomic, copy) HTTableViewConfigBlock cellConfiguration;

@end

@implementation HTTableViewDataSource

+ (instancetype)dataSourceWithModel:(id < HTTableViewDataSourceDataModelProtocol >)model
                        cellTypeMap:(NSDictionary < NSString * , NSString *> *)cellTypeMap
                  cellConfiguration:(HTTableViewConfigBlock)configuration
{
    HTTableViewDataSource *instance = [[self class] new];
    if (instance){
        instance.data = model;
        instance.cellTypeMaps = cellTypeMap;
        instance.cellConfiguration = configuration;
    }
    return instance;
}

- (NSString*)cellIdentifierForCellModelClass:(id)cellModel{
    NSString * identifier;
    NSArray * keyList = _cellTypeMaps.allKeys;
    for (NSString * arg in keyList) {
        if ([cellModel isKindOfClass:NSClassFromString(arg)]) {
            identifier = _cellTypeMaps[arg];
        }
    }
    NSAssert2(identifier, @"Can't find cell identifier for: %@ at cellTypeMap: %@", cellModel, _cellTypeMaps);
    return identifier;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowNum = [_data ht_rowCountAtSectionIndex:section];
    return rowNum;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id model = [_data ht_itemAtSection:indexPath.section rowIndex:indexPath.row];
    NSString *identifier = [self cellIdentifierForCellModelClass:model];
    
    id <HTTableViewCellModelProtocol> cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        Class cellClass = NSClassFromString(identifier);
        NSAssert1(cellClass, @"Cell with identifier: %@ not find corresponding cell class", identifier);
        cell = [[cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NSAssert1([cell respondsToSelector:@selector(setModel:)], @"Cell with class: %@ not implement method 'setModel:'", [cell class]);
    
    [cell setModel:model];
    if (self.cellConfiguration) {
        self.cellConfiguration(cell, indexPath);
    }
    return (UITableViewCell *)cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_data ht_sectionCount];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id model = [_data ht_itemAtSection:indexPath.section rowIndex:indexPath.row];
    NSString *identifier = [self cellIdentifierForCellModelClass:model];
    /**
     *  UITableViewCell高度计算接口规范
     *  https://git.hz.netease.com/hzzhangping/heartouch/blob/master/specification/ios/UITableViewCell%E9%AB%98%E5%BA%A6%E8%AE%A1%E7%AE%97%E6%8E%A5%E5%8F%A3%E8%A7%84%E8%8C%83.md
     */
    CGFloat heightResult =  [tableView fd_heightForCellWithIdentifier:identifier
                                                        configuration:
                             ^(id <HTTableViewCellModelProtocol>cell)
    {
        NSAssert1([cell respondsToSelector:@selector(setModel:)], @"Cell with class: %@ not implement method 'setModel:'", [cell class]);
        [cell setModel:model];
        if (self.cellConfiguration) {
            self.cellConfiguration(cell, indexPath);
        }
    }];
    return heightResult;
}
@end
