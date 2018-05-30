Pod::Spec.new do |s|
s.name         = "YPAppMonitor" # 项目名称
s.version      = "0.0.1"        # 版本号 与 你仓库的 标签号 对应
s.license      = "MIT"          # 开源证书
s.summary      = "私人pod代码" # 项目简介

s.homepage     = "https://github.com/zhuyuping/YPAppMonitor" # 仓库的主页
s.source       = { :git => "https://github.com/zhuyuping/YPAppMonitor.git", :tag => "#{s.version}" }#你的仓库地址，不能用SSH地址
s.source_files = "YPAppMonitor/*.{h,m}" # 你代码的位置， BYPhoneNumTF/*.{h,m} 表示 BYPhoneNumTF 文件夹下所有的.h和.m文件
s.requires_arc = true # 是否启用ARC
s.platform     = :ios, "8.0" #平台及支持的最低版本
# s.frameworks   = "UIKit", "Foundation" #支持的框架
# s.dependency   = "AFNetworking" # 依赖库

# User
s.author             = { "ZYP" => "iOS Dev" } # 作者信息
s.social_media_url   = "https://www.jianshu.com/u/7aa04dd59fb3" # 个人主页

end

