---
layout: post
title: "Metaprogramming in Ruby and C#"
date: 2011-02-16 02:47:59 -0600
categories: []
tags: []
wordpress_id: 46
original_url: "https://joelholder.com/2011/02/16/metaprogramming-in-ruby-and-c/"
---
<p>First read this and understand metaprogramming in Ruby: <a title="An Exercise in Metaprogramming with Ruby" href="http://www.devsource.com/c/a/Languages/An-Exercise-in-Metaprogramming-with-Ruby/">http://www.devsource.com/c/a/Languages/An-Exercise-in-Metaprogramming-with-Ruby/</a></p>
<p>It seems that C# dynamic supports a similar scenario, but in a different way. C# dynamic objects are in fact not new Types created at runtime, but rather individual compiler-safe bags of key/value pairs that self expose the keys as properties. Thus C# dynamic objects are only available as defined at the instance level and those instances are of type DynamicObject.</p>
<p>The technique I demonstrate in this post: <a href="http://joelholder.com/2009/12/21/property-copying-with-dynamic-objects-in-net-4-0/">http://joelholder.com/2009/12/21/property-copying-with-dynamic-objects-in-net-4-0/</a> could be modified to take its key/value pair input from a csv to achieve the same result.</p>
