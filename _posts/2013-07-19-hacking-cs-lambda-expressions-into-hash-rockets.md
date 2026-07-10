---
layout: post
title: "Hacking C#’s Lambda Expressions Into Hash Rockets"
date: 2013-07-19 21:04:05 -0500
categories: []
tags: ["C#", "lambda_expressions", "Ruby"]
wordpress_id: 337
original_url: "https://joelholder.com/2013/07/19/hacking-cs-lambda-expressions-into-hash-rockets/"
---
<p><a href="/blog/assets/wp/hacking-cs-lambda-expressions-into-hash-rockets/skitch.png"><img data-recalc-dims="1" loading="lazy" decoding="async" data-attachment-id="368" data-permalink="https://joelholder.com/2013/07/19/hacking-cs-lambda-expressions-into-hash-rockets/skitch/" data-orig-file="https://i0.wp.com/joelholder.com/wp-content/uploads/2013/07/skitch.png?fit=648%2C291&amp;ssl=1" data-orig-size="648,291" data-comments-opened="1" data-image-meta="{&quot;aperture&quot;:&quot;0&quot;,&quot;credit&quot;:&quot;&quot;,&quot;camera&quot;:&quot;&quot;,&quot;caption&quot;:&quot;&quot;,&quot;created_timestamp&quot;:&quot;0&quot;,&quot;copyright&quot;:&quot;&quot;,&quot;focal_length&quot;:&quot;0&quot;,&quot;iso&quot;:&quot;0&quot;,&quot;shutter_speed&quot;:&quot;0&quot;,&quot;title&quot;:&quot;&quot;}" data-image-title="c# loves Ruby" data-image-description="" data-image-caption="" data-large-file="https://i0.wp.com/joelholder.com/wp-content/uploads/2013/07/skitch.png?fit=648%2C291&amp;ssl=1" class="size-medium wp-image-368 alignright" alt="c# loves Ruby" src="/blog/assets/wp/hacking-cs-lambda-expressions-into-hash-rockets/skitch-2.png" width="300" height="134" /></a>As I move between C# and Ruby, I have found my brain’s internal syntax parser always needing to switch gears and repurpose its understanding of Fat Arrow, =>. In Ruby, it provides a visually salient means of expressing key => value pairing within a Hash. C# on the other hand uses it to indicate the opening of a lambda expression’s body block, x => x + y. Its notable that in other languages, such as Coffee Script, it has a similar meaning. In any case, the lines sometimes blur as I’m dreaming up new ways to make C# look and behave more like my favorite dynamic language.</p>
<p>In this post, I’m going to show you how to repurpose C#’s lambda expression syntax for creating key,value pairs.  My goal is be able create nestable enumerable graph structures with a syntax like this:</p>

~~~ csharp
var rockets = __.Rocketize(
                               foo => "asdf",
                               bar => 42,
                               biz => new Business{ Name = "AMD" },
                               now => DateTime.Now,
                               fun => new Func(() => return new Awesome(source: "Joel Holder")),
                               sub => __.Rocketize(a => 'b',
                                                   c => 'd',
                                                   e => 'f'),
                               xml => File.ReadAllText(@"data.xml"),
                               web => new Uri("http://joelholder.com/"),
                               ___ => typeof(__),
                               tru => (2*2+3*3)/(5*5) == 1,
                               etc => "..."
                          );
~~~

<p>First we need a few functions that leverage the Expression API to provide a means of taking in a series of lambda expressions. Internally, we will convert each expression’s AST into a named key and value of Func&lt;> that  returns an optional state object.</p>

~~~ csharp
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading;

namespace HashRocket
{
    public class __
    {
        public static IEnumerable<KeyValuePair<object, Func<object, object>>> Rocketize(params Expression<Func<object, object>>[] exprs)
        {
            return exprs.Select(expr =>
            {
                var key = expr.Parameters.FirstOrDefault() != null
                            ? expr.Parameters.FirstOrDefault().Name
                            : DateTime.Now.Ticks.ToString();
                return Rocketize(key, expr).First();
            });
        }
        public static IEnumerable<KeyValuePair<object, Func<object, object>>> Rocketize(object key, params Expression<Func<object, object>>[] exprs)
        {
            return exprs.Select(expr =>
            {
                var fn = expr.Compile();
                return new KeyValuePair<object, Func<object, object>>(key, fn);
            });
        }
    }
}
~~~

<p>Now that we have this in place, we can run a few tests to show off the behavior. Note that I’ve opted for IEnumerables of KeyValuePair instead of a Dictionary or Hashtable. This just a personal preference, in that I wanted to support multiple objects with the same key within the data structure.</p>
<p>using System;<br />
using System.Linq;<br />
using Microsoft.VisualStudio.TestTools.UnitTesting;</p>
<p>namespace HashRocket.Tests<br />
{<br />
    [TestClass]<br />
    public class Tests<br />
    {<br />
        [TestMethod]<br />
        public void Can_Convert_Lambda_Into_Kvp()<br />
        {<br />
            //arrange<br />
            var testInput = &#8220;asdf&#8221;;</p>
<p>            //act<br />
            var rocket = __.Rocketize(input => input).First();</p>
<p>            //assert<br />
            Assert.IsTrue(rocket.Key.Equals(&#8220;input&#8221;));<br />
            Assert.IsTrue(rocket.Value(testInput).Equals(&#8220;asdf&#8221;));<br />
        }</p>
<p>        [TestMethod]<br />
        public void Can_Convert_Multiple_Lambdas_Into_Multiple_Kvps()<br />
        {<br />
            //arrange<br />
            var testInputs = new object[] {&#8220;asdf&#8221;,&#8221;zxcv&#8221;,2};</p>
<p>            //act<br />
            var rockets = __.Rocketize(foo => foo + &#8220;qwer0&#8221;,<br />
                                       bar => bar + &#8220;qwer1&#8221;,<br />
                                       biz => biz + &#8220;qwer2&#8221;).ToList();</p>
<p>            //assert<br />
            for (var i = 0; i < rockets.Count; i++)
            {
                Assert.IsTrue(rockets[i].Value(testInputs[i]).Equals(testInputs[i] + "qwer" + i));
            }
        }
}
[/sourcecode]

What’s surprisingly cool about this approach is that it becomes very easy create configuration objects with lambda syntax that can be passed directly into objects for initialization. If you’re familiar with this pattern in Ruby or JavaScript, you’ll appreciate the power and elegance it also affords to C#. To better understand the benefits and potential tradeoffs to using this trick, see <a href="http://www.jeremyskinner.co.uk/2009/12/02/lambda-abuse-the-mvccontrib-hash/">Jeremy Skinner’s article</a> on the topic.</p>
<p>Namaste..</p>
