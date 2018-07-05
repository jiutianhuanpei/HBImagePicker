//
//  SHBImageView.h
//  GIFDemo
//
//  Created by 沈红榜 on 2018/6/22.
//  Copyright © 2018年 沈红榜. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHBImageView : UIImageView

- (void)configGifImageData:(NSData *)gifData;

- (void)beginGif;
- (void)stopGif;

@end
