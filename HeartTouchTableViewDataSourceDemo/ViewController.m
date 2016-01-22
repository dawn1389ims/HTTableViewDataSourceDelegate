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
@interface ViewController () <MyDelegateTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic ,strong) id demoDataSource;

@end

@implementation ViewController

- (NSArray <HTTableViewDataSourceDataModelProtocol> *)arrayDataSource
{
    return @[@[@"A", @"B", @"C", @"D"], @[@"E", @"F"]];
}

- (NSArray <HTTableViewDataSourceDataModelProtocol> *)myCellModelArrayDataSource
{
    NSMutableArray * modelList = [NSMutableArray new];
    for (int index = 0; index < 10; index ++ ) {
        [modelList addObject:[MyTableViewCellModel modelWithTitle:[NSString stringWithFormat:@"%d",index] name:@"normal"]];
    }
    return modelList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
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
            dataSource = [self normalDataSource];
            break;
        case 1:
            dataSource = [self userModelDataSource];
            break;
        case 2:
            dataSource = [self compositeModelDataSource];
            break;
        case 3:
            dataSource = [self mixModelandDelegateCellDataSource];
            break;
        default:
            break;
    }
    _tableview.dataSource = dataSource;
    _tableview.delegate = dataSource;
    self.demoDataSource = dataSource;
    [_tableview reloadData];
}

-(id < UITableViewDataSource, UITableViewDelegate >)normalDataSource
{
    NSArray <HTTableViewDataSourceDataModelProtocol> * cellModels = [self arrayDataSource];
    id < UITableViewDataSource, UITableViewDelegate > dataSource = [MyCustomHTTableViewDataSource dataSourceWithModel:cellModels cellTypeMap:@{@"NSString" : @"MyTableViewCell"} cellConfiguration:^(UITableViewCell *cell, NSIndexPath *indexPath) {
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
    id <HTTableViewDataSourceDataModelProtocol> userModel = [[MyInterestList interestListWithSport] interestListDataArray];

    id < UITableViewDataSource, UITableViewDelegate > dataSource = [HTTableViewDataSource dataSourceWithModel:userModel cellTypeMap:@{@"MyTableViewCellModel" : @"MyTableViewCell"} cellConfiguration:^(UITableViewCell *cell, NSIndexPath *indexPath) {
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
    NSArray <HTTableViewDataSourceDataModelProtocol> * cellModel1 = [self arrayDataSource];
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
    NSArray <HTTableViewDataSourceDataModelProtocol>* theCellModels = [self myCellModelArrayDataSource];
    
    HTTableViewDataSource * modelDataSource = [HTTableViewDataSource dataSourceWithModel:theCellModels cellTypeMap:@{@"MyTableViewCellModel" : @"MyTableViewCell"} cellConfiguration:^(UITableViewCell *cell, NSIndexPath *indexPath) {
        cell.accessoryType = UITableViewCellAccessoryDetailButton;
    }];
    NSMutableArray * lll = [@[dataSource1, modelDataSource] mutableCopy];
    id < UITableViewDataSource, UITableViewDelegate > dataSource = [HTTableViewCompositeDataSource dataSourceWithDataSources:lll];
    return dataSource;
}

-(id < UITableViewDataSource, UITableViewDelegate >)mixModelandDelegateCellDataSource
{
    NSMutableArray * mixModelSource= [[self arrayDataSource] mutableCopy];
    [mixModelSource addObject:[MyTableViewCellModel modelWithTitle:@"Mixed" name:@"Delegate Cell"]];
    id __weak weakSelf = self;
    id < UITableViewDataSource, UITableViewDelegate > dataSource = [HTTableViewDataSource dataSourceWithModel:mixModelSource cellTypeMap:@{@"NSString" : @"MyTableViewCell", @"MyTableViewCellModel": @"MyDelegateTableViewCell"} cellConfiguration:^(MyDelegateTableViewCell *cell, NSIndexPath *indexPath) {
        
        if ([cell isKindOfClass:[MyDelegateTableViewCell class]]) {
            cell.delegate = weakSelf;
        }
    }];
    return dataSource;
}
@end
