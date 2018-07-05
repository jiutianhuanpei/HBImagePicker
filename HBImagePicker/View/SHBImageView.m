//
//  SHBImageView.m
//  GIFDemo
//
//  Created by 沈红榜 on 2018/6/22.
//  Copyright © 2018年 沈红榜. All rights reserved.
//

#import "SHBImageView.h"

@interface SHBImageView ()

@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, strong) NSMutableDictionary * frameDuration;
@property (nonatomic) CGImageSourceRef  source;

@property (nonatomic, strong, readonly) NSData  *gifData;

@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) CGFloat totalTime;
@property (nonatomic, assign) CGFloat currentTime;
@property (nonatomic, assign) CGFloat currentPropress;

@property (nonatomic, assign) NSInteger space;

@end

@implementation SHBImageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self instaceImageView];
    }
    return self;
}

- (void)instaceImageView {

    _frameDuration = [NSMutableDictionary dictionaryWithCapacity:0];
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(playGif)];
    [_displayLink addToRunLoop:NSRunLoop.mainRunLoop forMode:NSRunLoopCommonModes];
}


- (void)playGif {
    
    NSNumber *currentDur = _frameDuration[@(_currentIndex)];

    _currentPropress += _displayLink.duration;
    if (_currentTime > _currentPropress) {
        return;
    }
    
    _currentTime += currentDur.doubleValue;
    
    
    _currentIndex++;
    if (_currentIndex == CGImageSourceGetCount(_source)) {
        _currentIndex = 0;
        
        _currentPropress = 0;
        _currentTime = 0;
    }
    [self.layer setNeedsDisplay];
}

- (void)displayLayer:(CALayer *)layer {
    CGImageRef imgRef = CGImageSourceCreateImageAtIndex(_source, _currentIndex, NULL);
    self.layer.contents = CFBridgingRelease(imgRef);
}

- (void)configGifImageData:(NSData *)gifData {
    _gifData = gifData;
    
    [_frameDuration removeAllObjects];
    _source = CGImageSourceCreateWithData((__bridge CFDataRef)gifData, NULL);
    
    if (CGImageSourceGetCount(_source) == 1) {
        _displayLink.paused = true;
        UIImage *img = [UIImage imageWithData:gifData];
        self.image = img;
        return;
    }
    _displayLink.paused = false;
    for (size_t i = 0; i < CGImageSourceGetCount(_source); i++) {
        
        CFDictionaryRef dicRef = CGImageSourceCopyPropertiesAtIndex(_source, i, NULL);
        
        CFDictionaryRef pro = CFDictionaryGetValue(dicRef, kCGImagePropertyGIFDictionary);
     
        CFNumberRef delay = CFDictionaryGetValue(pro, kCGImagePropertyGIFDelayTime);
        
        NSNumber *num = CFBridgingRelease(delay);
        
        if (num.floatValue == 0) {
            delay = CFDictionaryGetValue(pro, kCGImagePropertyGIFUnclampedDelayTime);
            num = CFBridgingRelease(delay);
        }
        _totalTime += (num.floatValue);
        _frameDuration[@(i)] = num;
    }
}

- (void)beginGif {
    _displayLink.paused = false;
}

- (void)stopGif {
    _displayLink.paused = true;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
