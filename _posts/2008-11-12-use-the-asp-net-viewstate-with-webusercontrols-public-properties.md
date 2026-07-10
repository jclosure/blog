---
layout: post
title: "Use the ASP.NET ViewState with WebUserControls’ public Properties"
date: 2008-11-12 00:38:41 -0600
categories: []
tags: []
wordpress_id: 24
original_url: "https://joelholder.com/2008/11/12/use-the-asp-net-viewstate-with-webusercontrols-public-properties/"
---
<div id="msgcns!3FC3980D58CF7EFB!227" class="bvMsg">
<div><font face="Times New Roman" color="#000000" size="1"> </font></div>
<div>This technique works with WebForms, but becomes much more useful when you site WebUserControls on a WebForm and need to set/get values between the parent Form and a child UserControl.</div>
<div> </div>
<div>Put something like this in your WebUserCotrol1.</div>
<div> </div>
<div><span style="font-size:9pt;color:blue;font-family:'Courier New';">public</span><span style="font-size:9pt;color:black;font-family:'Courier New';"> </span><span style="font-size:9pt;color:blue;font-family:'Courier New';">int</span><span style="font-size:9pt;color:black;font-family:'Courier New';"> Total {</span></div>
<p style="background:white;"><span style="font-size:9pt;color:black;font-family:'Courier New';"><span>        </span></span><span style="font-size:9pt;color:blue;font-family:'Courier New';">get</span><span style="font-size:9pt;color:black;font-family:'Courier New';"> { </span><span style="font-size:9pt;color:blue;font-family:'Courier New';">return</span><span style="font-size:9pt;color:black;font-family:'Courier New';"> ViewState[</span><span style="font-size:9pt;color:maroon;font-family:'Courier New';">&#8220;intTotal&#8221;</span><span style="font-size:9pt;color:black;font-family:'Courier New';">] != </span><span style="font-size:9pt;color:blue;font-family:'Courier New';">null</span><span style="font-size:9pt;color:black;font-family:'Courier New';"> ? </span><span style="font-size:9pt;color:teal;font-family:'Courier New';">Int32</span><span style="font-size:9pt;color:black;font-family:'Courier New';">.Parse(ViewState[</span><span style="font-size:9pt;color:maroon;font-family:'Courier New';">&#8220;intTotal&#8221;</span><span style="font-size:9pt;color:black;font-family:'Courier New';">].ToString()) : 0; }</span></p>
<p style="background:white;"><span style="font-size:9pt;color:black;font-family:'Courier New';"><span>        </span></span><span style="font-size:9pt;color:blue;font-family:'Courier New';">set</span><span style="font-size:9pt;color:black;font-family:'Courier New';"> { ViewState[</span><span style="font-size:9pt;color:maroon;font-family:'Courier New';">&#8220;intTotal&#8221;</span><span style="font-size:9pt;color:black;font-family:'Courier New';">] = </span><span style="font-size:9pt;color:blue;font-family:'Courier New';">value</span><span style="font-size:9pt;color:black;font-family:'Courier New';">; }</span></p>
<p style="background:white;"><span style="font-size:9pt;color:black;font-family:'Courier New';"><span></span>}</span></p>
<p style="background:white;"><span style="font-size:9pt;color:black;font-family:'Courier New';">Site the UserControl on WebForm1.</span></p>
<p style="background:white;"><span style="font-size:9pt;color:black;font-family:'Courier New';">Then you can access the Property in the UserControl from WebForm1&#8217;s code behind like this. </span></p>
<p style="background:white;"><span style="font-size:9pt;color:black;font-family:'Courier New';"><font color="#0000ff"><span style="font-size:9pt;color:blue;font-family:'Courier New';">int</span><span style="font-size:9pt;color:black;font-family:'Courier New';"> newTotal =</span> this</font><font color="#000000">.WebUserControl1.Total;</font></span></p>
<p style="background:white;"><span style="font-size:9pt;color:black;font-family:'Courier New';">Simple..  ViewState will hold the value between postbacks..</span></div>
