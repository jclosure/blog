---
layout: post
title: "Ruby AOP in 12 lines of Code"
date: 2011-03-14 21:13:59 -0600
categories: []
tags: []
wordpress_id: 99
original_url: "https://joelholder.com/2011/03/14/ruby-aop-in-12-lines-of-code/"
---

First, we shim the Ruby Object class with a profiling aspect, in this case an additional method called profile that will wrap any existing method with timing code that we tell it to.

Lets put this in a file called: <strong>aop_extension.rb</strong>.

~~~ ruby
class Object

  def Object.profile symbol

    _symbol = ("rprof_" + symbol.to_s).to_sym

    alias_method _symbol, symbol

    # Define the new wrapper method

    self.send(:define_method, symbol.to_s) { |*args|

      start_time = Time.now

      self.send(_symbol, *args)

      puts (Time.now - start_time).to_s + " have elapsed"

    }

    puts "The new method " + _symbol.to_s + " has been created for method " + symbol.to_s

  end

end
~~~

Now lets define a class that we can use as a test subject.  Create a file called <strong>greeter.rb</strong>.  Add the following:

~~~ ruby


require "./aop_extension.rb"



class Greeter

   def hello

    puts "hello"

  end

  profile :hello

end
~~~

Notice that in the constructor code we tell the inherited profile method to go after the “hello” method.  This creates a proxy method that will run the targeted method on behalf of callers.

Now lets see this thing in action.  For this we’ll create a file called <strong>main.rb</strong>.  Add the following:

~~~ ruby
require "./greeter.rb"



t = Greeter.new

t.hello
~~~

Finally, after all this extra heavy lifting we can see the goodness shining through in the output:

<strong><span style="color:#0000ff;">$ ruby main.rb</span>
The new method rprof_hello has been created for method hello
hello
0.001 have elapsed</strong>

Wow, we didn’t even break a sweat on that one.
