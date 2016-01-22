//
//  HTDemoTableViewDataSource.h
//  HeartTouchTableViewDataSourceDemo
//
//  Created by 志强 on 16/1/18.
//  Copyright © 2016年 志强. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HTSectionDataSource;
@interface HTDemoTableViewDataSource : NSObject <UITableViewDelegate, UITableViewDataSource>

- (void)provideSectionDataSource:(HTSectionDataSource *) dataSource
                     withSection:(NSInteger)sectionIndex;
@end
