platform :ios, '9.0'
workspace 'Smack'
use_frameworks!

def generalPod
    pod 'Alamofire'
    pod 'SwiftyJSON'
    pod 'Socket.IO-Client-Swift'
end


target 'Smack' do
    project 'Smack'
    generalPod
end

target 'CommonService' do
    project 'CommonService/CommonService'
    generalPod
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['CLANG_WARN_DOCUMENTATION_COMMENTS'] = 'NO'
        end
    end
end
