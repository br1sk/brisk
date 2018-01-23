platform :osx, "10.11"

use_frameworks!

target :Brisk do
  pod "Sonar", :git => "https://github.com/br1sk/Sonar.git"
  pod "Sparkle"
end

target :BriskTests do
  pod "Sonar", :git => "https://github.com/br1sk/Sonar.git"
end

post_install do |installer|
  installer.pods_project.root_object.attributes["LastUpgradeCheck"] = "9999"

  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings["SWIFT_VERSION"] = "4.0"
    end
  end
end
