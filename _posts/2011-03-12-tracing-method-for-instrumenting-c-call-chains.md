---
layout: post
title: "Runtime Stack Introspection with C#"
date: 2011-03-12 22:26:10 -0600
categories: []
tags: []
wordpress_id: 68
original_url: "https://joelholder.com/2011/03/12/tracing-method-for-instrumenting-c-call-chains/"
---
<p><code><span style="font-family:consolas;color:blue;font-size:10pt;">        public static</span><span style="font-family:consolas;font-size:10pt;"> <span style="color:blue;">string</span> WhoCalledMe()<br />        {<br />              <span style="color:blue;">var</span> st = <span style="color:blue;">new</span> <span style="color:#2b91af;">StackTrace</span>();<br />              <span style="color:blue;">var</span> sf = st.GetFrame(1);<br />              <span style="color:blue;">var</span> mb = sf.GetMethod();<br />              <span style="color:blue;">return</span> mb.Name;<br />        }</span></code></p>
