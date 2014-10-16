#
# Be sure to run `pod lib lint EDHFontSelector.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "EDHFontSelector"
  s.version          = "0.1.1"
  s.summary          = "Font settings interface for iOS"
  s.description      = <<-DESC
                       Congigure text style for text editor, developed for Edhita.
                       
                       # Parameters

                       * Font name
                       * Font size
                       * Text color
                       * Background color
                       DESC
  s.homepage         = "https://github.com/tnantoka/EDHFontSelector"
  s.screenshots      = "https://raw.githubusercontent.com/tnantoka/EDHFontSelector/master/screenshot.png"
  s.license          = 'MIT'
  s.author           = { "tnantoka" => "tnantoka@bornneet.com" }
  s.source           = { :git => "https://github.com/tnantoka/EDHFontSelector.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/tnantoka'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes'
  s.resource = 'Pod/Assets/EDHFontSelector.bundle'

  s.dependency 'EDHUtility', '~> 0.1'
end
