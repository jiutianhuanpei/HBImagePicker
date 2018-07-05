//
//  GroupAssetModel.h
//  ImagePickerDemo
//
//  Created by 沈红榜 on 2018/7/4.
//  Copyright © 2018年 沈红榜. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface GroupAssetModel : NSObject

@property (nonatomic, strong) PHAssetCollection     *collection;
@property (nonatomic, strong) PHAsset               *coverAsset;
@property (nonatomic, assign) NSInteger             totalNum;

@end
