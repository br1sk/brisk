platform :osx, "10.11"

use_frameworks!

target :Brisk do
  pod "Sonar", :git => "https://github.com/PSPDFKit-labs/Sonar.git", :branch => 'peter/fileadupe'
end

target :BriskTests do
  pod "Sonar", :git => "https://github.com/PSPDFKit-labs/Sonar.git", :branch => 'peter/fileadupe'
end

post_install do |installer|
  installer.pods_project.root_object.attributes["LastUpgradeCheck"] = "9999"
end
