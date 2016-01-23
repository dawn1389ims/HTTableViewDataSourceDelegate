// The MIT License (MIT)
//
// Copyright (c) 2015-2016 forkingdog ( https://github.com/forkingdog )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.


#import "UITableView+FDTemplateLayoutCell.h"
#import "UITableView+FDKeyedHeightCache.h"
#import "UITableView+FDIndexPathHeightCache.h"
#import "UITableView+FDTemplateLayoutCellDebug.h"

@interface UITableView (HTTemplateLayoutCell)

/// Returns height of cell of type specifed by a reuse identifier and configured
/// by the configuration block.
///
/// The cell would be layed out on a fixed-width, vertically expanding basis with
/// respect to its dynamic content, using auto layout. Thus, it is imperative that
/// the cell was set up to be self-satisfied, i.e. its content always determines
/// its height given the width is equal to the tableview's.
///
/// @param identifier A string identifier for retrieving and maintaining template
///        cells with system's "-dequeueReusableCellWithIdentifier:" call.
/// @param configuration An optional block for configuring and providing content
///        to the template cell. The configuration should be minimal for scrolling
///        performance yet sufficient for calculating cell's height.
///
- (CGFloat)ht_heightForCellWithIdentifier:(NSString *)identifier
                                    model:(id)entity
                            configuration:(void (^)(id cell))configuration;

/// This method does what "-fd_heightForCellWithIdentifier:configuration" does, and
/// calculated height will be cached by its index path, returns a cached height
/// when needed. Therefore lots of extra height calculations could be saved.
///
/// No need to worry about invalidating cached heights when data source changes, it
/// will be done automatically when you call "-reloadData" or any method that triggers
/// UITableView's reloading.
///
/// @param indexPath where this cell's height cache belongs.
///
- (CGFloat)ht_heightForCellWithIdentifier:(NSString *)identifier
                                    model:(id)entity
                         cacheByIndexPath:(NSIndexPath *)indexPath
                            configuration:(void (^)(id cell))configuration;

/// This method caches height by your model entity's identifier.
/// If your model's changed, call "-invalidateHeightForKey:(id <NSCopying>)key" to
/// invalidate cache and re-calculate, it's much cheaper and effective than "cacheByIndexPath".
///
/// @param key model entity's identifier whose data configures a cell.
///
- (CGFloat)ht_heightForCellWithIdentifier:(NSString *)identifier
                                    model:(id)entity
                               cacheByKey:(id<NSCopying>)key
                            configuration:(void (^)(id cell))configuration;

@end
