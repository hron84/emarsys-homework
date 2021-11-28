# frozen_string_literal: true

require 'date'

# Due Date Calculator
class DueDateCalculator
  attr_reader :year, :holidays, :work_saturdays

  def initialize(year = Time.now.year)
    @year = year
    # STDERR.puts "DEBUG: year: #{year}"
  end

  def due_date(start_month, start_day, workdays)
    start_date = Date.new(year, start_month, start_day)

    wdays = []

    wdays << if workday?(start_date)
               start_date
             else
               find_next_workday(start_date)
             end

    # We already handled the start date
    (workdays - 1).to_i.times do
      wdays << find_next_workday(wdays.last + 1)
    end

    wdays
  end

  def find_next_workday(date)
    date += 1 until workday?(date)
    date
  end

  def holiday?(date)
    # Count sunday as holiday
    holidays.include?(date) or date.wday.zero? or (date.wday == 6 and !work_saturdays.include?(date))
  end

  def workday?(date)
    # Cheating...
    work_saturdays.include?(date) or !holiday?(date)
  end

  def leapyear?
    if (year % 400).zero?
      true
    elsif (year % 100).zero?
      false
    else
      (year % 4).zero?
    end
  end

  def month_lengths
    [
      31,
      (leapyear? ? 28 : 29),
      31,
      30,
      31,
      30,
      31,
      31,
      30,
      31,
      30,
      31
    ]
  end

  def holidays
    return @holidays if @holidays

    _easter = thisyear(*easter)

    easter_monday = _easter + 1

    good_friday = _easter - 2

    pentecost = thisyear(*easter) + 49

    @holidays = [
      thisyear(1, 1),
      thisyear(3, 15),
      good_friday,
      _easter,
      easter_monday,
      pentecost,
      pentecost + 1,
      thisyear(5, 1),
      thisyear(8, 20),
      thisyear(10, 23),
      thisyear(11, 1),
      thisyear(12, 24),
      thisyear(12, 25),
      thisyear(12, 26)
    ]
  end

  def work_saturdays
    return @work_saturdays if @work_saturdays

    # Get fix-dated holidays, except X-mas and new year
    fixed_holidays = ((1..11).to_a - (2..6).to_a).map { |i| holidays[i] }
    @work_saturdays = []

    fixed_holidays.each do |d|
      if (d.month == 12) && (d.day == 24) && (d.wday == 5)
        # Handle dec 24 specially, if its a friday,
        # then 2 weeks before we schedule a workday
        # This calculation is rough, since hungarian rules
        # aren't too specific in this topic
        @work_saturdays << (d - 13)
      elsif d.wday == 2
        # Add the previous day as holiday
        holidays << (d - 1)
        # saturday, 2 week before
        @work_saturdays << (d - 10)
      elsif d.wday == 4
        holidays << (d + 1)

        # saturday, 2 week before
        @work_saturdays << (d - 12)
      end
    end

    @work_saturdays
  end

  private

  def thisyear(month, day)
    Date.new(year, month, day)
  end

  def easter
    a = year % 19
    b = year / 100
    c = year % 100
    d = b / 4
    e = b % 4
    f = (b + 8) / 25
    g = (b - f + 1) / 3
    h = ((19 * a) + b - d - g + 15) % 30
    i = c / 4
    k = c % 4
    l = (32 + (2 * e) + (2 * i) - h - k) % 7
    m = (a + (11 * h) + (22 * l)) / 451
    x = h + l - (7 * m) + 114
    month = x / 31
    day = (x % 31) + 1

    [month, day]
  end
end
