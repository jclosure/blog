---
layout: post
title: "Simple Random Password Generator"
date: 2008-12-02 23:33:14 -0600
categories: []
tags: []
wordpress_id: 18
original_url: "https://joelholder.com/2008/12/02/simple-random-password-generator/"
---
<div id="msgcns!3FC3980D58CF7EFB!238" class="bvMsg">
<div> </div>
<div>Simple C# function to generate random passwords: </div>
<div><font size="2"> </font></div>
<p><font color="#2b91af" size="2"><font color="#2b91af" size="2">Random</font></font><font size="2"> randomizer = </font><font color="#0000ff" size="2"><font color="#0000ff" size="2">new</font></font><font size="2"> </font><font color="#2b91af" size="2"><font color="#2b91af" size="2">Random</font></font><font size="2">(); </p>
<p></font><font color="#0000ff" size="2"><font color="#0000ff" size="2">public</font></font><font size="2"> </font><font color="#0000ff" size="2"><font color="#0000ff" size="2">string</font></font><font size="2"> CreateTemporaryPassword(</font><font color="#0000ff" size="2"><font color="#0000ff" size="2">int</font></font><font size="2"> length) </p>
<p>{ </p>
<p></font><font color="#0000ff" size="2"><font color="#0000ff" size="2">    string</font></font><font size="2"> letters = </font><font color="#a31515" size="2"><font color="#a31515" size="2">&#8220;0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz&#8221;</font></font><font size="2">; </p>
<p></font><font color="#0000ff" size="2"><font color="#0000ff" size="2">    var</font></font><font size="2"> chars = </font><font color="#0000ff" size="2"><font color="#0000ff" size="2">new</font></font><font size="2"> </font><font color="#0000ff" size="2"><font color="#0000ff" size="2">char</font></font><font size="2">[length]; </p>
<p></font><font color="#0000ff" size="2"><font color="#0000ff" size="2">    for</font></font><font size="2"> (</font><font color="#0000ff" size="2"><font color="#0000ff" size="2">int</font></font><font size="2"> i = 0; i < length; i++) 


<p>        chars[i] = letters[randomizer.Next(0, letters.Length)]; </p>
<p></font><font color="#0000ff" size="2"><font color="#0000ff" size="2">    return</font></font><font size="2"> </font><font color="#0000ff" size="2"><font color="#0000ff" size="2">new</font></font><font size="2"> </font><font color="#0000ff" size="2"><font color="#0000ff" size="2">string</font></font><font size="2">(chars); </p>
<p>}</p>
<p></font></div>
