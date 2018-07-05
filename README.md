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
