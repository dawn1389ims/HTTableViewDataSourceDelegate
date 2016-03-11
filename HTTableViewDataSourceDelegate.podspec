# coding: utf-8
#
#  Be sure to run `pod spec lint HTTableViewDataSourceDelegate.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|


  s.name         = "HTTableViewDataSourceDelegate"
  s.version      = "0.0.1"
  s.summary      = "simple table view dataSource & delegate."

  s.description  = <<-DESC
                   简单易用的table view dataSource & delegate, 提供简单的接口来访问数据和设置cell，
                   让使用者从table view的重复代码中解脱出来；
                   包含cell的高度计算功能；
                   支持多个dataSource的组合；
                   DESC

  s.homepage     = "https://g.hz.netease.com/hzzhuzhiqiang/HTTableViewDataSourceDelegate"

  s.license      = "MIT"

  s.author             = { "hzzhuzhiqiang" => "hzzhuzhiqiang@corp.netease.com" }

  s.source       = { :git => 'https://g.hz.netease.com/hzzhuzhiqiang/HTTableViewDataSourceDelegate.git' }

  s.platform     = :ios, "7.0"

  s.ios.deployment_target = "7.0"

  s.source_files   =            "HTTableViewDataSourceDelegate/*.{h,m}"
  s.public_header_files =       "HTTableViewDataSourceDelegate/*.h"

  s.dependency 'UITableView+FDTemplateLayoutCell', '~> 1.4'
end
