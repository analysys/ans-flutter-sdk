#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'argo_flutter_plugin'
  s.version          = '1.0.0'
  s.summary          = 'Argo Flutter plugin.'
  s.description      = <<-DESC
Argo Flutter plugin.
                       DESC
  s.homepage         = 'https://ark.analysys.cn'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Analysys' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'AnalysysAgent', '~> 4.4.5'
  s.ios.deployment_target = '8.0'
end

