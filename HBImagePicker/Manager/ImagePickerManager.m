//
//  ImagePickerManager.m
//  ImagePickerDemo
//
//  Created by 沈红榜 on 2018/7/3.
//  Copyright © 2018年 沈红榜. All rights reserved.
//

#import "ImagePickerManager.h"
#import "ImagePickerTools.h"

@interface ImagePickerManager ()


@end

@implementation ImagePickerManager

+ (instancetype)sharedInstance {
    static ImagePickerManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ImagePickerManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)fetchGrand:(dispatch_block_t)callback {
    
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status != PHAuthorizationStatusAuthorized) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                !callback ?: callback();
            }
        }];
    } else {
        !callback ?: callback();
    }
}

- (void)fetchCollection:(void(^)(NSArray <GroupAssetModel *>*array))handler {
    
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        PHFetchResult<PHAssetCollection *>*systemArray = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:options];
        
        PHFetchResult<PHAssetCollection *>*userArray = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:options];
        
        
        NSMutableArray *allGroupArray = [NSMutableArray arrayWithCapacity:0];
        [systemArray enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.localizedTitle isEqualToString:@"所有照片"] ||
                [obj.localizedTitle isEqualToString:@"All Photos"] ||
                [obj.localizedTitle isEqualToString:@"相机胶卷"] ||
                [obj.localizedTitle isEqualToString:@"Camera Roll"]) {
                self->_allPhotoCollection = obj;
                [allGroupArray insertObject:obj atIndex:0];
            } else {
                [allGroupArray addObject:obj];
            }
        }];
        
        [userArray enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [allGroupArray addObject:obj];
        }];
        
        NSMutableArray *groupArray = [NSMutableArray arrayWithCapacity:0];//用于过滤空相册
        
        for (PHAssetCollection *col in allGroupArray) {
            
            
            PHFetchResult <PHAsset *>* allAsset = [PHAsset fetchAssetsInAssetCollection:col options:options];
            
            if (allAsset.count == 0) {
                continue;
            }
            
            GroupAssetModel *model = [[GroupAssetModel alloc] init];
            model.collection = col;
            model.coverAsset = allAsset.firstObject;
            model.totalNum = allAsset.count;
            [groupArray addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self->_groupAssetArray = groupArray;
            !handler ?: handler(groupArray);
        });
    });
}

- (PHFetchResult<PHAsset *>*)fetchAssetsWithCollection:(PHAssetCollection *)coll {

    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:false]];
    
    PHFetchResult<PHAsset *>*assets = [PHAsset fetchAssetsInAssetCollection:coll options:options];
    
    return assets;
}

- (void)fetchOriginalImageWithAsset:(PHAsset *)asset handler:(void(^)(UIImage *image))handler {
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    
    BOOL isGif = [[asset valueForKey:@"filename"] hasSuffix:@"GIF"];
    
    [PHImageManager.defaultManager requestImageDataForAsset:asset options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {

        if (isGif) {
            GIFImage *image = [ImagePickerTools gifImageWithData:imageData];
            !handler ?: handler(image);
        } else {
            UIImage *image = [UIImage imageWithData:imageData];
            !handler ?: handler(image);
        }
    
    }];
}
- (void)fetchVideoWithAsset:(PHAsset *)asset handler:(void (^)(NSString *, NSData *))handler {
    
    NSArray *array = [PHAssetResource assetResourcesForAsset:asset];
    
    PHAssetResource *resource = nil;
    
    for (PHAssetResource *temp in array) {
        if (temp.type == PHAssetResourceTypeVideo) {
            resource = temp;
            break;
        }
    }
    
    if (!resource) {
        !handler ?: handler(nil, nil);
        return;
    }
    
    
    PHAssetResourceRequestOptions *options = [[PHAssetResourceRequestOptions alloc] init];
    options.networkAccessAllowed = true;
    
    NSMutableData *resultData = [NSMutableData dataWithCapacity:0];
    
    [PHAssetResourceManager.defaultManager requestDataForAssetResource:resource options:options dataReceivedHandler:^(NSData * _Nonnull data) {
        [resultData appendData:data];
    } completionHandler:^(NSError * _Nullable error) {
        
        if (error) {
            !handler ?: handler(nil, nil);
        } else {
            !handler ?: handler(resource.originalFilename, resultData);
        }
    }];
}

@end
