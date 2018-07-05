//
//  PreviewVideoCell.h
//  ImagePickerDemo
//
//  Created by 沈红榜 on 2018/7/4.
//  Copyright © 2018年 沈红榜. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AssetModel.h"

@interface PreviewVideoCell : UICollectionViewCell

@property (nonatomic, strong, readonly) AssetModel *model;
- (void)configModel:(AssetModel *)model;

- (void)stopPlay;

@end
