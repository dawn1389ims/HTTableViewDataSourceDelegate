//
//  HTArrayDataSource.m
//  Demo
//
//  Created by 志强 on 16/1/18.
//  Copyright © 2016年 志强. All rights reserved.
//

#import "HTTableViewDataSourceDelegate.h"
#import "NSArray+DataSource.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "HTTableViewCellModelProtocol.h"
#import <objc/runtime.h>
@interface HTTableViewDataSourceDelegate()

@property (nonatomic, copy) NSDictionary < NSString * , NSString *> * cellTypeMaps;

@property (nonatomic, copy) HTTableViewConfigBlock cellConfiguration;

@property (nonatomic, weak) id <UITableViewDelegate> tableViewDelegate;

@end

@implementation HTTableViewDataSourceDelegate

+ (instancetype)dataSourceWithModel:(id < HTTableViewDataSourceDataModelProtocol >)model
                        cellTypeMap:(NSDictionary < NSString * , NSString *> *)cellTypeMap
                  tableViewDelegate:(id <UITableViewDelegate>)tableViewDelegate
                  cellConfiguration:(HTTableViewConfigBlock)configuration

{
    HTTableViewDataSourceDelegate *instance = [[self class] new];
    if (instance){
        instance.model = model;
        instance.cellTypeMaps = cellTypeMap;
        instance.tableViewDelegate = tableViewDelegate;
        instance.cellConfiguration = configuration;
    }
    return instance;
}

- (NSString*)cellIdentifierForCellModelClass:(id)cellModel{
    __block NSString * identifier;
    [_cellTypeMaps enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        if ([cellModel isKindOfClass:NSClassFromString(key)]) {
            identifier = obj;
            *stop = YES;
        }
    }];
    
    NSAssert2(identifier, @"Can't find cell identifier for: %@ at cellTypeMap: %@", cellModel, _cellTypeMaps);
    return identifier;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowNum = [_model ht_rowCountAtSectionIndex:section];
    return rowNum;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id model = [_model ht_itemAtSection:indexPath.section rowIndex:indexPath.row];
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
    return [_model ht_sectionCount];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id model = [_model ht_itemAtSection:indexPath.section rowIndex:indexPath.row];
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

#pragma mark - 转发 UITableViewDelegate 消息到 tableViewDelegate中

/**
 *  没有实现的UITableViewDelegate的方法转发给tableViewDelegate
 */
-(BOOL)respondsToSelector:(SEL)selector
{
    if ([self checkProtocol:@protocol(UITableViewDelegate) containSelector:selector]) {
        return [_tableViewDelegate respondsToSelector:selector];
    }
    return [super respondsToSelector:selector];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    if ([self checkProtocol:@protocol(UITableViewDelegate) containSelector:aSelector]) {
        return [(NSObject*)_tableViewDelegate methodSignatureForSelector:aSelector];
    }
    return [self methodSignatureForSelector:aSelector];
}

-(void)forwardInvocation:(NSInvocation *)anInvocation
{
    if ([self checkProtocol:@protocol(UITableViewDelegate) containSelector:anInvocation.selector]) {
        return [anInvocation invokeWithTarget:_tableViewDelegate];
    }
    [anInvocation invokeWithTarget:self];
}

- (BOOL)checkProtocol:(Protocol*)pro containSelector:(SEL)sel
{
    struct objc_method_description hasMethod = protocol_getMethodDescription(pro, sel, NO, YES);
    
    return hasMethod.name != NULL;
}
@end