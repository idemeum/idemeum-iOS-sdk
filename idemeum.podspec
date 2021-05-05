

Pod::Spec.new do |spec|

  spec.name         = "idemeum"
  spec.version      = "1.0.0"
  spec.summary      = "Passwordless identity platform."

  spec.description  = "idemeum is a digital identity platform for building passwordless, private, and secure authentication for mobile and desktop apps. Drop in SDK and forget about the hassle of dealing with auth challenges."

  spec.homepage     = "https://github.com/idemeum/idemeum-ios-sdk"
  spec.license      = "MIT"
  spec.author       = { "Nik" => "support@idemeum.com" }
  spec.platform     = :ios, "14.0"

  spec.source       = { :git => "https://github.com/idemeum/idemeum-ios-sdk.git", :tag => "1.0.0" }
  spec.ios.vendored_frameworks = 'idemeum.framework'
  spec.preserve_paths = 'idemeum.framework'
  spec.swift_versions = "5.0"
  spec.exclude_files = "Classes/Exclude"
  spec.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  spec.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }

end
