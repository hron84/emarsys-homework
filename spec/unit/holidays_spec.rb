# frozen_string_literal: true

describe DueDateCalculator do
  # Generate a random year
  subject { DueDateCalculator.new(ENV.key?('SPEC_YEAR') ? ENV['SPEC_YEAR'].to_i : rand(2221) + 1) }

  describe 'holidays' do
    it 'should not be empty' do
      _(subject.holidays).wont_be_empty
    end

    it 'should contain default 14 items' do
      _(subject.holidays.size).must_equal 14
    end
  end

  describe 'work_saturdays' do
    it 'should be all saturday' do
      subject.work_saturdays.each do |d|
        _(d.wday).must_equal 6
      end
    end
  end
end
