Description
===========
A super simple way to share any directory with Apache 2. It adds a virtual
host mapping the directory to a specified port. Using ports instead of
hostnames has the advantage, that the resource is available over the network
without any configuration on the other end.

Install
=======
Install the Rio gem
	sudo gem install rio

Put `porthost.rb` in your PATH. No further configuration should be necessary on
a Mac with the pre-installed Apache 2. If you're using Linux you might need
to change the CONF_FILE variable on the top of the script and include that file.

Example
=======

	cd ~/Code/myProject
	sudo porthost.rb add 8081
	# open http://localhost:8081

License
=======
Copyright (c) 2009 Jan Kassens (jankassensATgmailDOTcom)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.