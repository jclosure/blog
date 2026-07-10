---
layout: post
title: "Sleek CLI wrappers around Ruby libs"
date: 2012-02-09 02:02:26 -0600
categories: []
tags: ["Ruby", "splat", "wrapper script"]
wordpress_id: 187
original_url: "https://joelholder.com/2012/02/09/sleek-cli-wrappers-around-ruby-libs/"
---
<p>When using Ruby&#8217;s splat operator for method invocation, eg. my_method(*my_array), it takes the array and blows it out into the parameters required to fill the method&#8217;s signature.  This makes it super easy to call methods from classes via the command line, by simply passing the arguments (ARGV) to a Ruby command line app and then directly down into a Ruby class API.  The key to my approach is to do this in a very DRY way with as little code as possible.  Here&#8217;s how I do it.</p>
<p>First we&#8217;ll create a file called seeker.rb with a class a API that looks like this:</p>

~~~ ruby
class Seeker
  def work_file(infile, outfile, suffix, delimeter)
    p "parameter 1: infile = #{infile}"
    p "parameter 2: outfile = #{outfile}"
    p "parameter 3: suffix = #{suffix}"
    p "parameter 4: delimeter = #{delimeter}"
    #do important stuff, etc..
  end
end
~~~

<p>Now, we can create a generic wrapper script to drive it like this by doing the following. Create a file called just seeker.  Make sure to chmod +x seeker.  Add the following text:</p>

~~~ ruby
#!/usr/bin/env ruby

require File.expand_path('seeker.rb', __FILE__)
Seeker.new.send(ARGV.shift.to_sym, *ARGV)
~~~

<p>With this generic message passing script in place, we can call the API like this:</p>
<p><code>$./seeker work_file foo.txt bar.txt .com ,</code></p>
<p>Running this command, we get the following output:</p>
<p><code>parameter 1: infile = foo.txt<br />
parameter 2: outfile = bar.txt<br />
parameter 3: suffix = .com<br />
parameter 4: delimeter = ,</code></p>
<p>The ease with which we&#8217;re able to pass input from the cli straight into our class API comes from the splat operator&#8217;s ability to turn an ordered set of cli args into Ruby method params.  Notice that we chewed off ARGV[0] as the name of the method we wanted to run.  Using the builtin &#8220;send&#8221; method, which sends a generic message to an instance of a Ruby class, we can invoke any method by simply specifying it as the first cli arg followed by the parameters to be passed into the method, which are just the subsequent cli args.</p>
<p>With a general purpose wrapper like this we can invoke any method on any target class with no additional code.  This is a testament to the sheer goodness of Ruby.</p>
