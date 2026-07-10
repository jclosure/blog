---
layout: post
title: "Giving Your Data Some Higher Order Muscle With C#"
date: 2011-04-05 22:12:00 -0500
categories: []
tags: []
wordpress_id: 110
original_url: "https://joelholder.com/2011/04/05/giving-your-data-some-functional-smarts-with-c/"
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


Today a colleague and I were going through some code.  I have recently been trying to impart to him the power and beauty in the functional programing paradigm in C#.  Today, the opportunity to demonstrate it presented itself as I was showing him how to use extension methods to extend Entities and ValueObjects with a suite-to-purpose functional API.  As we began the code, I realized that what I really wanted to show him was the concept with no additional fluff.  First, the extension method part.

Here’s what I came up with:
<pre><span style="font-family:Consolas;"><span style="color:#0000ff;">public</span><span style="color:#000000;"> </span><span style="color:#0000ff;">static</span><span style="color:#000000;"> </span><span style="color:#0000ff;">class</span><span style="color:#000000;"> </span><span style="color:#2b91af;">IntExtensions</span></span>
<span style="font-family:Consolas;"><span style="color:#000000;">{</span></span>
<span style="font-family:Consolas;"><span style="color:#000000;">    </span><span style="color:#0000ff;">public</span><span style="color:#000000;"> </span><span style="color:#0000ff;">static</span><span style="color:#000000;"> </span><span style="color:#0000ff;">void</span><span style="color:#000000;"> Times(</span><span style="color:#0000ff;">this</span><span style="color:#000000;"> </span><span style="color:#0000ff;">int</span><span style="color:#000000;"> count, </span><span style="color:#2b91af;">Action</span><span style="color:#000000;"><</span><span style="color:#0000ff;">int</span><span style="color:#000000;">> action)</span></span>
<span style="font-family:Consolas;"><span style="color:#000000;">    {</span></span>
<span style="font-family:Consolas;"><span style="color:#000000;">        </span><span style="color:#0000ff;">for</span><span style="color:#000000;"> (</span><span style="color:#0000ff;">var</span><span style="color:#000000;"> i = 0; i < count; i++)</span></span>
<span style="font-family:Consolas;"><span style="color:#000000;">        {</span></span>
<span style="font-family:Consolas;"><span style="color:#000000;">            action(i);</span></span>
<span style="font-family:Consolas;"><span style="color:#000000;">        }</span></span>
<span style="font-family:Consolas;"><span style="color:#000000;">    }</span></span>
<span style="font-family:Consolas;"><span style="color:#000000;">}</span></span></pre>
<div style="height:60px;padding-top:35px;">
<p class="MsoNormal" style="line-height:normal;margin:0;">This small extension to the builtin int type, gives us a convenient and expressive functional API, driven directly from Int32 typed variables themselves.  Now, we can use it as follows.</p>

</div>
<pre><span style="font-family:Consolas;"><span style="color:#000000;">[</span><span style="color:#2b91af;">TestMethod</span><span style="color:#000000;">]</span></span>
<span style="font-family:Consolas;"><span style="color:#0000ff;">public</span><span style="color:#000000;"> </span><span style="color:#0000ff;">void</span><span style="color:#000000;"> SampleRepository_Can_Create_New()</span></span>
<span style="font-family:Consolas;"><span style="color:#000000;">{</span></span>
<span style="font-family:Consolas;"><span style="color:#000000;">     10.Times(i =></span></span>
<span style="font-family:Consolas;"><span style="color:#000000;">     {</span></span>
<span style="font-family:Consolas;"><span style="color:#0000ff;">          var</span><span style="color:#000000;"> sample = </span><span style="color:#2b91af;">TestObjects</span><span style="color:#000000;">.BuildSample();</span></span>
<span style="font-family:Consolas;"><span style="color:#000000;">          SampleRepository.Save(sample);</span></span>
<span style="font-family:Consolas;"><span style="color:#000000;">     });</span></span>

<span style="font-family:Consolas;"><span style="color:#0000ff;">     var</span><span style="color:#000000;"> samples = SampleRepository.GetAll();</span></span>
<span style="font-family:Consolas;"><span style="color:#000000;"><span style="line-height:11pt;text-indent:0;">     </span></span></span>
<span style="font-family:Consolas;"><span style="color:#000000;"><span style="line-height:11pt;text-indent:0;">     samples.Count().Times(i => <span style="color:#2b91af;">Debug</span>.WriteLine(<span style="color:#a31515;">"your index is "</span> + i));</span></span></span>

<span style="font-family:Consolas;"><span style="color:#2b91af;">     Assert</span><span style="color:#000000;">.IsTrue(samples.Count() == 10, </span><span style="color:#a31515;">"Should have 10 samples"</span><span style="color:#000000;">);</span></span>
<span style="line-height:11pt;"><span style="font-family:Consolas;"><span style="color:#000000;">}</span></span></span></pre>
Rubyists recognize this API as its built into the language.  Its simple stepwise iteration driven directly off numeric types.  In C# we can use extension methods to shim this behavior into our scalers.  APIs that read like <strong>5.Times(doSomething); </strong>read like English.  This makes our code  more comprehensible by everyone, and that ladies and gentlemen is worth its weight in <a href="http://en.wikipedia.org/wiki/Fictional_currency">Gold Pressed Latinum</a>
