//
//  ImagePickerManager.h
//  ImagePickerDemo
//
//  Created by 沈红榜 on 2018/7/3.
//  Copyright © 2018年 沈红榜. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import "GroupAssetModel.h"
#import "AssetModel.h"

@interface ImagePickerManager : NSObject

@property (nonatomic, strong, readonly) PHAssetCollection *allPhotoCollection;

+ (instancetype)sharedInstance;

@property (nonatomic, copy) NSString *(^selectToast)(AssetModel *willSelectModel, NSArray <AssetModel *>*selectedArray);
@property (nonatomic, copy) NSString *(^ensureToast)(NSArray <AssetModel *>*selectedArray);


- (void)fetchCollection:(void(^)(NSArray <GroupAssetModel *>*array))handler;
@property (nonatomic, strong, readonly) NSArray <GroupAssetModel *>*groupAssetArray;

- (PHFetchResult<PHAsset *>*)fetchAssetsWithCollection:(PHAssetCollection *)coll;

- (void)fetchOriginalImageWithAsset:(PHAsset *)asset handler:(void(^)(UIImage *image))handler;

@end
