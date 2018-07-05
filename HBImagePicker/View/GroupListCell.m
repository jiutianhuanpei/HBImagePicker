//
//  GroupListCell.m
//  ImagePickerDemo
//
//  Created by 沈红榜 on 2018/7/4.
//  Copyright © 2018年 沈红榜. All rights reserved.
//

#import "GroupListCell.h"
#if __has_include(<Masonry.h>)
#import <Masonry.h>
#else
#import "Masonry.h"
#endif

@interface GroupListCell ()

@property (nonatomic, strong) UIImageView   *imgView;
@property (nonatomic, strong) UILabel       *titleLbl;

@end

@implementation GroupListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        [self addSubview:self.imgView];
        [self addSubview:self.titleLbl];
        
        __weak typeof(self) SHB = self;
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(SHB.mas_height);
            make.left.mas_equalTo(10);
            make.top.bottom.mas_equalTo(0);
            
        }];
        
        [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(SHB.mas_centerY);
            make.left.mas_equalTo(SHB.imgView.mas_right).offset(20);
        }];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)configModel:(GroupAssetModel *)col {
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    
    [PHImageManager.defaultManager requestImageForAsset:col.coverAsset targetSize:CGSizeMake(100, 100) contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {

        self.imgView.image = result;
    }];
    
    _titleLbl.text = [NSString stringWithFormat:@"%@（%ld）", col.collection.localizedTitle, (long)col.totalNum];
}

+ (CGFloat)rowHeight {
    return 70;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

#pragma mark - getter
- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imgView.contentMode = UIViewContentModeScaleToFill;
    }
    return _imgView;
}

- (UILabel *)titleLbl {
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLbl.textColor = UIColor.blackColor;
    }
    return _titleLbl;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
