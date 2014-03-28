require 'bundler/setup'
Bundler.require(:default)
require 'pry'
require './lib/event.rb'
require './lib/task.rb'
require './lib/note.rb'


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
    puts "Press 'n' to add a note"
    puts "Press 'l' to list future events."
    puts "Press 't' to list today's events."
    puts "Press 'w' to list events for the next week."
    puts "Press 'm' to list events for the next month."
    puts "Press 'pw' to list events from the past week."
    puts "Press 'pm' to list events from the past month."
    puts "Press 'tk' to list tasks"
    puts "Press 'tn' to list task notes"
    puts "Press 'x' to exit"
    user_input = gets.chomp
    system "clear"

    case user_input
    when 'e'
      add_event
    when 'ak'
      add_task
    when 'n'
      add_note
    when 'l'
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
      events = Task.all
      display_tasks(events)
    when 'tn'
      list_task_notes
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

  description = Task.create({ :description => event_description,
                              :location => event_location,
                              })
end

def add_note
  puts "Please enter your note"
  new_note = gets.chomp
  puts "Press 'e' to add your note to a calendar entry"
  puts "Press 't' to add your note to a task"
  user_choice = gets.chomp
  if user_choice == 'e'
    notable_type = 'event'
    events = Event.all.order(:start)
    display_events(events)
    puts 'Enter an item to add a note'
    item_choice = gets.chomp
    item = Event.where(:description => item_choice).first
  elsif user_choice == 't'
    notable_type = 'task'
    events = Task.all
    display_tasks(events)
    puts 'Enter an item to add a note'
    item_choice = gets.chomp
    item = Task.where(:description => item_choice).first
        # binding.pry
  end
  note = Note.create(:description => new_note, :notable_id => item.id, :notable_type => notable_type)
end

def list_task_notes
  notes = Note.where(:notable_type => 'task')
  notes.each { |note| puts note.description}
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
      puts "#{event.description}" + " "*(25-event.description.length) + "#{event.location}" + " "*(15-event.location.length)
  end
end
welcome
