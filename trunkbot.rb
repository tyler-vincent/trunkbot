#!/usr/bin/env ruby
# @file trunkbot.rb
#
# TrunkBot - IRC Bot 
# The do everything wonder bot!

# include required ruby gems and libraries
require "rubygems"
require "bundler/setup"
require "thread"

# include project configuration
conf_file = File.join( File.dirname( __FILE__ ), 'conf.rb' )
puts conf_file
require conf_file

# set working directory to project root
Dir.chdir $conf[:dir][:root]

puts "pwd> #{$conf[:dir][:root]}"

# include project libraries
require "./lib/logger.rb"
require "./lib/bot.rb"
require "./lib/interface.rb"
require "./lib/irc.rb"

# main application object
class TrunkBot

  def initialize 
    @bot = Bot.new( $conf[:irc][:nick] )
    @irc = IRC.new( @bot )
  end
  
  # Get things rolling
  def run
    
    # store the process id
    f = File.open( "tmp/pid", "w" )
    f.write( "#{Process.pid}\n" )
    f.close
    
    # hook up the irc interface
    host = $conf[:irc][:host]
    nick = $conf[:irc][:nick]
    pass = $conf[:irc][:pass]
    chan = $conf[:irc][:chan]
    @irc.connect host, nick, pass, chan
    
    begin
      irc_thread = Thread.new { 
        @irc.start
      }
      irc_thread.join
  
    rescue StandardError => e
      puts e.message
      puts e.backtrace.join("\n")
      retry
    
    end
  end
  
end

# Main
if __FILE__ == $0 then
  
  tbot = TrunkBot.new.run()
  
end

