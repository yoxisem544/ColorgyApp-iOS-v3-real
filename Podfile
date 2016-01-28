# Uncomment this line to define a global platform for your project
# platform :ios, '8.1'

target 'ColorgyCourse' do
  pod "AFNetworking"
  pod "Fabric"
  pod "Crashlytics"
  pod "ImagePickerSheetController", "~> 0.9.1"
end

target 'ColorgyCourseTests' do

end

post_install do |installer|  
  installer.pods_project.build_configuration_list.build_configurations.each do |configuration|  
    configuration.build_settings['CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES'] = 'YES'  
  end  
end  