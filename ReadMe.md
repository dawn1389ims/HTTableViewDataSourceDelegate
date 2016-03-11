#HeartTouch UITableView DataSource的规范

##常见UITableView dataSource的写法
`UITableView`是UIKit最重要的控件之一，由于它功能强大，接口清晰，使用频率较高。使用时要设置 table view 的数据源和委托对象，table view 通过访问数据源实现的协议方法来完成配置。  
下面是`UITableViewDataSource`协议的两个必须实现的方法：

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
NSInteger rowNum = 5;
return rowNum;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
NSString *identifier = @"cellIdentifier";
UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//cell model set
return cell;
}
其他配置包括 Configuring Row, Managing Accessory Views, Managing Selections, Row Highlight, Edit row, Header View, Footer View, Header Height, Footer Height 等，非常丰富。  
一般在使用时会把 view controller 设为 table view 数据源和委托对象，但是这种写法存在几个问题：第一，每次配置table view都会重复这一套流程，有重复的代码，第二，会增加 view controller 的代码量。  
为了能够不再重复地书写协议方法，减少 view controller 的代码量，方便地配置 table view ，HeartTouch规范使用 `HTTableViewDataSource` 来实现 table view 的数据源和其他的配置。  

## HTTableViewDataSource
称table view 需要展示的每一项数据是一个"Data数据"，称能够取得所有Data数据的对象为"Data数据源"，那么`UITableView`的作用就是取得Data数据源中的Data数据，按规则展示到`UITableViewCell`上。  
`HTTableViewDataSource` 对象可以直接处理Data数据源，根据设置好的Data数据和`UITableViewCell`的对应关系自动构造cell，让使用者只用关心Data数据，不需要关心cell的构造。在自动设置cell的Data数据之后，HeartTouch还实现了cell的高度计算，用户需要做的就是配置这个方法`+ [HTTableViewDataSource dataSourceWithModel: cellTypeMap: cellConfiguration:]`。

下面演示 `HTTableViewDataSource` 如何使用一个`NSArray`的Data数据源，处理`MyCellStringModel`类型的Data数据  

在页面实现文件中导入头文件

#import "HTTableViewDataSource.h"
#import "NSArray+DataSource.h" //Data数据源在这里完成协议的遵守，参考下面对model参数的解释
#import "MyCellStringModel.h"	//Data数据类型
#import "MyTableViewCell.h"		//cell类型，遵守协议HTTableViewCellModelProtocol
#import "UITableView+FDTemplateLayoutCell.h"  //cell高度计算

实现一个取得数据的方法，例如

- (id <HTTableViewDataSourceDataModelProtocol>)arrayCellModels
{
NSMutableArray * models = [NSMutableArray new];
for (NSString * arg in @[@"A", @"B", @"C", @"D", @"E", @"F"]) {
[models addObject:[MyCellStringModel modelWithTitle:arg]];
}
return models;
}
在配置 table view 的地方构造 dataSource 对象并使用

id <HTTableViewDataSourceDataModelProtocol> cellModels = [self arrayCellModels];//
MyTableViewDataSourceType dataSource
= [HTTableViewDataSource dataSourceWithModel:cellModels
cellTypeMap:@{@"MyCellStringModel" : @"MyTableViewCell"}// Data数据类型到cell的类名的映射
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
cell.fd_enforceFrameLayout = YES;//不用auto layout做cell布局
}];
self.demoDataSource = dataSource;//要持有 dataSource
_tableview.dataSource = dataSource;
_tableview.delegate = dataSource;
[_tableview reloadData];

`fd_enforceFrameLayout`属性会影响cell高度计算，参考下面对`cellConfiguration`参数的解释。 

参数的详细介绍：

*	model         
Data数据源，遵守 `HTTableViewDataSourceDataModelProtocol` 协议。   
建议使用时为Data数据源添加一个遵守该协议的分类，单独实现该协议，做到代码分离。上面例子中的分类`NSArray+DataSource`的实现如下  
NSArray+DataSource.h

#import <Foundation/Foundation.h>
#import "HTTableViewDataSourceDataModelProtocol.h"
@interface NSArray (DataSource) <HTTableViewDataSourceDataModelProtocol>
@end
NSArray+DataSource.m  

@implementation NSArray (DataSource)
- (NSUInteger)ht_sectionCount
{
return 1;
}
- (NSUInteger)ht_rowCountAtSectionIndex:(NSUInteger)section
{
return self.count;
}
- (id)ht_itemAtSection:(NSUInteger)section rowIndex:(NSUInteger)row
{
return self[row];
}
@end

*	cellTypeMap   
设置从Data数据类型到cell类名的映射。   
HeartTouch规范cell的identifier和cell类名一致，所以根据Data数据的类型也能得到cell的identifier；  
HeartTouch规范自定义`UITableViewCell`要遵守协议`HTTableViewCellModelProtocol`:

