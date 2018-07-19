//
//  ImageCell.m
//  ImagePickerDemo
//
//  Created by 沈红榜 on 2018/7/3.
//  Copyright © 2018年 沈红榜. All rights reserved.
//

#import "PhotoItem.h"
#import "ImagePickerManager.h"
#import "ImagePickerTools.h"
#if __has_include(<Masonry.h>)
#import <Masonry.h>
#else
#import "Masonry.h"
#endif

@interface PhotoItem ()

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIImageView *gifTip;
@property (nonatomic, strong) UIButton    *selectBtn;
@property (nonatomic, strong) UIView      *maskView;
@property (nonatomic, strong) UILabel     *timeLbl;


@end

@implementation PhotoItem

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.imgView];
        [self addSubview:self.gifTip];
        [self addSubview:self.selectBtn];
        [self addSubview:self.maskView];
        [self addSubview:self.timeLbl];
        
        __weak typeof(self) SHB = self;
        
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.mas_equalTo(0);
        }];
        
        [_gifTip mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.mas_equalTo(0);
        }];
        
        [_selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {

            make.right.mas_equalTo(SHB.mas_right).offset(-2);
            make.top.mas_equalTo(SHB.mas_top).offset(2);
            make.size.mas_equalTo(CGSizeMake(27, 27));
        }];
        [_maskView mas_makeConstraints:^(MASConstraintMaker *make) {
           make.top.left.bottom.right.mas_equalTo(0);
        }];
        
        [_timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.mas_equalTo(0);
        }];
    }
    return self;
}

- (void)configModel:(AssetModel *)asset {
    
    _model = asset;
    
    _gifTip.hidden = !asset.bIsGif;
    _selectBtn.hidden = asset.bIsVideo && ImagePickerManager.sharedInstance.selectType == HBSelectSingleMediaType;
    
    if (asset.bIsVideo) {
        _maskView.hidden = ImagePickerManager.sharedInstance.bCanSelectVideo;
    } else {
        _maskView.hidden = true;
    }
    
    switch (asset.type) {
        case AssetTypeNormal:
            _selectBtn.selected = false;
            break;
        case AssetTypeSelected:
            _selectBtn.selected = true;
            break;
        default:
            break;
    }
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.resizeMode = PHImageRequestOptionsResizeModeExact;
    
    __weak typeof(self) SHB = self;
    [PHImageManager.defaultManager requestImageForAsset:asset.asset targetSize:self.bounds.size contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        dispatch_async(dispatch_get_main_queue(), ^{
            SHB.imgView.image = result;
        });
    }];
    
    if (asset.bIsVideo) {
        _timeLbl.hidden = false;
        _timeLbl.attributedText = [ImagePickerTools videoDurationStringWith:asset.asset.duration];
    } else {
        _timeLbl.hidden = true;
    }
    
}

#pragma mark - action
- (void)clickedBtn:(UIButton *)btn {
    
    if (_model.type == AssetTypeNormal) {
        
        NSString *toast = !_selectToast ? nil : _selectToast(true, self);
        
        if (toast.length > 0) {
            NSLog(@"cell内不可选提示： %@", toast);
            return;
        }
        
        _model.type = AssetTypeSelected;
        _selectBtn.selected = true;
        
        __weak typeof(self) SHB = self;
        [UIView animateWithDuration:0.1 animations:^{
            SHB.selectBtn.transform = CGAffineTransformScale(SHB.selectBtn.transform, 1.2, 1.2);
        } completion:^(BOOL finished) {
            SHB.selectBtn.transform = CGAffineTransformIdentity;
        }];
        
    } else if (_model.type == AssetTypeSelected) {
        !_selectToast ? nil : _selectToast(false, self);

        _model.type = AssetTypeNormal;
        _selectBtn.selected = false;
    }
}

#pragma mark - getter
- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _imgView;
}

- (UIImageView *)gifTip {
    if (!_gifTip) {
        _gifTip = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_gif_mini"]];
    }
    return _gifTip;
}

- (UIButton *)selectBtn {
    if (!_selectBtn) {
        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectBtn setImage:[UIImage imageNamed:@"choose_photo_n"] forState:UIControlStateNormal];
        [_selectBtn setImage:[UIImage imageNamed:@"choose_photo_h"] forState:UIControlStateSelected];
        [_selectBtn addTarget:self action:@selector(clickedBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectBtn;
}

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:CGRectZero];
        _maskView.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.5];
    }
    return _maskView;
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
