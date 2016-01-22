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

@interface HTTableViewDataSource()

@property (nonatomic, strong) id<HTDataSourceArrayProtocol> data;

@property (nonatomic, copy) NSDictionary *cellTypeMaps;

@property (nonatomic, copy) void(^cellConfiguration)(UITableViewCell * cell, NSIndexPath * indexPath);

@end

@implementation HTTableViewDataSource

+ (instancetype)dataSourceWithArray:(id < HTDataSourceArrayProtocol >)array
                        cellTypeMap:(NSDictionary *)cellTypeMap
                  cellConfiguration:(void(^)(UITableViewCell * cell, NSIndexPath * indexPath))configuration
{
    HTTableViewDataSource *instance = [HTTableViewDataSource new];
    if (instance){
        instance.data = array;
        instance.cellTypeMaps = cellTypeMap;
        instance.cellConfiguration = configuration;
    }
    return instance;
}

- (NSString*)cellIdentifierForRowIndexPath:(NSIndexPath*)indexPath{
    id model = [_data itemAtSection:indexPath.section rowIndex:indexPath.row];
    NSString * identifier;
    NSArray * keyList = _cellTypeMaps.allKeys;
#warning string的class不一定是NSSting, 使用model的类簇而不是class.禁止使用父类！
    for (NSString * arg in keyList) {
        if ([model isKindOfClass:NSClassFromString(arg)]) {
            identifier = _cellTypeMaps[arg];
        }
    }
    NSAssert1(identifier, @"can find cell identifier for: %@", [model class]);
    return identifier;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_data rowCountAtSectionIndex:section];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [self cellIdentifierForRowIndexPath:indexPath];
    
    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    id model = [_data itemAtSection:indexPath.section rowIndex:indexPath.row];
    [cell setModel:model];
    
    if (self.cellConfiguration) {
        self.cellConfiguration(cell, indexPath);
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_data sectionCount];
}

//delegate

@end