@protocol HTTableViewCellModelProtocol <NSObject>
@property (nonatomic, strong) id model;
@end
所以cellTypeMap字典的所有value对应的cell类都应该实现`model`属性([UITableViewCell设置数据的规范](https://git.hz.netease.com/hzzhangping/heartouch/blob/master/specification/ios/UITableViewCell%E8%AE%BE%E7%BD%AE%E6%95%B0%E6%8D%AE%E7%9A%84%E8%A7%84%E8%8C%83.md))  


*	cellConfiguration   
在 cell 设置 model 结束后额外的设置cell属性的机会，可根据 indexPath 配置 cell。  
需要在这里设置 cell 高度计算规则([UITableViewCell高度计算接口规范](https://git.hz.netease.com/hzzhangping/heartouch/blob/master/specification/ios/UITableViewCell%E9%AB%98%E5%BA%A6%E8%AE%A1%E7%AE%97%E6%8E%A5%E5%8F%A3%E8%A7%84%E8%8C%83.md))：默认使用auto layout约束来计算cell高度；如果没有使用auto layout，必须在block中添加一行代码：`cell.fd_enforceFrameLayout = YES;`并且在cell实现文件中实现`-[UIView sizeThatFits:]`方法，计算出正确的 cell 高度

###继承HTTableViewDataSource完成更多配置
`HTTableViewDataSource`只实现了`tableView: cellForRowAtIndexPath:`,`numberOfSectionsInTableView:`,`tableView: heightForRowAtIndexPath:`三个方法，要实现更多的`UITableViewDelegate`协议 和 `UITableViewDataSource`协议的方法时，可以继承`HTTableViewDataSource`，添加实现。参考[Demo](https://git.hz.netease.com/git/hzzhuzhiqiang/HTTableViewDataSourceDemo.git)中的`MyCustomHTTableViewDataSource`。

## 使用HTCompositeDataSource
如果一个 table view 在不同的位置使用不同的Data数据源时，并且不同的Data数据源的数据个数还是变化的，那么管理这种table view 的Data数据的位置将会非常痛苦。因为常规做法会把所有的Data数据都放在一个集合中，导致所有的位置计算都需要累加上之前所有的Data数据，才能得到正确的结果。使用`HTCompositeDataSource`可以避免出现这种问题。  
`+ [HTCompositeDataSource dataSourceWithDataSources:]` 方法能够将多个不同的 dataSource 组合成一个，使用时不用关心Data数据在整个Data数据源中的位置，每项Data数据的位置就是在各自Data数据源中的实际位置。
使用方法如下  
导入头文件

#import "HTTableViewDataSource.h"
#import "HTTableViewCompositeDataSource.h"

构造 composite dataSource 对象，设置给 table view

//自定义 dataSource
HTTableViewDataSource * dataSource1;
HTTableViewDataSource * modelDataSource;
//data source array
NSMutableArray < UITableViewDataSource, UITableViewDelegate >* dataSourceList = @[].mutableCopy;
[dataSourceList addObject:dataSource1];
[dataSourceList addObject:modelDataSource];
//composite data source array
MyTableViewDataSourceType dataSource
= [HTTableViewCompositeDataSource dataSourceWithDataSources:dataSourceList];
//use for table view
self.demoDataSource = dataSource;//VC持有 dataSource
_tableview.dataSource = dataSource;
_tableview.delegate = dataSource;
[_tableview reloadData];

##Demo演示内容
HTTableViewDataSourceDemo演示了如下内容，具体内容参考[Demo](https://git.hz.netease.com/git/hzzhuzhiqiang/HTTableViewDataSourceDemo.git)的代码  
Demo运行成功后，最上面有一个segment，提供四个选项，代表不同的演示内容  

*	"array" 的segment选项，演示将数组构造成一个`HTTableViewDataSource`
*	"user model" 的segment选项，演示将用户自定义的Data数据源构造成一个`HTTableViewDataSource`；演示通过继承 `HTTableViewDataSource` 来支持header 和 footer 的显示
*	"composite" 的segment选项，演示使用 `HTTableViewCompositeDataSource` 组合多个 dataSource
*	"cell delegate" 的segment选项，演示需要设置 `delegate`的cell的`HTTableViewDataSource`的设置

##HeartTouch UITableView 规范的总结

-	[UITableViewCell高度计算接口规范](https://git.hz.netease.com/hzzhangping/heartouch/blob/master/specification/ios/UITableViewCell%E9%AB%98%E5%BA%A6%E8%AE%A1%E7%AE%97%E6%8E%A5%E5%8F%A3%E8%A7%84%E8%8C%83.md)
-	[UITableViewCell设置数据的规范](https://git.hz.netease.com/hzzhangping/heartouch/blob/master/specification/ios/UITableViewCell%E8%AE%BE%E7%BD%AE%E6%95%B0%E6%8D%AE%E7%9A%84%E8%A7%84%E8%8C%83.md),这里HeartTouch了规范自定义的`UITableViewCell` 要遵守 `HTTableViewCellModelProtocol`，也就是统一了cell访问Data数据的接口为 `model`
-	规范table view cell 的类名和 cell identifier 相同
-	规范使用 `UITableView`使用`HTTableViewDataSource` 对象作为`dataSource` 和 `delegate`，不再使用 view controller。
