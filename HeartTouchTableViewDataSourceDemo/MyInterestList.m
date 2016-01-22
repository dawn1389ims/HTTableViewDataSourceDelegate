//
//  MyInterestList.m
//  HeartTouchTableViewDataSourceDemo
//
//  Created by 志强 on 16/1/21.
//  Copyright © 2016年 志强. All rights reserved.
//

#import "MyInterestList.h"
#import "MyTableViewCellModel.h"
@interface MyInterestList ()

@property (nonatomic, strong) NSDictionary * interestList;
@property (nonatomic, strong) NSArray * dataList;

@end
@implementation MyInterestList

+ (instancetype)interestListWithSport
{
    MyInterestList * instance = [MyInterestList new];
    instance.interestList = @{
                              @"球类":@[@"乒乓球", @"足球", @"桌上足球", @"台球"],
                              @"非球类":@[@"跑步", @"骑自行"]};
    return instance;
}

- (NSArray*)interestListDataArray
{
    if (_dataList == nil) {
        //convert data to table view data list
        NSMutableArray * templateArray = [NSMutableArray new];
        NSMutableArray * secondDArray;
        for (NSString * key in self.interestList) {
            secondDArray = [NSMutableArray new];
            for (NSString * content in self.interestList[key]) {
                [secondDArray addObject:[MyTableViewCellModel modelWithTitle:key name:content]];
            }
            [templateArray addObject:secondDArray];
        }
        _dataList = templateArray;
    }
    
    return _dataList;
}
@end
