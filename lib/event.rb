class Event < ActiveRecord::Base

  def self.find_range(end_date)
    events = Event.all.where.not(:start => nil).where(:start => Date.today..end_date).order(:start)
  end
  def self.past_range(start_date)
    events = Event.all.where(:start => start_date..Date.today).order(:start)
  end
end


