//
//  ImageCell.h
//  ImagePickerDemo
//
//  Created by 沈红榜 on 2018/7/3.
//  Copyright © 2018年 沈红榜. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AssetModel.h"

@interface ImageCell : UICollectionViewCell

@property (nonatomic, strong, readonly) AssetModel *model;

@property (nonatomic, copy) NSString *(^selectToast)(BOOL willSelect, ImageCell *cell);

- (void)configModel:(AssetModel *)asset;


@end
