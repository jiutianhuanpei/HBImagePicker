//
//  ImagePickerTolls.m
//  ImagePickerDemo
//
//  Created by 沈红榜 on 2018/7/4.
//  Copyright © 2018年 沈红榜. All rights reserved.
//

#import "ImagePickerTools.h"
#import <ImageIO/ImageIO.h>


#if __has_include(<MBProgressHUD.h>)
#import <MBProgressHUD.h>
#else
#import "MBProgressHUD.h"
#endif


@implementation ImagePickerTools

+ (GIFImage *)gifImageWithData:(NSData *)imageData {
    
    CGImageSourceRef source = CGImageSourceCreateWithData((CFDataRef)imageData, NULL);
    
    size_t imageNum = CGImageSourceGetCount(source);
    if (imageNum < 2) {
        UIImage *image = [UIImage imageWithData:imageData];
        return image;
    }
    
    NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:0];
    
    NSTimeInterval totalTime = 0;
    
    for (size_t i = 0; i < imageNum; i++) {
        
        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(source, i, NULL);
        UIImage *img = [UIImage imageWithCGImage:imageRef];
        [imageArray addObject:img];
        
        CGImageRelease(imageRef);
        
        CFDictionaryRef indexDic = CGImageSourceCopyPropertiesAtIndex(source, i, NULL);
        
        CFDictionaryRef gifDic = CFDictionaryGetValue(indexDic, kCGImagePropertyGIFDictionary);
        
        CFRelease(indexDic);
        
        CFNumberRef delayTime = CFDictionaryGetValue(gifDic, kCGImagePropertyGIFDelayTime);
        
        CGFloat delay = [(NSNumber *)CFBridgingRelease(delayTime) floatValue];
        
        if (delay == 0) {
            CFNumberRef unclampedDelayTime = CFDictionaryGetValue(gifDic, kCGImagePropertyGIFUnclampedDelayTime);
            delay = [(NSNumber *)CFBridgingRelease(unclampedDelayTime) floatValue];
        }
        totalTime += delay;
    }
    
    GIFImage *image = [UIImage animatedImageWithImages:imageArray duration:totalTime];
    
    return image;
}

+ (void)toast:(NSString *)toast toView:(UIView *)view {
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = toast;
    [view addSubview:hud];
    
    [hud showAnimated:true];
    [hud hideAnimated:true afterDelay:1.5];
    
}

+ (NSAttributedString *)videoDurationStringWith:(NSTimeInterval)duration {
    
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"mm:ss";
    });
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:duration];
    NSString *str = [formatter stringFromDate:date];
    
    UIImage *icon = [UIImage imageNamed:@"icon_video"];
    NSTextAttachment *attchment = [[NSTextAttachment alloc] initWithData:nil ofType:nil];
    attchment.image = icon;
    
    
    NSAttributedString *imgAtt = [NSAttributedString attributedStringWithAttachment:attchment];
    NSAttributedString *timeAtt = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@", str] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12], NSForegroundColorAttributeName : UIColor.whiteColor, NSBaselineOffsetAttributeName : @2}];
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithAttributedString:imgAtt];
    [attStr appendAttributedString:timeAtt];
        
    return attStr;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
