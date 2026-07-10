---
layout: post
title: "Fat-Free Templating with Barebones Javascript"
date: 2010-03-17 23:11:03 -0600
categories: []
tags: []
wordpress_id: 6
original_url: "https://joelholder.com/2010/03/17/fat-free-templating-with-barebones-javascript/"
---
<div id="msgcns!3FC3980D58CF7EFB!523" class="bvMsg">
<p>Today I’m going to demonstrate a straight-forward and very effective technique for markup templating.<span>  </span>I’ve borrowed the supplant prototype function from <a href="http://developer.yahoo.com/yui/theater/video.php?v=crockonjs-2">Douglas Crockford’s &#8211; And Then There Was Javascript</a> presentation, in order to show you how to inject values from custom data structures directly into into strings.<span>  We’ll be doing a minimal implementation here in order to show the great outcomes you can get without requiring buy in to one of the many over engineered frameworks that do this.  </span></p>
<p><span>First we </span>extend the prototype of the built in String type.</p>
<p style="line-height:normal;margin:0 0 0 .5in;"><span style="font-family:'Courier New';font-size:10pt;">String.prototype.supplant = <span style="color:blue;">function</span>(o) {</span></p>
<p style="line-height:normal;margin:0 0 0 .5in;"><span style="font-family:'Courier New';font-size:10pt;"><span>    </span><span style="color:blue;">return</span> <span style="color:blue;">this</span>.replace(/{([^{}]*)}/g,</span></p>
<p style="line-height:normal;margin:0 0 0 .5in;"><span style="font-family:'Courier New';font-size:10pt;"><span>        </span><span style="color:blue;">function</span>(a, b) {</span></p>
<p style="line-height:normal;margin:0 0 0 .5in;"><span style="font-family:'Courier New';font-size:10pt;"><span>            </span><span style="color:blue;">var</span> r = o[b];</span></p>
<p style="line-height:normal;margin:0 0 0 .5in;"><span style="font-family:'Courier New';font-size:10pt;"><span>            </span><span style="color:blue;">return</span> <span style="color:blue;">typeof</span> r === <span style="color:#a31515;">&#8216;string&#8217;</span> || <span style="color:blue;">typeof</span> r === <span style="color:#a31515;">&#8216;number&#8217;</span> ? r : a;</span></p>
<p style="line-height:normal;margin:0 0 0 .5in;"><span style="font-family:'Courier New';font-size:10pt;"><span>        </span>}</span></p>
<p style="line-height:normal;margin:0 0 0 .5in;"><span style="font-family:'Courier New';font-size:10pt;"><span>    </span>);</span></p>
<p style="margin-left:.5in;"><span style="line-height:115%;font-family:'Courier New';font-size:10pt;">};</span></p>
<p>With this minimalist formatter in place we are able to do string manipulation like this:</p>
<p><span>            </span><span style="line-height:115%;font-family:'Courier New';color:blue;font-size:10pt;">var</span><span style="line-height:115%;font-family:'Courier New';font-size:10pt;"> result = <span style="color:#a31515;">&#8220;{a}-{b}-{c}&#8221;</span>.supplant({<span style="color:#a31515;">&#8220;a&#8221;</span>: <span style="color:#a31515;">&#8220;Foo&#8221;</span>,<span style="color:#a31515;"> &#8220;b&#8221;</span>: <span style="color:#a31515;">&#8220;Bar&#8221;</span>,<span style="color:#a31515;"> &#8220;c&#8221;</span>: <span style="color:#a31515;">&#8220;Baz&#8221;</span> });</span></p>
<p>The resulting string would be: <span style="line-height:115%;font-family:'Courier New';color:#a31515;font-size:10pt;">&#8220;Foo-Bar-Baz&#8221;</span>.<span>  </span>As you can see, we’ve essentially got a string formatting extension to all objects of type String here.<span>  </span>Where this becomes immediately useful to us in our web pages, is for injecting objects directly into markup strings, which can then be programmatically added to the DOM.<span>  </span>This technique is shown below in only <span> </span>4 lines (statements) of Javascript.</p>
<p style="line-height:normal;margin-bottom:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>    </span><span>  </span><span style="color:blue;"><</span><span style="color:#a31515;">div</span> <span style="color:red;">id</span><span style="color:blue;">=&#8221;container&#8221;</span> <span style="color:blue;">/></span></span></p>
<p style="line-height:normal;margin-bottom:0;"><span style="font-family:'Courier New';color:blue;font-size:10pt;"> </span></p>
<p style="line-height:normal;margin-bottom:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>    </span><span>  </span><span style="color:blue;"><</span><span style="color:#a31515;">script</span> <span style="color:red;">type</span><span style="color:blue;">=&#8221;text/javascript&#8221;></span></span></p>
<p style="line-height:normal;margin-bottom:0;"><span style="font-family:'Courier New';color:blue;font-size:10pt;"> </span></p>
<p style="line-height:normal;margin-bottom:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>        </span><span style="color:blue;">var</span> template = <span style="color:#a31515;">&#8216;</p>
<table border="{border}">&#8216;</span> +</span></p>
<p style="line-height:normal;margin-bottom:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>                        </span><span style="color:#a31515;">&#8216;</p>
<tr>
<th>Last</th>
<td>{last}</td>
</tr>
<p>&#8216;</span> +</span></p>
<p style="line-height:normal;margin-bottom:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>                        </span><span style="color:#a31515;">&#8216;</p>
<tr>
<th>First</th>
<td>{first}</td>
</tr>
<p>&#8216;</span> +</span></p>
<p style="line-height:normal;margin-bottom:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>                       </span><span style="color:#a31515;">&#8216;</table>
<p>&#8216;</span>;</span></p>
<p style="line-height:normal;margin-bottom:0;"><span style="font-family:'Courier New';font-size:10pt;"> </span></p>
<p style="line-height:normal;margin-bottom:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>        </span><span style="color:blue;">var</span> data = {</span></p>
<p style="line-height:normal;margin-bottom:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>            </span><span style="color:#a31515;">&#8220;first&#8221;</span>: <span style="color:#a31515;">&#8220;Carl&#8221;</span>,</span></p>
<p style="line-height:normal;margin-bottom:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>            </span><span style="color:#a31515;">&#8220;last&#8221;</span>: <span style="color:#a31515;">&#8220;Hollywood&#8221;</span>,</span></p>
<p style="line-height:normal;margin-bottom:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>            </span><span style="color:#a31515;">&#8220;border&#8221;</span>: 2</span></p>
<p style="line-height:normal;margin-bottom:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>        </span>};</span></p>
<p style="line-height:normal;margin-bottom:0;"><span style="font-family:'Courier New';font-size:10pt;"> </span></p>
<p style="line-height:normal;margin-bottom:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>        </span><span style="color:blue;">var</span> container = document.getElementById(<span style="color:#a31515;">&#8220;container&#8221;</span>);</span></p>
<p style="line-height:normal;margin-bottom:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>        </span>container.innerHTML = template.supplant(data);</span></p>
<p style="line-height:normal;margin-bottom:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>    </span></span></p>
<p style="line-height:normal;margin-bottom:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>    </span><span>  </span><span style="color:blue;"></</span><span style="color:#a31515;">script</span><span style="color:blue;">></span></span></p>
<p> </p>
<p>As you can see, we start with a template String and a JSON data Object.<span>  </span>Then we get our target DOM node and simply set its <b>.innerHTML </b>property to the output of the template running its own <b>.supplant()</b> function against the data object.<span>  </span>Very sparse, no heavy framework..<span>  </span>Its just the bare bones Javascript and a helper function.<span>  </span>Here’s an example of using this technique to set the .src property of an <b><img></b> DOM node. </p>
<p>Assuming I have an image file that I want to be targetable based on some script logic, it looks like this.</p>
<p><a href="/blog/assets/wp/fat-free-templating-with-barebones-javascript/691c5d943ed0031de58500cd5504f44c.png" rel="WLPP"><img data-recalc-dims="1" decoding="async" border="0" src="/blog/assets/wp/fat-free-templating-with-barebones-javascript/691c5d943ed0031de58500cd5504f44c.png" /></a> </p>
<p>The code that I need to target this file at runtime looks like this:</p>
<p><span>        </span><span> </span><span>   </span><span style="line-height:115%;font-family:'Courier New';color:blue;font-size:10pt;"><</span><span style="line-height:115%;font-family:'Courier New';color:#a31515;font-size:10pt;">img</span><span style="line-height:115%;font-family:'Courier New';font-size:10pt;"> <span style="color:red;">id</span><span style="color:blue;">=&#8221;logo&#8221;</span> <span style="color:red;">src</span><span style="color:blue;">=&#8221;&#8221;</span> <span style="color:blue;">/></span></span></p>
<p style="line-height:normal;margin-bottom:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>  </span><span>  </span><span>  </span><span style="color:blue;"><</span><span style="color:#a31515;">script</span> <span style="color:red;">type</span><span style="color:blue;">=&#8221;text/javascript&#8221;></span></span></p>
<p style="line-height:normal;margin-bottom:0;"><span style="font-family:'Courier New';font-size:10pt;"> </span></p>
<p style="line-height:normal;margin-bottom:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>   </span><span>  </span><span>     </span><span style="color:blue;">var</span> param = { domain: <span style="color:#a31515;">&#8216;memecannon.com&#8217;</span>, media: <span style="color:#a31515;">&#8216;/Content/ninja&#8217;</span> };</span></p>
<p style="line-height:normal;margin-bottom:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>  </span><span>  </span><span>      </span><span style="color:blue;">var</span> url = <span style="color:#a31515;">&#8220;{media}.jpg&#8221;</span>.supplant(param);</span></p>
<p style="line-height:normal;margin-bottom:0;"><span style="font-family:'Courier New';font-size:10pt;"> </span></p>
<p style="line-height:normal;margin-bottom:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>  </span><span>  </span><span>      </span><span style="color:blue;">var</span> logo = document.getElementById(<span style="color:#a31515;">&#8220;logo&#8221;</span>);</span></p>
<p style="line-height:normal;margin-bottom:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>  </span><span>  </span><span>      </span>logo.setAttribute(<span style="color:#a31515;">&#8220;src&#8221;</span>, url);</span></p>
<p style="line-height:normal;margin-bottom:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>    </span></span></p>
<p style="line-height:normal;margin-bottom:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>    </span><span style="color:blue;"></</span><span style="color:#a31515;">script</span><span style="color:blue;">></span></span></p>
<p> </p>
<p>The output looks like this:</p>
<p><span><a href="/blog/assets/wp/fat-free-templating-with-barebones-javascript/71d9ae617d4ba755d8b6bab619f77e12.jpg" rel="WLPP"><img data-recalc-dims="1" decoding="async" border="0" src="/blog/assets/wp/fat-free-templating-with-barebones-javascript/71d9ae617d4ba755d8b6bab619f77e12.jpg" /></a></span></p>
<p>Using this approach, its quite easy to do targeting of custom skin artifacts and layout structures.<span>  </span>Other uses of this approach are to programmatically inject variables into CSS strings and runtime script includes.<span>  </span>As you can see, the basics for screen templating are exposed near the surface of DOM scripting with Javascript.<span>  </span>That said, I do typically use <a href="http://jquery.com/">JQuery</a> plugins for this type of screen composition.<span>  </span>I’ve surveyed most of the JQuery plugins in this space.<span>  </span>I recommend <a href="http://jsrepeater.devprog.com/google.search.websearch.example.html">JSRepeater</a> for ease of use and support for automatic iterating over collections and dealing with heirarchal data structures.  For an extremely unobtrusive templating solution, you can’t beat <a href="http://plugins.jquery.com/project/noTemplate">NoTemplate</a>.  It provides a level of externalized purity, in that you don’t need to hack replacement ${targets} into your markup at all; rather, it uses selectors to reach down into your markup for mapping data to screen targets.  </p>
<p>Hopefully, in this article I’ve informed, if not convinced you that you have the power to blend your data and markup in whatever ways you need purely with Javascript and with a minimum of effort.  In a successive post,  I’ll show you how to interact this approach with Ajax Services to bring your screens to life.</p>
<p>Enjoy..</p>
</p></div>
