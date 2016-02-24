//
//  MyCustomHTTableViewDataSource.m
//  HeartTouchTableViewDataSourceDemo
//
//  Created by 志强 on 16/1/22.
//  Copyright © 2016年 志强. All rights reserved.
//

#import "MyCustomHTTableViewDataSource.h"
#import "MyCellStringModel.h"

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
    if (section == 1) {
        MyCellStringModel * model = [self.data ht_itemAtSection:section rowIndex:0];
        
        static NSString *kHeadView = @"headerView";
        UITableViewHeaderFooterView *myHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kHeadView];
        if(!myHeader) {
            myHeader = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:kHeadView];
        }
        
        myHeader.textLabel.text = [@"Header" stringByAppendingFormat:@" for %@",model.title];
        [myHeader setFrame:CGRectMake(0, 0, tableView.frame.size.width, [self tableView:tableView heightForHeaderInSection:section])];
        return myHeader;
    } else {
        return nil;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        MyCellStringModel * model = [self.data ht_itemAtSection:section rowIndex:0];
        
        static NSString *kFootView = @"footerView";
        UITableViewHeaderFooterView *myFooter = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kFootView];
        if(!myFooter) {
            myFooter = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:kFootView];
        }
        
        myFooter.textLabel.text = [@"Footer" stringByAppendingFormat:@" for %@",model.title];
        [myFooter setFrame:CGRectMake(0, 0, tableView.frame.size.width, [self tableView:tableView heightForHeaderInSection:section])];
        return myFooter;
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 30;
    } else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return 30;
    } else {
        return 0;
    }
}

@end
