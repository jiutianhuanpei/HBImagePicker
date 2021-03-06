//
//  GroupDetailController.m
//  ImagePickerDemo
//
//  Created by 沈红榜 on 2018/7/3.
//  Copyright © 2018年 沈红榜. All rights reserved.
//

#import "GroupDetailController.h"
#import "PhotoItem.h"
#import "ImagePickerManager.h"
#import "PreviewViewController.h"
#import "ImagePickerTools.h"

#import "ToolView.h"

#if __has_include(<Masonry.h>)
#import <Masonry.h>
#else
#import "Masonry.h"
#endif

CGFloat k_space = 5;

@interface GroupDetailController ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong, readonly) GroupAssetModel *group;

@property (nonatomic, strong) NSMutableArray    *allAssets;

@property (nonatomic, strong) UICollectionView  *col;
@property (nonatomic, strong) ToolView            *toolView;

@property (nonatomic, strong) NSMutableDictionary   *selectDic; //用于记录选中的数据， key：indentifer, value: AssetModel
@property (nonatomic, strong) NSMutableArray        *selectArray;//用于记录记录选中数据的顺序，存放 indentifer

@end

@implementation GroupDetailController

- (instancetype)initWithGroup:(GroupAssetModel *)group {
    self = [super init];
    if (self) {
        _group = group;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
    
    _allAssets = [NSMutableArray arrayWithCapacity:0];
    _selectDic = [NSMutableDictionary dictionaryWithCapacity:0];
    _selectArray = [NSMutableArray arrayWithCapacity:0];
    
    [self.view addSubview:self.col];
    [self.view addSubview:self.toolView];    
    
    [self addConstraint];
    [self reloadUI];
}

- (void)dismiss {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)addConstraint {

    __weak typeof(self) SHB = self;
    [_col mas_makeConstraints:^(MASConstraintMaker *make) {
    
        make.left.top.right.mas_equalTo(0);
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
}

- (void)reloadUI {
    
    [_allAssets removeAllObjects];
    
    if (_group) {
        
        [self configGroup:_group];
    } else {
        [ImagePickerManager.sharedInstance fetchCollection:^(NSArray<GroupAssetModel *> *array) {
            
            [self configGroup:ImagePickerManager.sharedInstance.mainGroup];
            
//            self.navigationItem.title = ImagePickerManager.sharedInstance.allPhotoCollection.localizedTitle;
//            PHFetchResult<PHAsset *>*fetchResult = [ImagePickerManager.sharedInstance fetchAssetsWithCollection:ImagePickerManager.sharedInstance.allPhotoCollection];
//            __weak typeof(self) SHB = self;
//            [fetchResult enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                
//                AssetModel *model = [[AssetModel alloc] init];
//                model.asset = obj;
//                model.type = AssetTypeNormal;
//                [SHB.allAssets addObject:model];
//                
//            }];
//            [SHB.col reloadData];
        }];
    }
}

- (void)configGroup:(GroupAssetModel *)group {
    
    [_allAssets removeAllObjects];
    
    self.navigationItem.title = group.collection.localizedTitle;
    
    PHFetchResult<PHAsset *>*fetchResult = [ImagePickerManager.sharedInstance fetchAssetsWithCollection:group.collection];
    __weak typeof(self) SHB = self;
    [fetchResult enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        AssetModel *model = [[AssetModel alloc] init];
        model.asset = obj;
        model.type = AssetTypeNormal;
        [SHB.allAssets addObject:model];
        
    }];
    [_col reloadData];
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
    
    !manager.ensureToast ?: manager.ensureToast(array);
    
    [self dismiss];
}

#pragma mark - <UICollectionViewDelegate, UICollectionViewDataSource>
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    AssetModel *model = _allAssets[indexPath.row];
    PhotoItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(PhotoItem.class) forIndexPath:indexPath];
    [cell configModel:model];
    
    __weak typeof(self) SHB = self;
    [cell setSelectToast:^NSString *(BOOL willSelect, PhotoItem *item) {
        NSString *toast = [SHB selectAssetToast:willSelect cell:item];
        return toast;
    }];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return _allAssets.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat itemW = (CGRectGetWidth(UIScreen.mainScreen.bounds) - 5 * k_space) / 4;
    
    return CGSizeMake(itemW, itemW);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    ImagePickerManager *manager = ImagePickerManager.sharedInstance;
    
    AssetModel *model = _allAssets[indexPath.item];

    if (model.bIsVideo && !manager.bCanSelectVideo) {
        return;
    }
    
    
    PreviewViewController *VC = [[PreviewViewController alloc] initWithDataSource:_allAssets currentIndex:indexPath];
    VC.selectDic = _selectDic;
    VC.selectArray = _selectArray;
    
    __weak typeof(self) SHB = self;
    VC.callback = ^{
        [SHB changeEnsureBtn];
        [SHB.col reloadData];
    };
    [self.navigationController pushViewController:VC animated:true];
    
}

