//
//  VideoCell.m
//  ImagePickerDemo
//
//  Created by 沈红榜 on 2018/7/4.
//  Copyright © 2018年 沈红榜. All rights reserved.
//

#import "VideoCell.h"
#import <Photos/Photos.h>
#if __has_include(<Masonry.h>)
#import <Masonry.h>
#else
#import "Masonry.h"
#endif

@interface VideoCell()

@property (nonatomic, strong) UIImageView       *imgView;
@property (nonatomic, strong) UILabel           *timeLbl;

@end

@implementation VideoCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imgView];
        [self addSubview:self.timeLbl];
        
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.mas_equalTo(0);
        }];
        [_timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.mas_equalTo(0);
        }];
    }
    return self;
}

- (void)configModel:(AssetModel *)model {
    _model = model;
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    
    __weak typeof(self) SHB = self;
    [PHImageManager.defaultManager requestImageForAsset:model.asset targetSize:self.bounds.size contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        dispatch_async(dispatch_get_main_queue(), ^{
            SHB.imgView.image = result;
        });
    }];
    
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
    });
    
    formatter.dateFormat = @"mm:ss";

    NSString *timeStr = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:ceil(model.asset.duration)]];
    _timeLbl.text = timeStr.length > 0 ? timeStr : @"视频";

}



#pragma mark - getter
- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imgView.contentMode = UIViewContentModeScaleToFill;
    }
    return _imgView;
}

- (UILabel *)timeLbl {
    if (!_timeLbl) {
        _timeLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLbl.font = [UIFont systemFontOfSize:14];
        _timeLbl.textColor = UIColor.orangeColor;
        _timeLbl.textAlignment = NSTextAlignmentCenter;
    }
    return _timeLbl;
}

@end
