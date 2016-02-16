require 'minitest/autorun'
require 'minitest/unit'
require 'minitest/reporters'
Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new,
                          Minitest::Reporters::SpecReporter.new]
