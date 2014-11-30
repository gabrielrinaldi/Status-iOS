platform :ios, '7.0'

xcodeproj 'Status', 'AppStore' => :release, 'AdHoc' => :release

pod 'AFNetworking', '~> 2.0.3', :inhibit_warnings => true
pod 'CSNotificationView', '~> 0.3.3'
pod 'SVPullToRefresh', '~> 0.4.1'

post_install do | installer |
    require 'fileutils'
    FileUtils.cp_r('Pods/Pods-Acknowledgements.plist', 'Status/Settings.bundle/Acknowledgements.plist', :remove_destination => true)
end
