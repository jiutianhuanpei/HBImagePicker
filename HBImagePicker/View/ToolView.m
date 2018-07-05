//
//  ToolView.m
//  ImagePickerDemo
//
//  Created by 沈红榜 on 2018/7/4.
//  Copyright © 2018年 沈红榜. All rights reserved.
//

#import "ToolView.h"
#import "ImagePickerTools.h"
#if __has_include(<Masonry.h>)
#import <Masonry.h>
#else
#import "Masonry.h"
#endif

@interface ToolView ()

@property (nonatomic, strong) UIView    *line;
@property (nonatomic, strong) UIButton  *sureBtn;


@end

@implementation ToolView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.groupTableViewBackgroundColor;
        
        [self addSubview:self.line];
        [self addSubview:self.sureBtn];
        
        __weak typeof(self) SHB = self;
        [_line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(0);
            make.height.mas_equalTo(1 / UIScreen.mainScreen.scale);
        }];
        [_sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(SHB.mas_right).offset(-20);
            make.height.mas_equalTo(30);
            make.centerY.mas_equalTo(SHB.mas_centerY);
        }];
        
    }
    return self;
}

- (void)clickedBtn {
    !_clickedEnsureBtn ?: _clickedEnsureBtn();
}

- (void)configEnsureBtnTitle:(NSString *)title {
    [_sureBtn setTitle:title forState:UIControlStateNormal];
}

- (void)configEnsureBtnEnable:(BOOL)enable {
    _sureBtn.enabled = enable;
    
    if (enable) {
        _sureBtn.backgroundColor = UIColor.greenColor;
    } else {
        _sureBtn.backgroundColor = UIColor.grayColor;
    }
    
}

#pragma mark - getter
- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] initWithFrame:CGRectZero];
        _line.backgroundColor = UIColorWithHexString(0xdcdcdc);
    }
    return _line;
}

- (UIButton *)sureBtn {
    if (!_sureBtn) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureBtn.backgroundColor = UIColor.greenColor;
        [_sureBtn setTitle:@"完成" forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _sureBtn.layer.cornerRadius = 5;
        _sureBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
        [_sureBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_sureBtn addTarget:self action:@selector(clickedBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
