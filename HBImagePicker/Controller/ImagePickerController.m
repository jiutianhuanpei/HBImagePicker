//
//  ImagePickerController.m
//  ImagePickerDemo
//
//  Created by 沈红榜 on 2018/7/3.
//  Copyright © 2018年 沈红榜. All rights reserved.
//

#import "ImagePickerController.h"
#import "GroupListViewController.h"
#import "GroupDetailController.h"
#import "ImagePickerManager.h"

@interface ImagePickerController ()

@end

@implementation ImagePickerController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    self = [self init];
    return self;
}

- (instancetype)init {
    
    GroupListViewController *VC = [[GroupListViewController alloc] init];

    
    self = [super initWithRootViewController:VC];
    if (self) {
        GroupDetailController *detail = [[GroupDetailController alloc] init];
        
        [self pushViewController:detail animated:false];
    }
    return self;
}

- (void)setSelectToast:(NSString *(^)(AssetModel *, NSArray<AssetModel *> *))selectToast {
    _selectToast = selectToast;
    ImagePickerManager.sharedInstance.selectToast = selectToast;
}

- (void)setEnsureToast:(NSString *(^)(NSArray<AssetModel *> *))ensureToast {
    _ensureToast = ensureToast;
    ImagePickerManager.sharedInstance.ensureToast = ensureToast;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

@end





