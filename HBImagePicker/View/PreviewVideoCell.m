//
//  PreviewVideoCell.m
//  ImagePickerDemo
//
//  Created by 沈红榜 on 2018/7/4.
//  Copyright © 2018年 沈红榜. All rights reserved.
//

#import "PreviewVideoCell.h"
#import <AVFoundation/AVFoundation.h>
#import <Masonry.h>
#import <Photos/Photos.h>

@interface VideoView : UIView

@property (nonatomic, strong) AVPlayer *player;

@end

@implementation VideoView

+ (Class)layerClass {
    return AVPlayerLayer.class;
}

- (void)setPlayer:(AVPlayer *)player {
    _player = player;
    
    AVPlayerLayer *layer = (AVPlayerLayer *)self.layer;
    
    layer.player = player;
}


@end


@interface PreviewVideoCell ()

@property (nonatomic, strong) VideoView *videoView;
@property (nonatomic, strong) UIButton *playBtn;

@end

@implementation PreviewVideoCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.videoView];
        [self addSubview:self.playBtn];
        
        __weak typeof(self) SHB = self;
        
        [_videoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.mas_equalTo(0);
        }];
        
        [_playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.centerX.mas_equalTo(SHB.mas_centerX);
            make.centerY.mas_equalTo(SHB.mas_centerY);
        }];
    }
    return self;
}

- (void)configModel:(AssetModel *)model {
    _model = model;
    
    [_videoView.player pause];
    _playBtn.hidden = false;
    
    __weak typeof(self) SHB = self;
    
    PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
    
    [PHImageManager.defaultManager requestPlayerItemForVideo:model.asset options:options resultHandler:^(AVPlayerItem * _Nullable playerItem, NSDictionary * _Nullable info) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [playerItem seekToTime:CMTimeMakeWithSeconds(0, 24)];
            [NSNotificationCenter.defaultCenter addObserverForName:AVPlayerItemDidPlayToEndTimeNotification object:playerItem queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull note) {
                [SHB stopPlay];
                [playerItem seekToTime:CMTimeMakeWithSeconds(0, 24)];
            }];
            
            AVPlayer *player = [AVPlayer playerWithPlayerItem:playerItem];
            
            SHB.videoView.player = player;
        });
    }];
}

- (void)clickedPlayBtn {
    [_videoView.player play];
    _playBtn.hidden = true;
}

- (void)stopPlay {
    [_videoView.player pause];
    _playBtn.hidden = false;
}

#pragma mark - getter
- (VideoView *)videoView {
    if (!_videoView) {
        _videoView = [[VideoView alloc] initWithFrame:CGRectZero];
        _videoView.userInteractionEnabled = true;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stopPlay)];
        [_videoView addGestureRecognizer:tap];
    }
    return _videoView;
}

- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBtn setImage:[UIImage imageNamed:@"videomsg_play"] forState:UIControlStateNormal];
        [_playBtn addTarget:self action:@selector(clickedPlayBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}



@end
