---
<h3>HBImagePicker</h3>


> 示例代码

```
ImagePickerController *picker = [[ImagePickerController alloc] init];
picker.ensureToast = ^NSString *(NSArray<AssetModel *> *selectedArray) {
        
      
	NSLog(@"共选中了这些：\n%@", selectedArray);
        
	return nil;
};
    
picker.selectToast = ^NSString *(AssetModel *willSelectModel, NSArray<AssetModel *> *selectedArray) {
      
	if (selectedArray.count >= 3) {
		return @"最多选仨";
	}
	return nil;
};
    
[self presentViewController:picker animated:true completion:nil];
```

</br>

上面是拉起选择器的方法，返回的是 `AssetModel` 对象，其内有 `PHAsset` 类的对象 `asset`，而我们要用的并不是 `PHAsset` 对象，所以需要对其解析，方法如下：


```
if (asset.mediaType == PHAssetMediaTypeVideo) {
	[ImagePickerManager.sharedInstance fetchVideoWithAsset:asset handler:^(NSString *fileName, NSData *mediaData) {
		NSLog(@"文件名： %@  文件大小：%lu", fileName, (unsigned long)mediaData.length);
	}];
} else {
	[ImagePickerManager.sharedInstance fetchOriginalImageWithAsset:asset handler:^(UIImage *image) {
		NSLog(@"获取到的图片： %@", image);
	}];
}
```
