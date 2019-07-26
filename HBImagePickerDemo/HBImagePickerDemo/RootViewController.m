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
    
    
    
}

- (void)showImagePicker {
    
    ImagePickerController *picker = ImagePickerController.new;
    
    [self presentViewController:picker animated:true];
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
