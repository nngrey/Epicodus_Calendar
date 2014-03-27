 require 'spec_helper'
 # require './lib/event'

describe Event do
  describe '.find_range' do
    it 'return an array of events for a specified date range' do
      test_event1 = Event.create({ :description => 'Walk the Dog', :location => 'roadside',
                                   :start => '2014-03-29 18:30', :end => '2014-03-29 19:30'})
      test_event2 = Event.create({ :description => 'Walk the Cat', :location => 'roadside',
                                  :start => '2014-02-27 18:30', :end => '2014-02-27 19:30'})
      Event.find_range(Date.today + 7).should eq [test_event1]
    end
  end
end
