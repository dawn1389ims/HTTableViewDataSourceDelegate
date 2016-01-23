//
//  ViewController.m
//  HeartTouchTableViewDataSourceDemo
//
//  Created by 志强 on 16/1/18.
//  Copyright © 2016年 志强. All rights reserved.
//

#import "ViewController.h"
#import "HTTableViewDataSource.h"

#import "MyTableViewCellModel.h"
#import "HTTableViewCompositeDataSource.h"
#import "MyInterestList+HTTableViewDataSource.h"
#import "NSArray+DataSource.h"
#import "MyDelegateTableViewCell.h"
#import "MyCustomHTTableViewDataSource.h"
#import "UITableView+FDTemplateLayoutCell.h"
@interface ViewController () <MyDelegateTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *demoSelectSegment;

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic ,strong) id demoDataSource;

@end

@implementation ViewController

- (NSArray <HTTableViewDataSourceDataModelProtocol> *)arrayCellModels
{
    return @[@"A", @"B", @"C", @"D", @"E", @"F"];
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
    id < UITableViewDataSource, UITableViewDelegate > dataSource =
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

-(void)selectedButtonWithContent:(NSString *)content
{
    NSLog(@"table view cell delegate invoke: %@",content);
}


- (IBAction)changeSegmengt:(id)sender {
    id < UITableViewDataSource, UITableViewDelegate > dataSource;
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
    self.demoDataSource = dataSource;
    [_tableview reloadData];
}

-(id < UITableViewDataSource, UITableViewDelegate >)normalArrayDataSource
{
    NSArray <HTTableViewDataSourceDataModelProtocol> * cellModels = [self arrayCellModels];
    id < UITableViewDataSource, UITableViewDelegate > dataSource = [HTTableViewDataSource dataSourceWithModel:cellModels cellTypeMap:@{@"NSString" : @"MyTableViewCell"} cellConfiguration:^(UITableViewCell *cell, NSIndexPath *indexPath) {
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

-(id < UITableViewDataSource, UITableViewDelegate >)userModelDataSource
{
    id <HTTableViewDataSourceDataModelProtocol> userModel = [MyInterestList interestListWithSport];

    id < UITableViewDataSource, UITableViewDelegate > dataSource = [MyCustomHTTableViewDataSource dataSourceWithModel:userModel cellTypeMap:@{@"NSString" : @"MyTableViewCell", @"MyTableViewCellModel" : @"MyTableViewCell"} cellConfiguration:^(UITableViewCell *cell, NSIndexPath *indexPath) {
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

-(id < UITableViewDataSource, UITableViewDelegate >)compositeModelDataSource
{
    NSArray <HTTableViewDataSourceDataModelProtocol> * cellModel1 = [self arrayCellModels];
    HTTableViewDataSource * dataSource1 =
    [HTTableViewDataSource dataSourceWithModel:cellModel1 cellTypeMap:@{@"NSString" : @"MyTableViewCell"} cellConfiguration:^(UITableViewCell *cell, NSIndexPath *indexPath) {
        if (indexPath.row % 2 == 0) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        if (indexPath.section == 1) {
            [cell.contentView setBackgroundColor:[UIColor grayColor]];
        }
    }];
    NSArray <HTTableViewDataSourceDataModelProtocol>* theCellModels = [self customClassCellModels];
    
    HTTableViewDataSource * modelDataSource = [HTTableViewDataSource dataSourceWithModel:theCellModels cellTypeMap:@{@"MyTableViewCellModel" : @"MyTableViewCell"} cellConfiguration:^(UITableViewCell *cell, NSIndexPath *indexPath) {
        cell.accessoryType = UITableViewCellAccessoryDetailButton;
    }];
    
    //
    NSMutableArray < UITableViewDataSource, UITableViewDelegate >* dataSourceList = @[].mutableCopy;
    [dataSourceList addObject:dataSource1];
    [dataSourceList addObject:modelDataSource];
    id < UITableViewDataSource, UITableViewDelegate > dataSource = [HTTableViewCompositeDataSource dataSourceWithDataSources:dataSourceList];
    return dataSource;
}

-(id < UITableViewDataSource, UITableViewDelegate >)delegateCellDataSource
{
    NSMutableArray * mixModelSource= [[self arrayCellModels] mutableCopy];
    [mixModelSource addObject:[MyTableViewCellModel modelWithTitle:@"Mixed" name:@"Delegate Cell"]];
    id __weak weakSelf = self;
    id < UITableViewDataSource, UITableViewDelegate > dataSource = [HTTableViewDataSource dataSourceWithModel:mixModelSource cellTypeMap:@{@"NSString" : @"MyTableViewCell", @"MyTableViewCellModel": @"MyDelegateTableViewCell"} cellConfiguration:^(MyDelegateTableViewCell *cell, NSIndexPath *indexPath) {
        
        if ([cell isKindOfClass:[MyDelegateTableViewCell class]]) {
            cell.delegate = weakSelf;
            cell.fd_enforceFrameLayout = YES;
        }
    }];
    return dataSource;
}
@end
