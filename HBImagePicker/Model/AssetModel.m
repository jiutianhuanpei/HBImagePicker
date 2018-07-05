//
//  AssetModel.m
//  ImagePickerDemo
//
//  Created by 沈红榜 on 2018/7/4.
//  Copyright © 2018年 沈红榜. All rights reserved.
//

#import "AssetModel.h"

@implementation AssetModel

- (NSString *)fileName {
    return [_asset valueForKey:@"filename"];
}

- (BOOL)bIsGif {
    BOOL ret = [self.fileName hasSuffix:@"GIF"];
    return ret;
}

- (BOOL)bIsVideo {
    
    BOOL ret = _asset.mediaType == PHAssetMediaTypeVideo;
    
    return ret;
}

@end
