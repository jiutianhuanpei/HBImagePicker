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
#import "ImagePickerEnum.h"

@interface ImagePickerManager : NSObject

@property (nonatomic, strong, readonly) GroupAssetModel *mainGroup;

+ (instancetype)sharedInstance;

@property (nonatomic, copy) NSString *(^selectToast)(AssetModel *willSelectModel, NSArray <AssetModel *>*selectedArray);
@property (nonatomic, copy) void(^ensureToast)(NSArray <AssetModel *>*selectedArray);
@property (nonatomic, assign) HBSelectType selectType;

@property (nonatomic, assign) BOOL bCanSelectVideo;

- (void)fetchCollection:(void(^)(NSArray <GroupAssetModel *>*array))handler;
@property (nonatomic, strong, readonly) NSArray <GroupAssetModel *>*groupAssetArray;

- (PHFetchResult<PHAsset *>*)fetchAssetsWithCollection:(PHAssetCollection *)coll;

- (void)fetchOriginalImageWithAsset:(PHAsset *)asset handler:(void(^)(UIImage *image))handler;
- (void)fetchVideoWithAsset:(PHAsset *)asset handler:(void(^)(NSString *fileName, NSData *mediaData))handler;

@end
