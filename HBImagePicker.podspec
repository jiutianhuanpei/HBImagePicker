Pod::Spec.new do |s|

  s.name         = "HBImagePicker"
  s.version      = "0.0.2"
  s.summary      = "图片、视频选择器"

  s.description  = <<-DESC
    图片、视频选择器。
                   DESC

  s.homepage     = "https://www.shenhongbang.cc"

  s.license      = "MIT"
  s.author       = { "shenhongbang" => "shenhongbang@163.com" }

  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/jiutianhuanpei/HBImagePicker.git", :tag => s.version }

  s.source_files  = "HBImagePicker/Controller/*", "HBImagePicker/Manager/*","HBImagePicker/Model/*","HBImagePicker/Tools/*","HBImagePicker/View/*"
  s.resources  = ["HBImagePicker/Resource/*.png"]
  s.frameworks = "AVFoundation", "ImageIO", "Photos", "UIKit"
  s.requires_arc = true
  
  s.dependency  'Masonry' #这个是此库依赖的三方库
  s.dependency  'MBProgressHUD' #这个是此库依赖的三方库
  s.xcconfig = {
  'USER_HEADER_SEARCH_PATHS' => '$(inherited) $(SRCROOT)/Masonry $(SRCROOT)/MBProgressHUD'  #这个是配置路径，如果本库有依赖与三方的文件，需要配置这个，否则报错
  }

end
