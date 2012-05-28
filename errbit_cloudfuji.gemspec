# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'errbit_cloudfuji/version'

Gem::Specification.new do |s|
  s.name = 'errbit_cloudfuji'
  s.authors = ['Sean Grove', 'Nathan Broadbent']
  s.email = 's@cloudfuji.com'
  s.homepage = 'http://cloudfuji.com'
  s.summary = 'Errbit - Cloudfuji Integration'
  s.description = 'Integrates Errbit with the Cloudfuji hosting platform.'
  s.files = `git ls-files`.split("\n")
  s.version = Errbit::Cloudfuji::VERSION

  s.add_dependency 'cloudfuji',           '>= 0.0.42'
  s.add_dependency 'devise_cloudfuji_authenticatable'

end
