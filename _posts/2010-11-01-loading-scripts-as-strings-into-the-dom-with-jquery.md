---
layout: post
title: "Loading Scripts As Strings into the DOM with JQuery"
date: 2010-11-01 19:49:24 -0600
categories: []
tags: []
wordpress_id: 43
original_url: "https://joelholder.com/2010/11/01/loading-scripts-as-strings-into-the-dom-with-jquery/"
---
<p>Here’s why JavaScript is teh awsome:</p>
<p>var ns = {};<br />
$(document).ready(function () {<br />
$(&#8216;&lt;scrip&#8217;+&#8217;t>ns.blah=function(){alert(&#8220;hi&#8221;);};&lt;/scr&#8217;+&#8217;ipt>&#8217;)<br />
.appendTo(&#8216;body&#8217;);<br />
ns.blah();<br />
});</p>
<p>With this I get:</p>
<p><a href="/assets/wp/loading-scripts-as-strings-into-the-dom-with-jquery/image.png"><img data-recalc-dims="1" loading="lazy" decoding="async" style="display:inline;border:0;" title="image" src="/assets/wp/loading-scripts-as-strings-into-the-dom-with-jquery/image_thumb.png" border="0" alt="image" width="338" height="118" /></a></p>
<p>Here play with it yourself.</p>
<p><a href="http://www.jsfiddle.net/nVuNZ/">http://www.jsfiddle.net/nVuNZ/</a></p>
<p>Consider the deployment and update scenarios enabled using this technique with a modular application pattern.</p>
