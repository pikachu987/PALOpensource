#
# Be sure to run `pod lib lint PALOpensource.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'PALOpensource'
  s.version          = '0.1.0'
  s.summary          = 'PALOpensource'
  s.description      = <<-DESC
MyLib PALOpensource
                       DESC
  s.homepage         = 'https://github.com/pikachu987/PALOpensource'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'pikachu987' => 'pikachu77769@gmail.com' }
  s.source           = { :git => 'https://github.com/pikachu987/PALOpensource.git', :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'
  s.source_files = 'PALOpensource/Classes/**/*'
  s.swift_version = '5.0'
end
