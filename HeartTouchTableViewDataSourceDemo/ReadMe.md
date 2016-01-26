#HeartTouch UITableView DataSource的规范

##常见UITableView dataSource的写法
`UITableView`是UIKit最重要的控件之一，由于它功能强大，接口清晰，使用频率非常高。一般使用时会把它的`delegate`和`dataSource`设置为页面(UIViewController)，在页面中配置数据源和委托对象。  
这样的页面会包含如下实现：

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
更多对`UITableView`的设置还包括 Configuring Row, Managing Accessory Views, Managing Selections, Row Highlight, Edit row, Header View, Footer View, Header Height, Footer Height 等等，虽然都是可选的，但还是会导致页面代码臃肿。  
为了减少页面的代码量，不用重复地书写协议方法，更加清晰地书写dataSource代码，HeartTouch规范使用 `HTTableViewDataSource` 来为 `UITableView` 提供数据源和委托对象。  

## HTTableViewDataSource
构造 `HTTableViewDataSource` 实例的方法是`+ [HTTableViewDataSource dataSourceWithModel: cellTypeMap: cellConfiguration:]` ，该方法能够将一个 table view 的数据源对象转换成 `UITableView` 需要的 dataSource。  

下面的例子展示了 `HTTableViewDataSource` 的使用方法，内部使用的cell高度计算使用的是[UITableViewCell高度计算接口规范](https://git.hz.netease.com/hzzhangping/heartouch/blob/master/specification/ios/UITableViewCell%E9%AB%98%E5%BA%A6%E8%AE%A1%E7%AE%97%E6%8E%A5%E5%8F%A3%E8%A7%84%E8%8C%83.md)：

导入头文件

#import "HTTableViewDataSource.h"
#import "UITableView+FDTemplateLayoutCell.h"

构造一个 dataSource 对象，设置给 table view

id <HTTableViewDataSourceDataModelProtocol> cellModels = [self arrayCellModels];
MyTableViewDataSourceType dataSource
= [HTTableViewDataSource dataSourceWithModel:cellModels
cellTypeMap:@{@"NSString" : @"MyTableViewCell"}// cell model type all is NSString
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
cell.fd_enforceFrameLayout = YES;//不用auto layout做cell布局时
}];
self.demoDataSource = dataSource;//要持有 dataSource
_tableview.dataSource = dataSource;
_tableview.delegate = dataSource;
[_tableview reloadData];

下面详细介绍这个构造方法的参数

###model         
遵守 `HTTableViewDataSourceDataModelProtocol` 协议的cell 数据源，协议规定接口如下:

//取得section count
- (NSUInteger)ht_sectionCount;
//取得指定section对应的row count
- (NSUInteger)ht_rowCountAtSectionIndex:(NSUInteger)section;
//取得指定section和row对应的item
- (id)ht_itemAtSection:(NSUInteger)section rowIndex:(NSUInteger)row;
只要是遵守该协议的数据源，都能被用作 `HTTableViewDataSource` 的model。 

建议使用时为数据源添加一个遵守该协议的分类，将数据转换成方便展示的格式，能够让代码更加清晰易读，参考[Demo]((https://git.hz.netease.com/git/hzzhuzhiqiang/HTTableViewDataSourceDemo.git)中的`NSArray+DataSource`和`MyInterestList+HTTableViewDataSource`。

###cellTypeMap   
设置从每个cell对应的data model类名到cell identifier 和 cell class的映射。   
首先规范cell identifier 和 cell class名字是一致的；  
这时`cellTypeMap`的 `@{ <NSString *> : <NSString *>}` 的映射完全能够表达从 cell data model 到 cell identifier 和 cell data model 到 cell class的关系。这样能省写 `- cellIdentifierForCellDataModel:` 和 `- cellClassForCellDataModel:` 两个方法。

###configuration 
在 cell 设置 model 结束后额外的设置cell属性的机会，可根据 indexPath 配置 cell。  

cell 高度计算需要在这里配置属性，参考[UITableViewCell高度计算接口规范](https://git.hz.netease.com/hzzhangping/heartouch/blob/master/specification/ios/UITableViewCell%E9%AB%98%E5%BA%A6%E8%AE%A1%E7%AE%97%E6%8E%A5%E5%8F%A3%E8%A7%84%E8%8C%83.md)：默认使用auto layout约束来计算cell高度；如果没有使用auto layout，必须在block中添加一行代码：`cell.fd_enforceFrameLayout = YES;`并且在cell实现文件中实现`-[UIView sizeThatFits:]`方法，计算出正确的 cell 高度

###继承HTTableViewDataSource完成更多配置
`HTTableViewDataSource`只实现了`tableView: cellForRowAtIndexPath:`,`numberOfSectionsInTableView:`,`tableView: heightForRowAtIndexPath:`三个接口，要实现更多的`UITableViewDelegate` 和 `UITableViewDataSource`接口时，只需要继承`HTTableViewDataSource`一下就可以自定义新的接口了，复用起来较为方便。参考[Demo](https://git.hz.netease.com/git/hzzhuzhiqiang/HTTableViewDataSourceDemo.git)中的`MyCustomHTTableViewDataSource`。

## 使用HTCompositeDataSource
如果一个 table view 存在多个不同数据源的区域，并且不同区域的数据源的个数还是变化的，那么管理这种table view 的某项数据的位置将会非常痛苦。因为常规做法会把所有的数据都放在一个集合中，导致所有的位置计算都需要累加上之前所有的集合元素，才能得到正确的结果。使用`HTCompositeDataSource`可以避免出现这种问题。  
`+ [HTCompositeDataSource dataSourceWithDataSources:]` 方法能够将多个不同的 dataSource 组合成一个，使用时不用关心数据在整个数据源中的位置，每项数据的 indexPath 就是在各自数据源中的实际位置。
使用方法如下

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

*	`HTTableViewDataSource` 将实现了 `HTDataSourceDataModelProtocol`协议的array转换成 dataSource
*	将非array的数据对象转换成dataSource，并且通过***继承*** `HTTableViewDataSource` 添加 `UITableViewDelegate`的处理；通过判断 dataSource 数据的类型，自定义添加header 和footer。  
*	演示如何使用 `HTTableViewCompositeDataSource` 组合多个 dataSource
*	演示使用`HTTableViewDataSource`的方法设置cell的 `delegate`，取得cell上控件的点击回调

##HeartTouch 关于UITableView规范的总结

-	[UITableViewCell高度计算接口规范](https://git.hz.netease.com/hzzhangping/heartouch/blob/master/specification/ios/UITableViewCell%E9%AB%98%E5%BA%A6%E8%AE%A1%E7%AE%97%E6%8E%A5%E5%8F%A3%E8%A7%84%E8%8C%83.md)
-	[UITableViewCell设置数据的规范](https://git.hz.netease.com/hzzhangping/heartouch/blob/master/specification/ios/UITableViewCell%E8%AE%BE%E7%BD%AE%E6%95%B0%E6%8D%AE%E7%9A%84%E8%A7%84%E8%8C%83.md),这里使用协议 `HTTableViewCellModelProtocol` 规范 `UITableViewCell` 访问数据的接口为 `model`
-	规范table view cell 的类名和 cell identifier 相同
-	规范使用 `HTTableViewDataSource` 对象，完成 `dataSource` 和 `delegate` 的功能。

