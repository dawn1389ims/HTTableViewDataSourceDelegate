//
//  MyDemoUserModelViewController.m
//  HeartTouchTableViewDataSourceDemo
//
//  Created by 志强 on 16/2/23.
//  Copyright © 2016年 志强. All rights reserved.
//

#import "MyDemoUserModelViewController.h"
#import "HTTableViewDataSource.h"
#import "MyCellStringModel.h"
#import "MyTableViewCellModel.h"
#import "MyDelegateTableViewCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "NSArray+DataSource.h"
#import "MyTableViewCell.h"
#import "MyDelegateTableViewCell.h"
@interface MyDemoUserModelViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic ,strong) id demoDataSource;

@end

@implementation MyDemoUserModelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //注册cell
    UINib * nib = [UINib nibWithNibName:@"MyTableViewCell" bundle:[NSBundle mainBundle]];
    [_tableview registerNib:nib forCellReuseIdentifier:@"MyTableViewCell"];
    
    nib = [UINib nibWithNibName:@"MyDelegateTableViewCell" bundle:[NSBundle mainBundle]];
    [_tableview registerNib:nib forCellReuseIdentifier:@"MyDelegateTableViewCell"];
    
    NSMutableArray * mixModelSource= [[self arrayCellModels] mutableCopy];
    [mixModelSource addObject:[MyTableViewCellModel modelWithTitle:@"Mixed" name:@"Delegate Cell"]];
    
    id __weak weakSelf = self;
    id <UITableViewDataSource, UITableViewDelegate> dataSource
    = [HTTableViewDataSource dataSourceWithModel:mixModelSource
                                     cellTypeMap:@{@"MyCellStringModel" : @"MyTableViewCell", @"MyTableViewCellModel": @"MyDelegateTableViewCell"} cellConfiguration:
       ^(MyDelegateTableViewCell *cell, NSIndexPath *indexPath) {
           if ([cell isKindOfClass:[MyDelegateTableViewCell class]]) {
               cell.delegate = weakSelf;
               cell.fd_enforceFrameLayout = YES;
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

@end
