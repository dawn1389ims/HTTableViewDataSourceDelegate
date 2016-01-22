//
//  MyCustomHTTableViewDataSource.m
//  HeartTouchTableViewDataSourceDemo
//
//  Created by 志强 on 16/1/22.
//  Copyright © 2016年 志强. All rights reserved.
//

#import "MyCustomHTTableViewDataSource.h"

@implementation MyCustomHTTableViewDataSource

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIButton * headerBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    [headerBtn setBackgroundColor:[UIColor brownColor]];
    return headerBtn;
}
@end
