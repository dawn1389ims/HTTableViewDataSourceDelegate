//
//  NSArray+DataSource.h
//  Demo
//
//  Created by 志强 on 16/1/18.
//  Copyright © 2016年 forkingdog. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTableViewDataSource.h"

@interface NSArray (DataSource) <HTTableViewDataSourceDataModelProtocol>

/**
 *  
 */
- (void)ht_check2DArray;

@end