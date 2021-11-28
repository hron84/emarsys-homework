# frozen_string_literal: true

describe DueDateCalculator do
  # This test is written for 2021 since we expect exact results
  subject { DueDateCalculator.new(2021) }


  describe 'including easter' do
    it 'should not contain easter' do
      easters = [Date.new(2021,04,04), Date.new(2021,04,05)]
      wdays = subject.due_date(04, 02, 10)
      
      _(wdays).wont_be_empty

      easters.each do |d|
        _(wdays).wont_include d
      end
    end

    it 'should contain exact dates' do
      wdays = subject.due_date(04, 02, 10)

      _(wdays).wont_be_empty
      # Map dates as numbers to make expected definiton simpler
      tested_days = wdays.map { |d| [d.month, d.day] }

      expected_days = [
        [ 4,  6],
        [ 4,  7],
        [ 4,  8],
        [ 4,  9],
        [ 4, 12],
        [ 4, 13],
        [ 4, 14],
        [ 4, 15],
        [ 4, 16],
        [ 4, 19],
      ]
      _(tested_days).must_equal expected_days
    end
  end

  describe 'including christmas' do
    let(:wdays) { subject.due_date(12,10,14) }

    it 'should not be empty' do
      _(wdays).wont_be_empty
    end

    it 'should not contain xmas' do
      tested_days = wdays.map { |d| [d.month, d.day] }

      (24..26).each do |xmas|
        _(tested_days).wont_include [12, xmas]
      end
    end

    it 'should contain specific dates' do 
      tested_days = wdays.map { |d| [d.month, d.day] }
      
      expected_days = [
        [12, 10],
        [12, 11],
        [12, 13],
        [12, 14],
        [12, 15],
        [12, 16],
        [12, 17],
        [12, 20],
        [12, 21],
        [12, 22],
        [12, 23],
        [12, 27],
        [12, 28],
        [12, 29],
      ]

      _(tested_days).must_equal expected_days
    end
  end
end
