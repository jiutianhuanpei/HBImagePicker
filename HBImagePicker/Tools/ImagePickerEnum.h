
//
//  ImagePickerEnum.h
//  ImagePickerDemo
//
//  Created by 沈红榜 on 2018/7/18.
//  Copyright © 2018年 沈红榜. All rights reserved.
//

#ifndef ImagePickerEnum_h
#define ImagePickerEnum_h

/**
 选择的类型

 - HBSelectSingleMediaType: 只能选择单一的类型（当选择图片时，视频不可选，默认视频只能选一个）
 - HBSelectDoubleMediaType: 可同时选择图片和视频
 */
typedef NS_ENUM(NSUInteger, HBSelectType) {
    HBSelectSingleMediaType,
    HBSelectDoubleMediaType,
};


#endif /* ImagePickerEnum_h */
