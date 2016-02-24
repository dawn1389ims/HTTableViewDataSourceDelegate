//
//  MyDemoCellDelegateViewController.m
//  HeartTouchTableViewDataSourceDemo
//
//  Created by 志强 on 16/2/23.
//  Copyright © 2016年 志强. All rights reserved.
//

#import "MyDemoCellDelegateViewController.h"
#import "HTTableViewDataSource.h"
#import "MyCellStringModel.h"
#import "MyTableViewCellModel.h"
#import "MyCustomHTTableViewDataSource.h"
#import "MyInterestList.h"
#import "MyInterestList+HTTableViewDataSource.h"
#import "MyTableViewCell.h"
#import "MyDelegateTableViewCell.h"
@interface MyDemoCellDelegateViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic ,strong) id demoDataSource;

@end

@implementation MyDemoCellDelegateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //注册cell
    UINib * nib = [UINib nibWithNibName:@"MyTableViewCell" bundle:[NSBundle mainBundle]];
    [_tableview registerNib:nib forCellReuseIdentifier:@"MyTableViewCell"];
    
    nib = [UINib nibWithNibName:@"MyDelegateTableViewCell" bundle:[NSBundle mainBundle]];
    [_tableview registerNib:nib forCellReuseIdentifier:@"MyDelegateTableViewCell"];
    
    id <UITableViewDataSource, UITableViewDelegate> dataSource
    = [MyCustomHTTableViewDataSource dataSourceWithModel:[MyInterestList interestListWithSport]
                                             cellTypeMap:@{@"MyCellStringModel" : @"MyTableViewCell", @"MyTableViewCellModel" : @"MyTableViewCell"}
                                       cellConfiguration:
       ^(UITableViewCell *cell, NSIndexPath *indexPath) {
           if (indexPath.row % 2 == 0) {
               cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
           } else {
               cell.accessoryType = UITableViewCellAccessoryCheckmark;
           }
           if (indexPath.section == 1) {
               [cell.contentView setBackgroundColor:[UIColor grayColor]];
           }
       }];
    
    _tableview.dataSource = dataSource;
    _tableview.delegate = dataSource;
    self.demoDataSource = dataSource;
    [_tableview reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
