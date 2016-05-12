Pod::Spec.new do |spec|
  spec.name = "MEKit"
  spec.version = "1.3.0"
  spec.authors = {"William Towe" => "willbur1984@gmail.com", "Norm Barnard" => "norm@meetmaestro.com", "Jason Anderson" => "jason@meetmaestro.com" }
  spec.license = {:type => "MIT", :file => "LICENSE.txt"}
  spec.homepage = "https://github.com/TeamMaestro/MEKit"
  spec.source = {:git => "https://github.com/TeamMaestro/MEKit.git", :tag => spec.version.to_s}
  spec.summary = "A collection of classes that extend the UIKit framework."
  spec.description = "This library contains a number of useful categories on UIColor, UIFont, UIImage, UITableViewCell, and UIView."
  
  spec.platform = :ios, "8.0"
  
  spec.dependency "MEFoundation", "~> 1.1.0"
  spec.requires_arc = true
  spec.frameworks = "Foundation", "CoreGraphics", "CoreText", "UIKit", "QuartzCore", "Accelerate", "CoreImage"
  
  spec.source_files = "MEKit"
end
