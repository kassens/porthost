#!/usr/bin/env ruby

# Copyright (c) 2009 Jan Kassens (jankassensATgmailDOTcom)
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

# This file will automatically loaded on a Mac.
CONF_FILE = '/etc/apache2/other/porthost.conf';

require 'rubygems'
require 'rio'

class Hosts
  def initialize(conf_file)
    @conf_file = rio(conf_file)
    load
  end

  def list
    @mappings.each_pair do |port, path|
      puts "#{port} => #{path}"
    end
  end

  def add(port, path)
    fatal("Path '#{path}' does not exist or is not a folder") unless rio(path).exist? && rio(path).directory?
    @mappings[port] = path;
    save
  end

  def remove(port)
    fatal("Port #{port} is not mapped.") unless @mappings.delete(port)
    save
  end

  private

  def load
    if @conf_file.exist? then
      fatal("conf file '#{@conf_file}' not readable") unless @conf_file.readable_real?
      @mappings = YAML::load(@conf_file.line[0][1..-1].gsub('\n', "\n"))
    else
      @mappings = {}
    end
  end

  def save
    if @conf_file.exist? && !@conf_file.writable_real? or !@conf_file.dirname.writable_real? then
      fatal("conf file '#{@conf_file}' not writable")
    end
    @conf_file < ('#' + YAML.dump(@mappings).gsub!("\n", '\n'))
    @conf_file << "\n"
    @conf_file << '# Auto generated file. Do not modify.'
    @mappings.each_pair do |port, path|
      @conf_file << <<-EOS
Listen #{port}
<VirtualHost *:#{port}>
  DocumentRoot #{path}
  <Directory "#{path}">
    AllowOverride All
    Order allow,deny
    Allow from all
  </Directory>
</VirtualHost>
EOS
    end
    restart_apache
  end

  def restart_apache
    system('apachectl -k graceful')
  end

  def fatal(error)
    puts "Fatal error:\n#{error}"
    exit 1
  end

end

hosts = Hosts.new(CONF_FILE)

def usage
  puts "usage:"
  puts "porthost.rb list"
  puts "   Lists all mappings."
  puts "porthost.rb add <port>"
  puts "   Maps port <port> to the current working directory."
  puts "porthost.rb add <port> <dir>"
  puts "   Maps port <port> to directory <dir>."
  puts "porthost.rb remove <port>"
  puts "   Removes mapping to port <port>"
  exit 1
end

case ARGV[0]
when 'list'
  usage unless ARGV.length == 1
  hosts.list 
when 'add'
  usage unless ARGV.length == 2 || ARGV.length == 3
  hosts.add(ARGV[1], ARGV[2] || Dir.pwd)
when 'remove'
  usage unless ARGV.length == 2
  hosts.remove(ARGV[1])
else
  usage
end
