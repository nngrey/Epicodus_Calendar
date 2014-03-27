require 'bundler/setup'
Bundler.require(:default)
require 'pry'
require './lib/event.rb'

Dir[File.dirname(__FILE__) + './lib/*.rb'].each { |file| require file }

ActiveRecord::Base.establish_connection(YAML::load(File.open('./db/config.yml'))["development"])

def welcome
  system "clear"
  puts "**************Calendar****************\n\n"
  puts "                                          "
  puts "                                          "
  puts "     copyright 2014 Nathan & Marty        "
  puts "                                          "
  puts "                                          "
  puts "                                          "
  puts "**************Calendar****************\n\n"
  sleep(1)
  main_menu
end

def main_menu
  user_input = nil
  until user_input == 'x'
    puts "\n\n"
    puts "Press 'e' to enter an event."
    puts "Press 'ak' to enter a task."
    puts "Press 'l' to list future events."
    puts "Press 't' to list today's events."
    puts "Press 'w' to list events for the next week."
    puts "Press 'm' to list events for the next month."
    puts "Press 'pw' to list events from the past week."
    puts "Press 'pm' to list events from the past month."
    puts "Press 'tk' to list tasks"
    puts "Press 'x' to exit"
    user_input = gets.chomp
    system "clear"

    case user_input
    when 'e'
      add_event
    when 'ak'
      add_task
    when 'l'
      # list_events
      events = Event.all.order(:start)
      display_events(events)
    when 't'
      end_date = Date.today+1
      events = Event.find_range(end_date)
      display_events(events)
    when 'w'
      end_date = Date.today+7
      events = Event.find_range(end_date)
      display_events(events)
    when 'm'
      end_date = Date.today+30
      events = Event.find_range(end_date)
      display_events(events)
    when 'pw'
      start_date = Date.today-7
      events = Event.past_range(start_date)
      display_events(events)
    when 'pm'
      start_date = Date.today-30
      events = Event.past_range(start_date)
      display_events(events)
    when 'tk'
      events = Event.all
      display_tasks(events)
    when 'x'
      puts "Goodbye"
    else
      puts "Please enter a valid choice"
    end
  end
end

def add_event
  puts "Please add an event."
  event_description = gets.chomp

  puts "Please enter a location for this event."
  event_location = gets.chomp

  puts "Please provide a start for this event."
  puts "ex: 2012-04-14 22:30"
  event_start = gets.chomp

  puts "Please provide an end for this event."
  puts "ex: 2012-04-14 23:30"
  event_end = gets.chomp

  description = Event.create({ :description => event_description,
                              :location => event_location,
                              :start => event_start,
                              :end => event_end,
                              })
end

def add_task
  puts "Please add a task."
  event_description = gets.chomp

  puts "Please enter a location for this event."
  event_location = gets.chomp

  description = Event.create({ :description => event_description,
                              :location => event_location,
                              })
end


def display_events(events)
  puts "\e[36mCALENDAR\e[0;30m"
  puts "***************************************************************************"
  puts "\e[36mDecription               Location       Start              End \e[0;30m"
  puts "==========================================================================="

  events.each do |event|
    t=event.start
    h=event.end
    if event.start != nil
      puts "#{event.description}" + " "*(25-event.description.length) + "#{event.location}" + " "*(15-event.location.length) + "#{t.strftime('%m/%d/%Y %H:%M')}" + "   #{h.strftime('%m/%d/%Y %H:%M')}"
    end
  end
end

def display_tasks(events)
  puts "\e[36mTASKS\e[0;30m"
  puts "*******************************************"
  puts "\e[36mDecription               Location \e[0;30m"
  puts "==========================================="

  events.each do |event|
     # binding.pry
    if event.start == nil
      puts "#{event.description}" + " "*(25-event.description.length) + "#{event.location}" + " "*(15-event.location.length)
    end
  end
end
welcome




  # date_answer = gets.chomp
  # end_date = date_answer + 7.days
