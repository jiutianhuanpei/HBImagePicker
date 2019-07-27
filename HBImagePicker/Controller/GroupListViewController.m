//
//  GroupListViewController.m
//  ImagePickerDemo
//
//  Created by 沈红榜 on 2018/7/3.
//  Copyright © 2018年 沈红榜. All rights reserved.
//

#import "GroupListViewController.h"
#import "ImagePickerManager.h"
#import "GroupDetailController.h"
#import "GroupListCell.h"

@interface GroupListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView   *tableView;
@property (nonatomic, strong) NSArray       *groupArray;

@end

@implementation GroupListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
    self.navigationItem.title = @"照片";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
    
    [self.view addSubview:self.tableView];
    
    __weak typeof(self) SHB = self;
    
    if (ImagePickerManager.sharedInstance.groupAssetArray.count > 0) {
        self.groupArray = ImagePickerManager.sharedInstance.groupAssetArray;
        [self.tableView reloadData];
    } else {
        [ImagePickerManager.sharedInstance fetchCollection:^(NSArray<GroupAssetModel *> *array) {
            SHB.groupArray = array;
            [SHB.tableView reloadData];
        }];
    }
    
}

- (void)dismiss {
    [self dismissViewControllerAnimated:true completion:nil];
}

#pragma mark - <UITableViewDelegate, UITableViewDataSource>
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GroupListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(GroupListCell.class) forIndexPath:indexPath];
    
    GroupAssetModel *col = _groupArray[indexPath.row];
    
    [cell configModel:col];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _groupArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GroupAssetModel *col = _groupArray[indexPath.row];
    GroupDetailController *detail = [[GroupDetailController alloc] initWithGroup:col];
    
    [self.navigationController pushViewController:detail animated:true];
}


#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        [_tableView registerClass:GroupListCell.class forCellReuseIdentifier:NSStringFromClass(GroupListCell.class)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = [GroupListCell rowHeight];
        _tableView.tableFooterView = UIView.new;
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
