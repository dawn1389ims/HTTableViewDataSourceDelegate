#HeartTouch UITableView dataSource和delegate的规范

##常见UITableView dataSource的写法
`UITableView`是UIKit最重要的控件之一，它是使用委托模式最经典的例子。它通过属性`delegate`和`dataSource`来完成配置，这两个属性分别遵守协议`UITableViewDelegate`和`UITableViewDataSource`。  
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
其余可选实现的方法包括：配置section，配置section title，添加删除table rows，整理table rows 等。  
使用时一般会把 table view 所在view controller设为`delegate`和`dataSource`，在view controller中配置 table view，但是这种写法存在几个问题：第一，每次配置table view都会重复这一套取数据的流程，第二，这些代码会增加 view controller 的代码量。  
为了能够方便地配置 table view ，减少 view controller 的代码量，HeartTouch规范使用 `HTTableViewDataSourceDelegate` 来作为`dataSource` 和 `delegate`。  

下面称 table view 需要展示的数据的集合为"数据列表"。table view 的作用就是将数据列表中的每一条数据展示到对应的`UITableViewCell`上。

## HTTableViewDataSourceDelegate使用方式

Pods使用方式: `pod 'HTTableViewDataSourceDelegate', :git => 'https://g.hz.netease.com/hzzhuzhiqiang/HTTableViewDataSourceDelegate.git', :branch => 'master'`

## HTTableViewDataSourceDelegate

`HTTableViewDataSourceDelegate` 可以直接处理数据列表，让使用者在`UITableView`协议接口的实现中，只用关心数据，不需要关心在哪个位置应该使用什么数据，应该怎么设置cell，怎么计算cell高度，最大程度地简化`UITableView`的配置。
使用时设置好`+ [HTTableViewDataSourceDelegate dataSourceWithModel: cellTypeMap: cellConfiguration:]`需要的参数即可。

参数的详细介绍：
	    
*	model         
数据列表，需要遵守 `HTTableViewDataSourceDataModelProtocol` 协议。   
下面演示一个`NSArray`类对这个协议的实现：

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
建议为数据列表添加一个遵守该协议的分类，将遵守协议的代码独立出来。
		
