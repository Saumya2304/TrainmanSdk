Pod::Spec.new do |spec|
  spec.name             = 'Trainman_iOSSDK'
  spec.version          = '0.0.1'
  spec.license          = { :type => 'MIT', :file => 'LICENSE' }
  spec.homepage         = 'https://github.com/Saumya2304/TrainmanSdk'
  spec.authors          =  { '<Somya Badoniya>' => '<feedback@trainman.in>' }
  spec.summary          = 'TrainmanBookingSDK helps a client to provide a complete solution for train ticket booking on their iOS app seamlessly.'
  spec.source           = { :git => 'https://github.com/Saumya2304/TrainmanSdk.git', :tag => '0.0.1' }
  spec.source_files     = 'TrainmanBooking_iOSSDK/**/*.{Swift,h,xib}'
  spec.framework        = 'SystemConfiguration'
  spec.requires_arc     = true
end