#pragma mark - 图片是否可选
- (NSString *)selectAssetToast:(BOOL)willSelect cell:(PhotoItem *)cell {
    
    NSString *key = cell.model.asset.localIdentifier;
    ImagePickerManager *manager = ImagePickerManager.sharedInstance;

    if (!willSelect) {
        //取消选择
        _selectDic[key] = nil;
        [_selectArray removeObject:key];
        [self changeEnsureBtn];
        
        if (_selectArray.count == 0) {
            manager.bCanSelectVideo = true;
            
            NSArray *videoCells = [_col.visibleCells filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.model.bIsVideo = %d", true]];
            
            if (videoCells.count > 0) {
                
                NSMutableArray *indexArray = [NSMutableArray arrayWithCapacity:0];
                
                for (UICollectionViewCell *cell in videoCells) {
                    NSIndexPath *index = [_col indexPathForCell:cell];
                    [indexArray addObject:index];
                }
                [_col reloadItemsAtIndexPaths:indexArray];
            }
        }
        
        return nil;
    }
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    
    for (NSString *key in _selectArray) {
        AssetModel *model = _selectDic[key];
        [array addObject:model];
    }
    
    
    NSString *toast = !manager.selectToast ? nil : manager.selectToast(cell.model, array);
    
    if (toast.length > 0) {
        NSLog(@"这个不能选： %@", toast);
        [ImagePickerTools toast:toast toView:self.view];
        return toast;
    }
    
    _selectDic[key] = cell.model;
    [_selectArray addObject:key];
    [self changeEnsureBtn];
    
    //屏蔽视频
    if (manager.selectType == HBSelectSingleMediaType && !cell.model.bIsVideo && manager.bCanSelectVideo) {
        // 只能选单一类型时，选择图片，可选视频
        manager.bCanSelectVideo = false;
        
        NSArray *videoCells = [_col.visibleCells filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.model.bIsVideo = %d", true]];
        
        if (videoCells.count > 0) {
            
            NSMutableArray *indexArray = [NSMutableArray arrayWithCapacity:0];
            
            for (UICollectionViewCell *cell in videoCells) {
                NSIndexPath *index = [_col indexPathForCell:cell];
                [indexArray addObject:index];
            }
            [_col reloadItemsAtIndexPaths:indexArray];
        }
    }
    
    
    return nil;
}

- (void)changeEnsureBtn {
    
    NSString *title = nil;
    if (_selectArray.count == 0) {
        title = @"确定";
        [_toolView configEnsureBtnEnable:false];
    } else {
        title = [NSString stringWithFormat:@"确定(%lu)", (unsigned long)_selectArray.count];
        [_toolView configEnsureBtnEnable:true];
    }
    [_toolView configEnsureBtnTitle:title];
}

#pragma mark - getter
- (UICollectionView *)col {
    if (!_col) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(k_space, k_space, k_space, k_space);
        layout.minimumLineSpacing = k_space;
        layout.minimumInteritemSpacing = k_space;
        
        _col = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _col.backgroundColor = UIColor.whiteColor;
        
        [_col registerClass:PhotoItem.class forCellWithReuseIdentifier:NSStringFromClass(PhotoItem.class)];
        _col.delegate = self;
        _col.dataSource = self;
        
    }
    return _col;
}

- (ToolView *)toolView {
    if (!_toolView) {
        _toolView = [[ToolView alloc] initWithFrame:CGRectZero];
        [_toolView configEnsureBtnEnable:false];
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
