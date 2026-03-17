Pod::Spec.new do |s|
  s.name = 'egym_nfc_pass_wallet'
  s.version = '0.1.0'
  s.summary = 'Flutter plugin for EGYM NFC pass wallet integration.'
  s.description = <<-DESC
Flutter plugin for EGYM NFC pass wallet integration.
  DESC
  s.homepage = 'https://github.com/egym/lib-capacitor-nfc-pass-wallet'
  s.license = { :type => 'Proprietary' }
  s.author = { 'eGym' => 'mobile@egym.com' }
  s.source = { :path => '.' }
  s.source_files = 'ios/Classes/**/*'
  s.platform = :ios, '15.0'
  s.swift_version = '5.9'
  s.dependency 'Flutter'
  s.frameworks = 'PassKit'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
end