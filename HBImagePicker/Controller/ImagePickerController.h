//
//  ImagePickerController.h
//  ImagePickerDemo
//
//  Created by 沈红榜 on 2018/7/3.
//  Copyright © 2018年 沈红榜. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AssetModel.h"
#import "ImagePickerEnum.h"

@interface ImagePickerController : UINavigationController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController DEPRECATED_ATTRIBUTE;

- (instancetype)init;

@property (nonatomic, copy) NSString *(^selectToast)(AssetModel *willSelectModel, NSArray <AssetModel *>*selectedArray);
@property (nonatomic, copy) void(^ensureToast)(NSArray <AssetModel *>*selectedArray);
@property (nonatomic, assign) HBSelectType selectType;


@end
