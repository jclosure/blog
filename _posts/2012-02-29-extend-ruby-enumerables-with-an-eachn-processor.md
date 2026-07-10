---
layout: post
title: "Extend Ruby Enumerables With An EachN Processor"
date: 2012-02-29 22:33:20 -0600
categories: []
tags: ["Ruby"]
wordpress_id: 204
original_url: "https://joelholder.com/2012/02/29/extend-ruby-enumerables-with-an-eachn-processor/"
---
<p>Here&#8217;s a useful enhancement to arrays that allows you to process elements in a block n at a time. N is inferred by the arity of your block signature.</p>
<pre class="brush: ruby; title: ; notranslate" title="">
require &#039;enumerator&#039;

module Enumerable
  def eachn(&amp;block)
    n = block.arity
    each_slice(n) {|i| block.call(*i)}
  end
end

a = (1..10).to_a
a.eachn {|x,y,z| p &#x5B;x,y,z]}

</pre>
<p>Namaste&#8230;</p>
