//
//  PreviewViewController.h
//  ImagePickerDemo
//
//  Created by 沈红榜 on 2018/7/4.
//  Copyright © 2018年 沈红榜. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AssetModel.h"

@interface PreviewViewController : UIViewController

- (instancetype)initWithDataSource:(NSArray <AssetModel *>*)dataSource currentIndex:(NSIndexPath *)currentIndex;

//这两个从detailVC 里传入
@property (nonatomic, strong) NSMutableDictionary   *selectDic; //用于记录选中的数据， key：indentifer, value: AssetModel
@property (nonatomic, strong) NSMutableArray        *selectArray;//用于记录记录选中数据的顺序，存放 indentifer

@property (nonatomic, copy) dispatch_block_t callback;


@end
