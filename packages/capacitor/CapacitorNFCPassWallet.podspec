require 'json'

package = JSON.parse(File.read(File.join(__dir__, 'package.json')))

Pod::Spec.new do |s|
  s.name = 'CapacitorNFCPassWallet'
  s.version = package['version']
  s.summary = package['description']
  s.license = package['license']
  s.homepage = 'https://github.com/egym/lib-capacitor-nfc-pass-wallet'
  s.author = 'eGym'
  s.source = { :git => 'https://github.com/egym/lib-capacitor-nfc-pass-wallet.git', :tag => package['name'] + '@' + package['version'] }
  s.source_files = 'ios/Sources/**/*.{swift,h,m,c,cc,mm,cpp}'
  s.ios.deployment_target = '15.0'
  s.swift_versions = ['5.9']
  s.dependency 'Capacitor'
  s.frameworks = 'PassKit'
end
