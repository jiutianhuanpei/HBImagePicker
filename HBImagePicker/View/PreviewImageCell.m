//
//  PreviewCell.m
//  ImagePickerDemo
//
//  Created by 沈红榜 on 2018/7/4.
//  Copyright © 2018年 沈红榜. All rights reserved.
//

#import "PreviewImageCell.h"
#import <Photos/Photos.h>
#import "ImagePickerManager.h"
#import "SHBImageView.h"
#import <Masonry.h>

@interface PreviewImageCell ()

@property (nonatomic, strong) SHBImageView *imgView;

@end

@implementation PreviewImageCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _imgView = [[SHBImageView alloc] initWithFrame:self.bounds];
        _imgView.backgroundColor = UIColor.whiteColor;
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_imgView];
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.mas_equalTo(0);
        }];
    }
    return self;
}

- (void)configModel:(AssetModel *)model {
    _model = model;
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];

    [PHImageManager.defaultManager requestImageDataForAsset:model.asset options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        [self->_imgView configGifImageData:imageData];
        
    }];
    
}

@end
