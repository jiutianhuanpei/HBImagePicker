//
//  ImagePickerTolls.h
//  ImagePickerDemo
//
//  Created by 沈红榜 on 2018/7/4.
//  Copyright © 2018年 沈红榜. All rights reserved.
//

#import <UIKit/UIKit.h>

#define UIColorWithHexString(hexInt) [UIColor colorWithRed:((hexInt & 0xff0000) >> 16) / 255. green:((hexInt & 0xff00) >> 8) / 255. blue:(hexInt & 0xff) / 255. alpha:1]

typedef UIImage GIFImage;

@interface ImagePickerTools : NSObject

+ (GIFImage *)gifImageWithData:(NSData *)imageData;

+ (void)toast:(NSString *)toast toView:(UIView *)view;

@end
