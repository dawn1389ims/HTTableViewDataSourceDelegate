//
//  HTArrayDataSource.m
//  Demo
//
//  Created by 志强 on 16/1/18.
//  Copyright © 2016年 forkingdog. All rights reserved.
//

#import "HTTableViewDataSource.h"
#import "MyTableViewCellModel.h"
#import "MyTableViewCell.h"
#import "NSArray+DataSource.h"

@interface HTTableViewDataSource()

@property (nonatomic, strong) NSArray <HTTableViewDataSourceDataModelProtocol> * data;

@property (nonatomic, copy) NSDictionary *cellTypeMaps;

@property (nonatomic, copy) HTTableViewConfigBlock cellConfiguration;

@end

@implementation HTTableViewDataSource

+ (instancetype)dataSourceWithModel:(NSArray < HTTableViewDataSourceDataModelProtocol > *)model
                        cellTypeMap:(NSDictionary *)cellTypeMap
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
    if ([cellModel isKindOfClass:[NSArray class]]) {
        //
    }
    NSAssert1(identifier, @"can find cell identifier for: %@", cellModel);
    
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
    
    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    [cell setModel:model];
    
    if (self.cellConfiguration) {
        self.cellConfiguration(cell, indexPath);
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_data ht_sectionCount];
}

@end
