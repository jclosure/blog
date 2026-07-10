---
layout: post
title: "A config-based approach to pluggable composition"
date: 2008-12-15 00:24:25 -0600
categories: []
tags: []
wordpress_id: 12
original_url: "https://joelholder.com/2008/12/15/a-config-based-approach-to-pluggable-composition/"
---
<div id="msgcns!3FC3980D58CF7EFB!247" class="bvMsg">
<div><font color="#0000ff" size="2"><font color="#0000ff" size="2"><br />
<font color="#000000">I wanted to share this sample to demonstrate a simple way to implement a configuration based approach to switching out pluggable dependencies.  The example here uses reflection to dynamically load an assembly and then instantiate the targeted class contained therein.  The idea with this approach is that you may have different implementations of an interface contained in different assemblies.  Thus,  you&#8217;re able to simply target the different implementations of the interface by switching an app config key that specifies a different assembly name.  Note the following:</font> </p>
<p><font color="#000000">1.  The path variable is the fully qualfied assembly name.</font> </p>
<p><font color="#000000">2.  The className variable is path with the name of the class that implements an expected interface appended to it.  In this case, we expect the assembly to contain an implementation of IOrder.</font> </p>
<p><font color="#000000"><a href="http://sharplife.net/2006/02/14/NETPetShop4Released.aspx" target="_blank"><u>From PetShop.NET 4.0 reference app source: </u></a></font></p>
<p>using</font></font><font size="2"><font color="#000000"> System;</font></font><font color="#0000ff" size="2"><font color="#0000ff" size="2"> </p>
<p>using</font></font><font size="2"><font color="#000000"> System.Reflection;</font></font><font color="#0000ff" size="2"><font color="#0000ff" size="2"> </p>
<p>using</p>
<p></font></font><font size="2"><font color="#000000">System.Configuration;</font></font><font color="#0000ff" size="2"><font color="#0000ff" size="2"> </p>
<p>namespace</p>
<p></font></font><font size="2"><font color="#000000">PetShop.MessagingFactory</font></font> </p>
<p><font size="2"><font color="#000000"> {</font> </p>
<p></font><font color="#808080" size="2"><font color="#808080" size="2">         ///</font></font><font color="#008000" size="2"><font color="#008000" size="2"> </font></font><font color="#808080" size="2"><font color="#808080" size="2"></p>
<summary></font></font><font size="2"> </p>
<p></font><font color="#808080" size="2"><font color="#808080" size="2">        ///</font></font><font color="#008000" size="2"><font color="#008000" size="2"> This class is implemented following the Abstract Factory pattern to create the Order</font></font><font size="2"> </p>
<p></font><font color="#808080" size="2"><font color="#808080" size="2">        ///</font></font><font color="#008000" size="2"><font color="#008000" size="2"> Messaging implementation specified from the configuration file</font></font><font size="2"> </p>
<p></font><font color="#808080" size="2"><font color="#808080" size="2">        ///</font></font><font color="#008000" size="2"><font color="#008000" size="2"> </font></font><font color="#808080" size="2"><font color="#808080" size="2"></summary>
<p></font></font><font size="2"> </p>
<p></font><font color="#0000ff" size="2"><font color="#0000ff" size="2">        public</font></font><font size="2"> </font><font color="#0000ff" size="2"><font color="#0000ff" size="2">sealed</font></font><font size="2"> </font><font color="#0000ff" size="2"><font color="#0000ff" size="2">class</font></font><font size="2"> </font><font color="#2b91af" size="2"><font color="#2b91af" size="2">QueueAccess</font></font><font size="2"> </font></p>
<p><font size="2">        { </p>
<p></font><font color="#008000" size="2"><font color="#008000" size="2">             // Look up the Messaging implementation we should be using</font></font><font size="2"> </p>
<p></font><font color="#0000ff" size="2"><font color="#0000ff" size="2">             private</font></font><font size="2"> </font><font color="#0000ff" size="2"><font color="#0000ff" size="2">static</font></font><font size="2"> </font><font color="#0000ff" size="2"><font color="#0000ff" size="2">readonly</font></font><font size="2"> </font><font color="#0000ff" size="2"><font color="#0000ff" size="2">string</font></font><font size="2"> path = </font><font color="#2b91af" size="2"><font color="#2b91af" size="2">ConfigurationManager</font></font><font size="2">.AppSettings[</font><font color="#a31515" size="2"><font color="#a31515" size="2">&#8220;OrderMessaging&#8221;</font></font><font size="2">]; </p>
<p></font><font color="#0000ff" size="2"><font color="#0000ff" size="2">             private</font></font><font size="2"> QueueAccess() { } </p>
<p></font><font color="#0000ff" size="2"><font color="#0000ff" size="2">             public</font></font><font size="2"> </font><font color="#0000ff" size="2"><font color="#0000ff" size="2">static</font></font><font size="2"> PetShop.IMessaging.</font><font color="#2b91af" size="2"><font color="#2b91af" size="2">IOrder</font></font><font size="2"> CreateOrder() { </p>
<p></font><font color="#0000ff" size="2"><font color="#0000ff" size="2">             string</font></font><font size="2"> className = path + </font><font color="#a31515" size="2"><font color="#a31515" size="2">&#8220;.Order&#8221;</font></font><font size="2">; </p>
<p></font><font color="#0000ff" size="2"><font color="#0000ff" size="2">             return</font></font><font size="2"> (PetShop.IMessaging.</font><font color="#2b91af" size="2"><font color="#2b91af" size="2">IOrder</font></font><font size="2">)</font><font color="#2b91af" size="2"><font color="#2b91af" size="2">Assembly</font></font><font size="2">.Load(path).CreateInstance(className); </p>
<p>          } </p>
<p>    } </p>
<p>}</p>
</p>
<p></font></p>
</p>
</div>
</div>
