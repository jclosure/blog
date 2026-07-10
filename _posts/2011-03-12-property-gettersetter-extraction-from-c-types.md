---
layout: post
title: "Property getter/setter extraction from C# Types"
date: 2011-03-12 23:41:42 -0600
categories: []
tags: []
wordpress_id: 77
original_url: "https://joelholder.com/2011/03/12/property-gettersetter-extraction-from-c-types/"
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


<p class="MsoNormal">The C# Expression API allows you to scrape property and method definitions from Types and work with them as external references.  See here:</p>

<pre>


<span style="font-family:consolas;color:blue;">using</span><span style="font-family:consolas;"> System;
<span style="color:blue;">using</span> System.Collections.Generic;
<span style="color:blue;">using</span> System.Linq;
<span style="color:blue;">using</span> System.Text;
<span style="color:blue;">using</span> System.Linq.Expressions;
<span style="color:blue;">using</span> System.Dynamic;
<span style="color:blue;">using</span> System.Runtime.CompilerServices;

<span style="color:blue;">public</span> <span style="color:blue;">static</span> <span style="color:blue;">class</span> <span style="color:#2b91af;">Extensions</span></span></pre>

<pre style="min-height:200px;">

<span style="font-family:consolas;"><span style="color:#2b91af;"> </span></span><span style="font-family:consolas;">{
       <span style="color:blue;">public</span> <span style="color:blue;">static</span> <span style="color:#2b91af;">Func</span><X, T> GetPropertyFunction<X, T>(<span style="color:blue;">this</span> <span style="color:#2b91af;">Type</span> source, <span style="color:blue;">string</span> name)
          {
             <span style="color:#2b91af;">ParameterExpression</span> param = <span style="color:#2b91af;">Expression</span>.Parameter(<span style="color:blue;">typeof</span>(X), <span style="color:#a31515;">"arg"</span>);
             <span style="color:#2b91af;">MemberExpression</span> member = <span style="color:#2b91af;">Expression</span>.Property(param, name);
             <span style="color:#2b91af;">LambdaExpression</span> lambda = <span style="color:#2b91af;">Expression</span>.Lambda(<span style="color:blue;">typeof</span>(<span style="color:#2b91af;">Func</span><X, T>), member, param);
             <span style="color:#2b91af;">Func</span><X, T> compiled = (<span style="color:#2b91af;">Func</span><X, T>)lambda.Compile();
             <span style="color:blue;">return</span> compiled;
         }
}
</span>
</pre>

<p class="MsoNormal"> </p>
<p class="MsoNormal">And you can use it like this:</p>

<pre style="min-height:300px;">

<span style="font-family:consolas;">[<span style="color:#2b91af;">TestMethod</span>]
<span style="color:blue;">public</span> <span style="color:blue;">void</span> TestMethod1()
         {
             <span style="color:blue;">var</span> testObj = <span style="color:blue;">new</span> <span style="color:#2b91af;">TestObject</span>
             {
                 ID = 1,
                 Description = <span style="color:#a31515;">"ASDFASDF"</span>,
                 Name = <span style="color:#a31515;">"GGGG"</span>,
                 UnitPrice = 6
             };

             <span style="color:#2b91af;">Type</span> type = <span style="color:blue;">typeof</span>(<span style="color:#2b91af;">TestObject</span>);
             <span style="color:blue;">var</span> getName = type.GetPropertyFunction<<span style="color:#2b91af;">TestObject</span>, <span style="color:#2b91af;">String</span>>(<span style="color:#a31515;">"Name"</span>);
             <span style="color:#2b91af;">String</span> value = getName(testObj);

             <span style="color:#2b91af;">Assert</span>.IsTrue(value == testObj.Name);
       }</span></pre>
