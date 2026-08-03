require 'json'

package = JSON.parse(File.read(File.join(__dir__, 'package.json')))

Pod::Spec.new do |s|
  s.name = 'CapacitorNFCPassWallet'
  s.version = package['version']
  s.summary = package['description']
  s.license = { :type => package['license'], :file => 'LICENSE' }
  s.homepage = 'https://github.com/egym/lib-capacitor-nfc-pass-wallet'
  s.author = 'eGym'
  s.source = { :git => 'https://github.com/egym/lib-capacitor-nfc-pass-wallet.git', :tag => s.version.to_s }
  s.source_files = 'ios/Sources/**/*.{swift,h,m,c,cc,mm,cpp}'
  s.ios.deployment_target = '15.0'
  s.swift_versions = ['5.9']
  s.dependency 'Capacitor', '>= 7.0', '< 9.0'
  s.frameworks = 'PassKit'
end
