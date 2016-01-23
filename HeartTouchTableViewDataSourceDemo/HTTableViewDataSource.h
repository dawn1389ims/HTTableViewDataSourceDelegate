//
//  HTArrayDataSource.h
//  Demo
//
//  Created by 志强 on 16/1/18.
//  Copyright © 2016年 forkingdog. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTDataSourceDataModelProtocol.h"
#import "HTTableViewCellModelProtocol.h"
typedef void(^HTTableViewConfigBlock)(id cell, NSIndexPath * indexPath);

@interface HTTableViewDataSource : NSObject < UITableViewDataSource, UITableViewDelegate >

/**
 *  构造一个dataSource对象
 *
 *  @param array         cell model array
 *  @param cellTypeMap   cell model class : cell identifier
 *  @param configuration 提供对cell的额外配置
 *
 *  @return
 */
+ (instancetype)dataSourceWithModel:(id < HTTableViewDataSourceDataModelProtocol >)model
                        cellTypeMap:(NSDictionary *)cellTypeMap
                  cellConfiguration:(HTTableViewConfigBlock)configuration;
@end



