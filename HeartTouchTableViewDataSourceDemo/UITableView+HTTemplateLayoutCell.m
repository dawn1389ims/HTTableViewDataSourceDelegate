//
//  UITableView+HTTemplateLayoutCell.m
//  Demo
//
//  Created by 志强 on 15/12/28.
//  Copyright © 2015年 forkingdog. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITableView+HTTemplateLayoutCell.h"

#import <objc/runtime.h>

@implementation UITableView (HTTemplateLayoutCell)

- (CGFloat)ht_heightForCellWithIdentifier:(NSString *)identifier
                                    model:(id)entity
                            configuration:(void (^)(id cell))configuration {
    return [self fd_heightForCellWithIdentifier:identifier configuration:^(id cell) {
//        cell.entity = entity;
        configuration(cell);
    }];
}

- (CGFloat)ht_heightForCellWithIdentifier:(NSString *)identifier
                                    model:(id)entity
                         cacheByIndexPath:(NSIndexPath *)indexPath
                            configuration:(void (^)(id cell))configuration {
    return [self fd_heightForCellWithIdentifier:identifier cacheByIndexPath:indexPath configuration:^(id cell) {
//        cell.entity = entity;
        configuration(cell);
    }];
}

- (CGFloat)ht_heightForCellWithIdentifier:(NSString *)identifier
                                    model:(id)entity
                               cacheByKey:(id<NSCopying>)key
                            configuration:(void (^)(id cell))configuration
{
    return [self fd_heightForCellWithIdentifier:identifier cacheByKey:key configuration:^(id cell) {
//        cell.entity = entity;
        configuration(cell);
    }];
}

@end
