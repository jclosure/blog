---
layout: post
title: "Ruby AOP in 12 lines of Code"
date: 2011-03-14 21:13:59 -0600
categories: []
tags: []
wordpress_id: 99
original_url: "https://joelholder.com/2011/03/14/ruby-aop-in-12-lines-of-code/"
---
<style>
.entry-content pre,
.entry-content code {
  white-space: pre-wrap;
  overflow-wrap: anywhere;
  word-break: break-word;
}
.entry-content table,
.entry-content img,
.entry-content iframe {
  max-width: 100%;
}
.entry-content {
  overflow-wrap: anywhere;
}
</style>


First, we shim the Ruby Object class with a profiling aspect, in this case an additional method called profile that will wrap any existing method with timing code that we tell it to.

Lets put this in a file called: <strong>aop_extension.rb</strong>.
<pre><strong><span style="text-decoration:underline;"><span style="font-family:'Courier New';color:#a4357a;font-size:10pt;">c</span></span></strong><strong><span style="font-family:'Courier New';color:#a4357a;font-size:10pt;">lass</span></strong><span style="font-family:'Courier New';color:black;font-size:10pt;"> <span style="background:silver;">Object</span></span>

<strong><span style="font-family:'Courier New';color:#a4357a;font-size:10pt;">  def</span></strong><span style="font-family:'Courier New';color:black;font-size:10pt;"> <span style="background:silver;">Object</span>.profile symbol</span>

<span style="font-family:'Courier New';color:black;font-size:10pt;">    _symbol = (</span><span style="font-family:'Courier New';color:#2a00ff;font-size:10pt;">"rprof_"</span><span style="font-family:'Courier New';color:black;font-size:10pt;"> + symbol.to_s).to_sym</span>

<span style="font-family:'Courier New';color:black;font-size:10pt;">    alias_method _symbol, symbol</span>

<span style="font-family:'Courier New';font-size:10pt;">    <span style="color:#3f7f5f;"># Define the new wrapper method </span></span>

<strong><span style="font-family:'Courier New';color:#a4357a;font-size:10pt;">    self</span></strong><span style="font-family:'Courier New';color:black;font-size:10pt;">.send(</span><strong><span style="font-family:'Courier New';color:#ff4040;font-size:10pt;">:define_method</span></strong><span style="font-family:'Courier New';color:black;font-size:10pt;">, symbol.to_s) { |*args|</span>

<span style="font-family:'Courier New';color:black;font-size:10pt;">      start_time = Time.now</span>

<strong><span style="font-family:'Courier New';color:#a4357a;font-size:10pt;">      self</span></strong><span style="font-family:'Courier New';color:black;font-size:10pt;">.send(_symbol, *args)</span>

<span style="font-family:'Courier New';color:black;font-size:10pt;">      puts (Time.now - start_time).to_s +</span><span style="font-family:'Courier New';color:#2a00ff;font-size:10pt;"> " have elapsed"</span>

<span style="font-family:'Courier New';color:black;font-size:10pt;">    }</span>

<span style="font-family:'Courier New';color:black;font-size:10pt;">    puts</span><span style="font-family:'Courier New';color:#2a00ff;font-size:10pt;"> "The new method "</span><span style="font-family:'Courier New';color:black;font-size:10pt;"> + _symbol.to_s +</span><span style="font-family:'Courier New';color:#2a00ff;font-size:10pt;"> " has been created for method "</span><span style="font-family:'Courier New';color:black;font-size:10pt;"> + symbol.to_s</span>

<strong><span style="font-family:'Courier New';color:#a4357a;font-size:10pt;">  end</span></strong>

<strong><span style="font-family:'Courier New';color:#a4357a;font-size:10pt;">en</span></strong><span style="font-family:'Courier New';color:black;font-size:10pt;">d</span></pre>
Now lets define a class that we can use as a test subject.  Create a file called <strong>greeter.rb</strong>.  Add the following:
<pre> 

<span style="font-family:'Courier New';background:silver;color:black;font-size:10pt;">require</span><span style="font-family:'Courier New';color:#2a00ff;font-size:10pt;"> "./aop_extension.rb"</span>

<span style="font-family:'Courier New';font-size:10pt;"> </span>

<strong><span style="font-family:'Courier New';color:#a4357a;font-size:10pt;">class</span></strong><span style="font-family:'Courier New';color:black;font-size:10pt;"> Greeter</span>

<strong><span style="font-family:'Courier New';color:#a4357a;font-size:10pt;">   def</span></strong><span style="font-family:'Courier New';color:black;font-size:10pt;"> hello</span>

<span style="font-family:'Courier New';color:black;font-size:10pt;">    puts</span><span style="font-family:'Courier New';color:#2a00ff;font-size:10pt;"> "hello"</span>

<strong><span style="font-family:'Courier New';color:#a4357a;font-size:10pt;">  end</span></strong>

<span style="font-family:'Courier New';color:black;font-size:10pt;">  profile</span><strong><span style="font-family:'Courier New';color:#ff4040;font-size:10pt;"> :hello</span></strong>

<strong><span style="line-height:115%;font-family:'Courier New';color:#a4357a;font-size:10pt;">en</span></strong><span style="line-height:115%;font-family:'Courier New';color:black;font-size:10pt;">d</span></pre>
Notice that in the constructor code we tell the inherited profile method to go after the “hello” method.  This creates a proxy method that will run the targeted method on behalf of callers.

Now lets see this thing in action.  For this we’ll create a file called <strong>main.rb</strong>.  Add the following:
<pre><span style="font-family:'Courier New';background:silver;color:black;font-size:10pt;">require</span><span style="font-family:'Courier New';color:#2a00ff;font-size:10pt;"> "./greeter.rb"</span>

<span style="font-family:'Courier New';font-size:10pt;"> </span>

<span style="font-family:'Courier New';color:black;font-size:10pt;">t = Greeter.new</span>

<span style="line-height:115%;font-family:'Courier New';color:black;font-size:10pt;">t.hello</span></pre>
Finally, after all this extra heavy lifting we can see the goodness shining through in the output:

<strong><span style="color:#0000ff;">$ ruby main.rb</span>
The new method rprof_hello has been created for method hello
hello
0.001 have elapsed</strong>

Wow, we didn’t even break a sweat on that one.
