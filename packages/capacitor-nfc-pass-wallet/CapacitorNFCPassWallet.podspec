Pod::Spec.new do |s|
  s.name = 'CapacitorNFCPassWallet'
  s.version = '0.1.0'
  s.summary = 'Capacitor plugin for NFC pass wallet integration'
  s.license = 'UNLICENSED'
  s.homepage = 'https://github.com/egym/lib-capacitor-nfc-pass-wallet'
  s.author = 'eGym'
  s.source = { :git => 'https://github.com/egym/lib-capacitor-nfc-pass-wallet.git', :tag => s.version.to_s }
  s.source_files = 'ios/Sources/**/*.{swift,h,m,c,cc,mm,cpp}'
  s.ios.deployment_target = '15.0'
  s.dependency 'Capacitor'
end