*	cellTypeMap   
	描述cell model 到cell identifier 或 cell class的对应关系。规范cell identifier和cell class一致。    
	[UITableViewCell设置数据的规范](https://git.hz.netease.com/hzzhangping/heartouch/blob/master/specification/ios/UITableViewCell%E8%AE%BE%E7%BD%AE%E6%95%B0%E6%8D%AE%E7%9A%84%E8%A7%84%E8%8C%83.md)规定这里用到的UITableViewCell类都应该实现`model`属性。

*	tableViewDelegate  
	传入需要实现UITableViewDelegate接口的view controller，注意高度计算接口已经被实现。

*	cellConfiguration   
在 cell 设置 model 结束后额外的设置cell属性的机会，可根据 indexPath 配置 cell。下面会提到高度计算有可能需要在这里设置cell。

下面演示该方法的使用： `HTTableViewDataSourceDelegate` 根据设置好的cellModel到cell的映射，将一个`NSArray`类型的数据列表，转换为`dataSource`。可在[Demo代码的地址](https://git.hz.netease.com/git/hzzhuzhiqiang/HTTableViewDataSourceDemo.git)中查看MyDemoArrayViewController的代码。  

在view controller实现文件中导入头文件

	#import "HTTableViewDataSourceDelegate.h"
	#import "NSArray+DataSource.h" //数据列表在这里完成协议的遵守，参考下面对model参数的解释
	#import "MyCellStringModel.h"	//cell model类型
	#import "MyTableViewCell.h"		//cell类型，遵守协议HTTableViewCellModelProtocol
	
实现一个取得数据的方法，例如

	- (id <HTTableViewDataSourceDataModelProtocol>)arrayCellModels
	{
	    NSMutableArray * models = [NSMutableArray new];
	    for (NSString * arg in @[@"A", @"B", @"C", @"D", @"E", @"F"]) {
	        [models addObject:[MyCellStringModel modelWithTitle:arg]];
	    }
	    return models;
	}
在配置 table view 的地方构造 dataSource 对象

		id <HTTableViewDataSourceDataModelProtocol> cellModels = [self arrayCellModels];//用户的数据列表
	    id <UITableViewDataSource, UITableViewDelegate> dataSource
	    = [HTTableViewDataSourceDelegate dataSourceWithModel:cellModels
	                                     cellTypeMap:@{@"MyCellStringModel" : @"MyTableViewCell"}// 数据类到cell类名的映射
	                               tableViewDelegate:self
	                               cellConfiguration:
	       ^(UITableViewCell *cell, NSIndexPath *indexPath) {
	        if (indexPath.row % 2 == 0) {
	            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	        }
	    }];
	    
使用这个 dataSource

		self.demoDataSource = dataSource;//持有 dataSource
	    _tableview.dataSource = dataSource;
	    _tableview.delegate = dataSource;
	    [_tableview reloadData];  

到这里就完成了一个`UITableView`的接口配置。
		
###继承实现更多UITableViewDataSource配置
`HTTableViewDataSourceDelegate`只实现了`tableView: cellForRowAtIndexPath:`,`numberOfSectionsInTableView:`,`numberOfSectionsInTableView`三个方法，要实现更多的UITableViewDataSource协议方法，可以继承`HTTableViewDataSourceDelegate`，在继承类中添加实现。

###Cell的高度计算
`HTTableViewDataSourceDelegate`默认实现了cell的高度计算处理，实现细节参照[UITableViewCell高度计算接口规范](https://git.hz.netease.com/hzzhangping/heartouch/blob/master/specification/ios/UITableViewCell%E9%AB%98%E5%BA%A6%E8%AE%A1%E7%AE%97%E6%8E%A5%E5%8F%A3%E8%A7%84%E8%8C%83.md)。

下面介绍`HTTableViewDataSourceDelegate`如何处理和view controller关联密切的接口：  
往往view controller需要在例如`tableView:tableView didSelectRowAtIndexPath:`的接口中修改某些状态，或者触发一个页面的展示，那么这个接口放在 view controller 中就会比较方便。
如果要在 view controller 实现除了cell高度计算之外的`UITableViewDelegate`接口，只要将 view controller传入`+dataSourceWithModel:cellTypeMap:tableViewDelegate:cellConfiguration:`方法的`tableViewDelegate`参数，再将`HTTableViewDataSourceDelegate`设为 table view 的`delegate`即可。 

## 使用HTCompositeDataSourceDelegate
`HTCompositeDataSourceDelegate`能够直接将多个 dataSource 组合成一个，然后将这些 dataSource 的内容按组合顺序展示在一个table view中。  
如果一个 table view 使用了超过一个的数据列表展示多类数据的组合，管理数据的位置会比较麻烦，尤其是数据源的数据个数可以变化时。因为常规做法会把所有的数据都放在一个集合中，导致位置计算需要累加上之前所有的数据个数，才能得到最终显示时的数据位置。`HTCompositeDataSourceDelegate`通过将多个dataSource合并成为一个的方式解决了这个问题，dataSource中的元素只需要关心在当前数据列表中的位置，不用关心在组合结果中的位置。  
使用方法如下  
导入头文件
	
	#import "HTTableViewDataSourceDelegate.h"
	#import "HTTableViewCompositeDataSourceDelegate.h"

构造 composite dataSource 对象，设置给 table view

		//自定义 dataSource
	    HTTableViewDataSourceDelegate * dataSource1;
	    HTTableViewDataSourceDelegate * modelDataSource;
	    //data source array
	    NSMutableArray < UITableViewDataSource, UITableViewDelegate >* dataSourceList = @[].mutableCopy;
	    [dataSourceList addObject:dataSource1];
	    [dataSourceList addObject:modelDataSource];
	    //composite data source array
	    id <UITableViewDataSource, UITableViewDelegate> dataSource
	    = [HTTableViewCompositeDataSourceDelegate dataSourceWithDataSources:dataSourceList];
		//use for table view
	    self.demoDataSource = dataSource;//VC持有 dataSource
		_tableview.dataSource = dataSource;
	    _tableview.delegate = dataSource;
	    [_tableview reloadData];

##Demo演示内容
HTTableViewDataSourceDemo演示了如下内容，具体内容参考[Demo](https://git.hz.netease.com/git/hzzhuzhiqiang/HTTableViewDataSourceDemo.git)的代码  
Demo的四个Tab页面代表不同的演示内容  

*	"Array" 演示将数组构造成一个`HTTableViewDataSourceDelegate`
*	"User Model" 演示将用户自定义的数据列表构造成一个`HTTableViewDataSourceDelegate`；`MyDemoUserModelViewController`演示使用`tableViewDelegate`参数配置更多的`UITableViewDelegate`的方法；`MyCustomHTTableViewDataSource`演示继承`HTTableViewDataSourceDelegate`配置更多`UITableViewDataSource`方法
*	"Composite" 演示使用 `HTTableViewCompositeDataSourceDelegate` 组合多个 dataSource
*	"Cell Delegate" 演示需要设置 `delegate`的cell的`HTTableViewDataSourceDelegate`的使用；演示使用非Autolayout布局的cell的高度计算

##HeartTouch UITableView 规范的总结
-	规范使用`HTTableViewDataSourceDelegate`实例作为`UITableView`的`dataSource` 和 `delegate`。
-	[UITableViewCell设置数据的规范](https://git.hz.netease.com/hzzhangping/heartouch/blob/master/specification/ios/UITableViewCell%E8%AE%BE%E7%BD%AE%E6%95%B0%E6%8D%AE%E7%9A%84%E8%A7%84%E8%8C%83.md)规定自定义`UITableViewCell` 要遵守 `HTTableViewCellModelProtocol`：cell访问数据的接口为 `model`。
-	规范table view cell 的类名和 cell identifier 相同。
-	[UITableViewCell高度计算接口规范](https://git.hz.netease.com/hzzhangping/heartouch/blob/master/specification/ios/UITableViewCell%E9%AB%98%E5%BA%A6%E8%AE%A1%E7%AE%97%E6%8E%A5%E5%8F%A3%E8%A7%84%E8%8C%83.md)。
