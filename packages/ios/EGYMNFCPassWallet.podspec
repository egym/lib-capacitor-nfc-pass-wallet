Pod::Spec.new do |s|
  s.name = 'EGYMNFCPassWallet'
  s.version = '0.1.0'
  s.summary = 'iOS SDK for EGYM NFC pass wallet integration'
  s.homepage = 'https://github.com/egym/lib-capacitor-nfc-pass-wallet'
  s.license = { :type => 'Proprietary' }
  s.author = { 'eGym' => 'mobile@egym.com' }
  s.source = { :git => 'https://github.com/egym/lib-capacitor-nfc-pass-wallet.git', :tag => s.version.to_s }
  s.platform = :ios, '15.0'
  s.swift_version = '5.9'
  s.source_files = 'Sources/EGYMNFCPassWallet/**/*.swift'
  s.frameworks = 'PassKit'
end
