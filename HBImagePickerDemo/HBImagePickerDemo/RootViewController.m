//
//  RootViewController.m
//  HBImagePickerDemo
//
//  Created by 沈红榜 on 2019/7/26.
//  Copyright © 2019 沈红榜. All rights reserved.
//

#import "RootViewController.h"
#import "ImagePickerController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [btn sizeToFit];
    [btn addTarget:self action:@selector(showImagePicker) forControlEvents:UIControlEventTouchUpInside];
    btn.center = self.view.center;
    [self.view addSubview:btn];
    
}

- (void)showImagePicker {
    
    ImagePickerController *picker = ImagePickerController.new;
    
    [picker setEnsureToast:^(NSArray<AssetModel *> *selectedArray) {
        
        NSLog(@"select Images: \n%@", selectedArray);
        
    }];
    
    [self presentViewController:picker animated:true completion:nil];
    
    
}



@end
