//
//  ViewController.m
//  HeartTouchTableViewDataSourceDemo
//
//  Created by 志强 on 16/1/18.
//  Copyright © 2016年 志强. All rights reserved.
//

#import "ViewController.h"
#import "HTTableViewDataSource.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "MyTableViewCellModel.h"
#import "HTTableViewCompositeDataSource.h"
#import "MyInterestList+HTTableViewDataSource.h"
#import "NSArray+DataSource.h"
#import "MyDelegateTableViewCell.h"
#import "MyCustomHTTableViewDataSource.h"
#import "MyCellStringModel.h"

@interface ViewController () <MyDelegateTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *demoSelectSegment;

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic ,strong) id demoDataSource;

@end

//custom UITableView data source and delegate type
typedef id <UITableViewDataSource, UITableViewDelegate> MyTableViewDataSourceType;

@implementation ViewController

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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MyTableViewDataSourceType dataSource =
    dataSource = [self normalArrayDataSource];
    
    _tableview.dataSource = dataSource;
    _tableview.delegate = dataSource;
    self.demoDataSource = dataSource;
    [_tableview reloadData];
    
    [_demoSelectSegment setSelectedSegmentIndex:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)selectedButtonWithContent:(NSString *)content
{
    NSLog(@"table view cell delegate invoke: %@",content);
}


- (IBAction)changeSegmengt:(id)sender {
    MyTableViewDataSourceType dataSource;
    switch ([sender selectedSegmentIndex]) {
        case 0:
            dataSource = [self normalArrayDataSource];
            break;
        case 1:
            dataSource = [self userModelDataSource];
            break;
        case 2:
            dataSource = [self compositeModelDataSource];
            break;
        case 3:
            dataSource = [self delegateCellDataSource];
            break;
        default:
            break;
    }
    _tableview.dataSource = dataSource;
    _tableview.delegate = dataSource;
    self.demoDataSource = dataSource;//VC 持有 dataSource
    [_tableview reloadData];
}

- (MyTableViewDataSourceType)normalArrayDataSource
{
    id <HTTableViewDataSourceDataModelProtocol> cellModels = [self arrayCellModels];
    MyTableViewDataSourceType dataSource
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
    
    return dataSource;
}

- (MyTableViewDataSourceType)userModelDataSource
{
    MyTableViewDataSourceType dataSource
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
    return dataSource;
}

- (MyTableViewDataSourceType)compositeModelDataSource
{
    //first data source
    HTTableViewDataSource * dataSource1 =
    [HTTableViewDataSource dataSourceWithModel:[self arrayCellModels]
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
    
    //second data source
    HTTableViewDataSource * modelDataSource =
    [HTTableViewDataSource dataSourceWithModel:[self customClassCellModels]
                                   cellTypeMap:@{@"MyTableViewCellModel" : @"MyTableViewCell"}
                             cellConfiguration:
     ^(UITableViewCell *cell, NSIndexPath *indexPath) {
        cell.accessoryType = UITableViewCellAccessoryDetailButton;
    }];

    //composite data source
    NSMutableArray < UITableViewDataSource, UITableViewDelegate >* dataSourceList = @[].mutableCopy;
    [dataSourceList addObject:dataSource1];
    [dataSourceList addObject:modelDataSource];
    
    MyTableViewDataSourceType dataSource
    = [HTTableViewCompositeDataSource dataSourceWithDataSources:dataSourceList];
    return dataSource;
}

- (MyTableViewDataSourceType)delegateCellDataSource
{
    NSMutableArray * mixModelSource= [[self arrayCellModels] mutableCopy];
    [mixModelSource addObject:[MyTableViewCellModel modelWithTitle:@"Mixed" name:@"Delegate Cell"]];
    
    id __weak weakSelf = self;
    MyTableViewDataSourceType dataSource
    = [HTTableViewDataSource dataSourceWithModel:mixModelSource
                                     cellTypeMap:@{@"MyCellStringModel" : @"MyTableViewCell", @"MyTableViewCellModel": @"MyDelegateTableViewCell"} cellConfiguration:
       ^(MyDelegateTableViewCell *cell, NSIndexPath *indexPath) {
        if ([cell isKindOfClass:[MyDelegateTableViewCell class]]) {
            cell.delegate = weakSelf;
            cell.fd_enforceFrameLayout = YES;
        }
    }];
    return dataSource;
}
@end
