# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "binary_merchant/version"

Gem::Specification.new do |s|
  s.name        = "binary_merchant"
  s.version     = BinaryMerchant::VERSION
  s.authors     = ["Neeraj Singh"]
  s.email       = ["neeraj@BigBinary.com"]
  s.homepage    = ""
  s.summary     = %q{A payment processing utility tool built on top of Active Merchant}
  s.description = %q{A payment processing utility tool built on top of Active Merchant}

  s.rubyforge_project = "binary_merchant"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
