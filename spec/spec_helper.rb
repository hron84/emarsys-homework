# frozen_string_literal: true

require 'minitest/spec'
require 'minitest/autorun'

$LOAD_PATH.unshift "#{File.dirname(__dir__)}/lib"

require 'due_date_calculator'

Dir.glob("#{__dir__}/**/*_spec.rb").sort.each do |f|
  require f
end
