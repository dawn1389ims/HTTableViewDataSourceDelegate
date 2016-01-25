//
//  MyCustomHTTableViewDataSource.m
//  HeartTouchTableViewDataSourceDemo
//
//  Created by 志强 on 16/1/22.
//  Copyright © 2016年 志强. All rights reserved.
//

#import "MyCustomHTTableViewDataSource.h"
@interface MyCustomHTTableViewDataSource ()

@property (nonatomic, strong) id <HTTableViewDataSourceDataModelProtocol> data;

@end

@implementation MyCustomHTTableViewDataSource
/**
 *  使用父类的实现
 */
@dynamic data;

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    id model = [self.data ht_itemAtSection:section rowIndex:0];
    if ([model isKindOfClass:[NSString class]]) {
        UIButton * headerBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
        [headerBtn setTitle:@"header" forState:UIControlStateNormal];
        [headerBtn setBackgroundColor:[UIColor brownColor]];
        return headerBtn;
    } else {
        return nil;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    id model = [self.data ht_itemAtSection:section rowIndex:0];
    if ([model isKindOfClass:[NSString class]]) {
        UIButton * footerBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
        [footerBtn setTitle:@"footer" forState:UIControlStateNormal];
        [footerBtn setBackgroundColor:[UIColor orangeColor]];
        return footerBtn;
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    id model = [self.data ht_itemAtSection:section rowIndex:0];
    if ([model isKindOfClass:[NSString class]]) {
        return 40;
    } else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    id model = [self.data ht_itemAtSection:section rowIndex:0];
    if ([model isKindOfClass:[NSString class]]) {
        return 40;
    } else {
        return 0;
    }
}
@end
