//
//  AssetModel.h
//  ImagePickerDemo
//
//  Created by 沈红榜 on 2018/7/4.
//  Copyright © 2018年 沈红榜. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

typedef NS_ENUM(NSUInteger, AssetType) {
    AssetTypeNormal,
    AssetTypeSelected,
    AssetTypeDisable,
};

@interface AssetModel : NSObject

@property (nonatomic, strong) PHAsset *asset;

@property (nonatomic, assign) AssetType type;

@property (nonatomic, copy, readonly) NSString *fileName;
@property (nonatomic, assign, readonly) BOOL bIsGif;
@property (nonatomic, assign, readonly) BOOL bIsVideo;

@end
