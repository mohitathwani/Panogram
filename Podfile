# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

target 'Panogram' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Panogram
  #pod "Pastel"
pod 'SnapKit'
pod 'SVProgressHUD'
pod 'ASJTagsView'

  target 'PanogramTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'PanogramUITests' do
    inherit! :search_paths
    # Pods for testing
  end
  
  swift_4_1_pod_targets = ['SnapKit']
  
  post_install do | installer |
    installer.pods_project.targets.each do |target|
      if swift_4_1_pod_targets.include?(target.name)
        target.build_configurations.each do |config|
          config.build_settings['SWIFT_VERSION'] = '4.1'
        end
      end
    end
  end

end
