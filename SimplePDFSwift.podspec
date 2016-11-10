#
# Be sure to run `pod lib lint SimplePDF.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "SimplePDFSwift"
  s.version          = "0.2.1"
  s.summary          = "A Swift class to help generate simple PDF documents with page numbers and Table of Contents."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!
  s.description      = <<-DESC
SimplePDF is a Swift class to create PDF documents with page numbers and table of contents. SimplePDF generated document may have:

* Headings (H1 - H6) and Body Text.
* Images (with captions), multiple images per row.
* Multi column text (can be used for borderless tables too)
* UIView instances (good for cover pages, etc)
* Any attributed string
DESC

  s.homepage         = "https://github.com/ishaq/SimplePDF"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Muhammad Ishaq" => "ishaq@involution.co" }
  s.source           = { :git => "https://github.com/ishaq/SimplePDF.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  # s.resource_bundles = {
  #   'SimplePDF' => ['Pod/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
