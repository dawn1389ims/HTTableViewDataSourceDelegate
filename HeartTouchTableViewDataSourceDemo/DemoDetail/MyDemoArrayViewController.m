//
//  MyDemoArrayViewController.m
//  HeartTouchTableViewDataSourceDemo
//
//  Created by 志强 on 16/2/23.
//  Copyright © 2016年 志强. All rights reserved.
//

#import "MyDemoArrayViewController.h"
#import "HTTableViewDataSource.h"
#import "MyCellStringModel.h"
#import "MyTableViewCellModel.h"
#import "MyTableViewCell.h"
#import "NSArray+DataSource.h"
@interface MyDemoArrayViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic ,strong) id demoDataSource;

@end

@implementation MyDemoArrayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //注册cell
    UINib * nib = [UINib nibWithNibName:@"MyTableViewCell" bundle:[NSBundle mainBundle]];
    [_tableview registerNib:nib forCellReuseIdentifier:@"MyTableViewCell"];
    
    id <HTTableViewDataSourceDataModelProtocol> cellModels = [self arrayCellModels];
    id <UITableViewDataSource, UITableViewDelegate> dataSource
    = [HTTableViewDataSource dataSourceWithModel:cellModels
                                     cellTypeMap:@{@"MyCellStringModel" : @"MyTableViewCell"}
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

- (NSArray <HTTableViewDataSourceDataModelProtocol> *)arrayCellModels
{
    NSMutableArray * models = [NSMutableArray new];
    for (NSString * arg in @[@"A", @"B", @"C", @"D", @"E", @"F"]) {
        [models addObject:[MyCellStringModel modelWithTitle:arg]];
    }
    return models;
}

- (NSArray <HTTableViewDataSourceDataModelProtocol> *)customClassCellModels
{
    NSMutableArray * modelList = [NSMutableArray new];
    for (int index = 0; index < 10; index ++ ) {
        [modelList addObject:[MyTableViewCellModel modelWithTitle:[NSString stringWithFormat:@"%d",index] name:@"normal"]];
    }
    return modelList;
}
@end
