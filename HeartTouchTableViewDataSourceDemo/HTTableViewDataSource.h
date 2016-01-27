//
//  HTArrayDataSource.h
//  Demo
//
//  Created by 志强 on 16/1/18.
//  Copyright © 2016年 forkingdog. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTTableViewDataSourceDataModelProtocol.h"
#import "HTTableViewCellModelProtocol.h"
typedef void(^HTTableViewConfigBlock)(id cell, NSIndexPath * indexPath);


@interface HTTableViewDataSource : NSObject < UITableViewDataSource, UITableViewDelegate >

/**
 *  根据cellTypeMaps从cellModel中查找到指定的cell identifier
 *  允许自定义映射规则
 *
 *  @param cellModel cellModel对象
 *
 *  @return cell identifier
 */
- (NSString*)cellIdentifierForCellModelClass:(id)cellModel;
/**
 *  构造一个dataSource对象
 *
 *  @param model         dataSource model，根据协议HTTableViewDataSourceDataModelProtocol取得数据
 *  @param cellTypeMap   提供从cell model的class 到cell identifier 和 cell class的对应表
 *  @param configuration 在 cell 设置 model 结束后额外的设置cell属性的机会，可根据 indexPath 配置cell。cell 高度计算：默认使用auto layout约束来计算cell高度；如果没有使用auto layout，必须在block中添加一行代码：cell.fd_enforceFrameLayout = YES;并且在cell实现文件中实现-[UIView sizeThatFits:]方法，计算出正确的 cell 高度
 *
 *  @return
 */
+ (instancetype)dataSourceWithModel:(id < HTTableViewDataSourceDataModelProtocol >)model
                        cellTypeMap:(NSDictionary < NSString * , NSString *> *)cellTypeMap
                  cellConfiguration:(HTTableViewConfigBlock)configuration;
@end



