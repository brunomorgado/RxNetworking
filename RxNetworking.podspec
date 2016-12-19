Pod::Spec.new do |s|
  s.name             = "RxNetworking"
  s.version          = "2.0.2"
  s.summary          = "RxNetworking"
  s.homepage         = "https://github.com/brunomorgado"
  s.license          = 'MIT License'
  s.author           = { "bfcmorgado" => "brunofcmorgado@gmail.com" }
  s.source           = { :git => "https://github.com/brunomorgado/RxNetworking.git", :tag => s.version.to_s }
  s.platform     = :ios, '9.0'
  s.requires_arc = true
  s.dependency 'RxSwift', "~> 3.0"
  s.dependency 'Alamofire', "~> 4.0"
  s.source_files = 'RxNetworking/Classes/**/*.swift'
  s.resource_bundles = {
    'RxNetworking' => ['RxNetworking/Assets/*.png']
  }
end
