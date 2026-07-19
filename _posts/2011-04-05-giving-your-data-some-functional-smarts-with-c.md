---
layout: post
title: "Giving Your Data Some Higher Order Muscle With C#"
date: 2011-04-05 22:12:00 -0500
categories: []
tags: []
wordpress_id: 110
original_url: "https://joelholder.com/2011/04/05/giving-your-data-some-functional-smarts-with-c/"
---

Today a colleague and I were going through some code.  I have recently been trying to impart to him the power and beauty in the functional programing paradigm in C#.  Today, the opportunity to demonstrate it presented itself as I was showing him how to use extension methods to extend Entities and ValueObjects with a suite-to-purpose functional API.  As we began the code, I realized that what I really wanted to show him was the concept with no additional fluff.  First, the extension method part.

Here’s what I came up with:

~~~ csharp
public static class IntExtensions
{
    public static void Times(this int count, Action<int> action)
    {
        for (var i = 0; i
        {
            action(i);
        }
    }
}
~~~

<div style="height:60px;padding-top:35px;">
<p class="MsoNormal" style="line-height:normal;margin:0;">This small extension to the builtin int type, gives us a convenient and expressive functional API, driven directly from Int32 typed variables themselves.  Now, we can use it as follows.</p>

</div>

~~~ csharp
[TestMethod]
public void SampleRepository_Can_Create_New()
{
     10.Times(i =>
     {
          var sample = TestObjects.BuildSample();
          SampleRepository.Save(sample);
     });

     var samples = SampleRepository.GetAll();

     samples.Count().Times(i => Debug.WriteLine("your index is " + i));

     Assert.IsTrue(samples.Count() == 10, "Should have 10 samples");
}
~~~

Rubyists recognize this API as its built into the language.  Its simple stepwise iteration driven directly off numeric types.  In C# we can use extension methods to shim this behavior into our scalers.  APIs that read like <strong>5.Times(doSomething); </strong>read like English.  This makes our code  more comprehensible by everyone, and that ladies and gentlemen is worth its weight in <a href="http://en.wikipedia.org/wiki/Fictional_currency">Gold Pressed Latinum</a>
