#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_yimeiduo_voice.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_yimeiduo_voice'
  s.version          = '0.0.1'
  s.summary          = 'A new Flutter plugin.'
  s.description      = <<-DESC
A new Flutter plugin.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.resource_bundles = {
    'voiceBundle' => ['Classes/voice_tts/*','Classes/voice_tts/more/*']
  }
  s.dependency 'Flutter'
  s.platform = :ios, '10.0'
  s.frameworks = 'UIKit','AVFoundation'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
