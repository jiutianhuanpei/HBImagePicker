//
//  ToolView.h
//  ImagePickerDemo
//
//  Created by 沈红榜 on 2018/7/4.
//  Copyright © 2018年 沈红榜. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ToolView : UIView

@property (nonatomic, copy) dispatch_block_t clickedEnsureBtn;

- (void)configEnsureBtnTitle:(NSString *)title;
- (void)configEnsureBtnEnable:(BOOL)enable;

@end
