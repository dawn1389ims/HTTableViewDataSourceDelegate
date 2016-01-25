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
 *  @param model         dataSource model，根据协议HTTableViewDataSourceDataModelProtocol取得数据
 *  @param cellTypeMap   提供从cell model的class 到cell identifier 和 cell class的对应表
 *  @param configuration 提供对cell的额外配置。默认使用auto layout约束来计算cell高度；如果没有使用auto layout，必须在block中添加一行代码：cell.fd_enforceFrameLayout = YES;并且在cell实现文件中实现-[UIView sizeThatFits:]方法，计算出正确的 cell 高度
 *
 *  @return
 */
+ (instancetype)dataSourceWithModel:(id < HTTableViewDataSourceDataModelProtocol >)model
                        cellTypeMap:(NSDictionary *)cellTypeMap
                  cellConfiguration:(HTTableViewConfigBlock)configuration;
@end



