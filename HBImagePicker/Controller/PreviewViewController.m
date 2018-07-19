//
//  PreviewViewController.m
//  ImagePickerDemo
//
//  Created by 沈红榜 on 2018/7/4.
//  Copyright © 2018年 沈红榜. All rights reserved.
//

#import "PreviewViewController.h"
#import "PreviewImageCell.h"
#import "PreviewVideoCell.h"
#import "ToolView.h"
#import "ImagePickerManager.h"
#import "ImagePickerTools.h"
#if __has_include(<Masonry.h>)
#import <Masonry.h>
#else
#import "Masonry.h"
#endif

@interface PreviewViewController ()<UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView  *col;
@property (nonatomic, strong) ToolView            *toolView;


@property (nonatomic, strong) NSArray <AssetModel *>*dataSource;
@property (nonatomic, strong) NSIndexPath *currentIndex;

@end

@implementation PreviewViewController

- (instancetype)initWithDataSource:(NSArray<AssetModel *> *)dataSource currentIndex:(NSIndexPath *)currentIndex {
    self = [super init];
    if (self) {
        _dataSource = dataSource;
        _currentIndex = currentIndex;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
    self.automaticallyAdjustsScrollViewInsets = false;
    
    //choose_photo_n choose_photo_h
    
    AssetModel *model = _dataSource[_currentIndex.item];
    
    if (model.bIsVideo && ImagePickerManager.sharedInstance.selectType == HBSelectSingleMediaType) {
        self.navigationItem.rightBarButtonItem = nil;
    } else {
        
        NSString *imgName = model.type == AssetTypeNormal ? @"choose_photo_n" : @"choose_photo_h";
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:imgName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(selectImage:)];
    }
    

    [self.view addSubview:self.col];
    [self.view addSubview:self.toolView];
    
    __weak typeof(self) SHB = self;
    [_col mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        if (@available(iOS 11.0, *)) {
            make.top.mas_equalTo(SHB.view.mas_safeAreaLayoutGuideTop);
        } else {
            make.top.mas_equalTo(0);
        }
    }];
    
    [_toolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(SHB.col.mas_bottom);
        make.height.mas_equalTo(50);
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(SHB.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.mas_equalTo(0);
        }
    }];
    
    [self changeSelectNum];
    
    [self.view layoutIfNeeded];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [_col scrollToItemAtIndexPath:_currentIndex atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:true];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    !_callback ?: _callback();
}

- (void)selectImage:(UIBarButtonItem *)item {
    
    UIImage *image = nil;
    
    PreviewImageCell *currentCell = _col.visibleCells.firstObject;
    
    NSString *key = currentCell.model.asset.localIdentifier;
    
    if (currentCell.model.type == AssetTypeNormal) {
        
        ImagePickerManager *manager = ImagePickerManager.sharedInstance;
        
        NSString *toast = !manager.selectToast ? nil : manager.selectToast(currentCell.model, _selectDic.allValues);
        
        if (toast.length > 0) {
            [ImagePickerTools toast:toast toView:self.view];
            return;
        }
        
        currentCell.model.type = AssetTypeSelected;
        
        _selectDic[key] = currentCell.model;
        [_selectArray addObject:key];
        
        image = [[UIImage imageNamed:@"choose_photo_h"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    } else {
        currentCell.model.type = AssetTypeNormal;
        
        _selectDic[key] = nil;
        [_selectArray removeObject:key];
        
        image = [[UIImage imageNamed:@"choose_photo_n"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(selectImage:)];

    [self changeSelectNum];
}

- (void)changeSelectNum {
    
    NSString *title = nil;
    if (_selectDic.count == 0) {
        title = @"完成";
    } else {
        title = [NSString stringWithFormat:@"完成(%lu)", (unsigned long)_selectDic.count];
    }
    [_toolView configEnsureBtnTitle:title];
}

- (void)clickedToolViewEnsureBtn {
    
    NSMutableArray <AssetModel *>*array = [NSMutableArray arrayWithCapacity:0];
    
    for (NSString *key in _selectArray) {
        AssetModel *model = _selectDic[key];
        if (model) {
            [array addObject:model];
        }
    }
    
    ImagePickerManager *manager = ImagePickerManager.sharedInstance;
    
    if (array.count == 0) {
        
        NSIndexPath *currentIndex = _col.indexPathsForVisibleItems.firstObject;
        AssetModel *model = _dataSource[currentIndex.item];
        
        NSString *toast = !manager.selectToast ? nil : manager.selectToast(model, nil);
        if (toast.length > 0) {
            [ImagePickerTools toast:toast toView:self.view];
            return;
        }
        
        !manager.ensureToast ?: manager.ensureToast(@[model]);
        
        [self dismissViewControllerAnimated:true completion:nil];
        return;
    }
        
    
    !manager.ensureToast ?: manager.ensureToast(array);
        
    [self dismissViewControllerAnimated:true completion:nil];
}

#pragma mark - <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = nil;
    AssetModel *model = _dataSource[indexPath.item];

    if (model.bIsVideo) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(PreviewVideoCell.class) forIndexPath:indexPath];
        [(PreviewVideoCell *)cell configModel:model];
    } else {
        
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(PreviewImageCell.class) forIndexPath:indexPath];
        [(PreviewImageCell *)cell configModel:model];
    }
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _dataSource.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = CGSizeMake(CGRectGetWidth(collectionView.frame) - 10, CGRectGetHeight(collectionView.frame) - 10);
    return size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    PreviewImageCell *item = (PreviewImageCell *)_col.visibleCells.firstObject;
    
    if (item.model.bIsVideo && ImagePickerManager.sharedInstance.selectType == HBSelectSingleMediaType) {
        self.navigationItem.rightBarButtonItem = nil;
        return;
    }
    
    UIImage *image = nil;
    
    if (item.model.type == AssetTypeNormal) {
        image = [[UIImage imageNamed:@"choose_photo_n"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    } else {
        image = [[UIImage imageNamed:@"choose_photo_h"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(selectImage:)];
}


#pragma mark - getter
- (UICollectionView *)col {
    
    if (!_col) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;

        _col = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [_col registerClass:PreviewImageCell.class forCellWithReuseIdentifier:NSStringFromClass(PreviewImageCell.class)];
        [_col registerClass:PreviewVideoCell.class forCellWithReuseIdentifier:NSStringFromClass(PreviewVideoCell.class)];
        _col.backgroundColor = UIColor.blackColor;
        _col.pagingEnabled = true;
        _col.delegate = self;
        _col.dataSource = self;
        _col.showsHorizontalScrollIndicator = false;
    }
    return _col;
}

- (ToolView *)toolView {
    if (!_toolView) {
        _toolView = [[ToolView alloc] initWithFrame:CGRectZero];
        __weak typeof(self) SHB = self;
        _toolView.clickedEnsureBtn = ^{
            [SHB clickedToolViewEnsureBtn];
        };
    }
    return _toolView;
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
