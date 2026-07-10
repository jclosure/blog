---
layout: post
title: "Introducing X DSL, A More Fluent XML Builder"
date: 2013-05-13 19:48:08 -0500
categories: []
tags: []
wordpress_id: 274
original_url: "https://joelholder.com/2013/05/13/introducing-x-dsl-a-more-fluent-xml-builder/"
---
<p>A while back, I <a href="http://joelholder.com/2012/09/14/251/"><span style="color:blue;text-decoration:underline;">posted</span></a> about using DynamicObjects to facilitate building Domain Specific Languages in C#. To the extent that we have to play within the syntactic sandbox that the language itself requires, we are still able to take advantage of what is available in the way of built in operators by changing their meaning. Specifically, with the X DSL, I&#8217;ve combined some simple operators and a dynamic chaining API in order to make a code syntax that is more representative of the XML we want it to build for us. Here is an example:</p>
<p><strong>Suppose we want to build this XML Document:<br />
</strong></p>
<pre class="brush: xml; title: ; notranslate" title="">
&lt;Customers&gt;
  &lt;Customer category=&quot;Foo&quot; type=&quot;Bar&quot;&gt;
    &lt;Address&gt;
      &lt;Street&gt;123 Sunny Drive&lt;/Street&gt;
      &lt;City&gt;Austin&lt;/City&gt;
      &lt;State&gt;TX&lt;/State&gt;
    &lt;/Address&gt;
    &lt;Profile CreatedOn=&quot;2013-05-13T18:44:27.39154-05:00&quot;&gt;
      &lt;Theme&gt;Aristo&lt;/Theme&gt;
      &lt;DefaultPage&gt;http://www.google.com&lt;/DefaultPage&gt;
    &lt;/Profile&gt;
  &lt;/Customer&gt;
&lt;/Customers&gt;
</pre>
<p><strong>With X, we would use code that looks like this to create it:<br />
</strong></p>
<pre class="brush: csharp; title: ; notranslate" title="">
var x = X._.Customers()
            &gt; X._.Customer(category: &quot;Foo&quot;, type: &quot;Bar&quot;)
                &gt; X._.Address()
                    &gt; X._.Street(&quot;123 Sunny Drive&quot;)
                    + X._.City(&quot;Austin&quot;)
                    + X._.State(&quot;TX&quot;)
                &lt; X._.Profile(CreatedOn: DateTime.Now)
                    &gt; X._.Theme(&quot;Aristo&quot;)
                    + X._.DefaultPage(&quot;http://www.google.com&quot;);
</pre>
<p>The goal with X, is to make the code structurally and semantically similar to that which its instructions create. Take a close look. You&#8217;ll note a few interesting characteristics. First, I&#8217;m using X._ to represent the pipeline continuations. This allows me to make operations over an unknown number of chained future resources as the expression continues. There are a number of novel concepts that this approach yields up. First, we&#8217;re able to create a pretty complex structural recipe in a single expression. This is effectively a single line of code. Next, I&#8217;ve selected symbols for the operations that are indicative of directional navigation through immerging hierarchal and sibling relations. Specifically, the dialect has the following:</p>
<p><strong>> means &#8220;step down and create what follows&#8221;<br />
</strong></p>
<p><strong>&lt; means &#8220;step up and create what follows&#8221;<br />
</strong></p>
<p><strong>+ means &#8220;stay at the current level and create what follows&#8221;<br />
</strong></p>
<p>These operation constructs enable navigation and creation simultaneously. This takes care of our need to create Xml nodes and their inner texts. However, what about attributes? Well, you can see that those too are enabled, by leveraging C#&#8217;s named parameters capability.</p>
<p><strong>Thus, when we say:<br />
</strong></p>
<p><span style="color:#2b91af;font-family:Consolas;font-size:9pt;"><span style="background-color:white;">X<span style="color:black;">._.Customer(category: <span style="color:#a31515;">&#8220;Foo&#8221;<span style="color:black;">)</span></span></span></span><br />
</span></p>
<p><strong>We get:<br />
</strong></p>
<p><span style="color:blue;font-family:Consolas;font-size:9pt;background-color:white;">&lt;<span style="color:#a31515;">Customer <span style="color:blue;"><span style="color:red;font-size:9pt;">category</span><span style="color:blue;">=<span style="color:black;">&#8220;<span style="color:blue;">Foo&#8221;></span></span></span></span></span></span></p>
<p>Pretty nice. <em><br />
</em></p>
<p>This elegant abuse of the language can get us closer to code/output isomorphism, wherein the code resembles that which it is creating (at least more closely than the builtin APIs .NET provides for this kind of thing). It was inspired by the Excellent <a href="https://github.com/jimweirich/builder"><span style="color:blue;text-decoration:underline;">Builder</span></a> library in Ruby. However, there are notable differences in how operators are used here to provide the Xml as the output of a composite expression, rather than a statement chain, as it works with Builder. In any case, I believe there is a compelling case to close the representational gap between data and code. If there&#8217;s anything that Lisp can teach us it&#8217;s that data and code should be thought of as the same thing. The closer we can get to that ideal the simpler, and more powerful our tools become in allowing us to express our intent and have the code just carry it out.</p>
<p>The implementation of X is <a href="http://pastebin.com/sTAsTrxp"><span style="color:blue;text-decoration:underline;">here</span></a> and below for anyone wishing to play around with it:</p>
<pre class="brush: csharp; title: ; notranslate" title="">

public class X : DynamicObject
{
    List&lt;XElement&gt; xsiblings = new List&lt;XElement&gt;();
    XElement xwrapper;
    XElement xplace;

    Dictionary&lt;string, Func&lt;X&gt;&gt; customOperators = new Dictionary&lt;string, Func&lt;X&gt;&gt;();

    private Func&lt;X&gt; Down
    {
        get { return () =&gt; new X(xplace) { xplace = xplace }; }
    }

    private Func&lt;X&gt; Up
    {
        get
        {
            var parent = xplace.Parent ?? xplace;
            parent = parent.Parent ?? parent;
            return () =&gt; new X(parent) { xplace = xplace.Parent };
        }
    }

    private Func&lt;X&gt; Self
    {
        get { return () =&gt; new X(this);  }
    }

    public static dynamic _{ get { return New; } }

    public static dynamic New
    {
        get
        {
            Func&lt;dynamic&gt; exp = () =&gt;
            {
                var b = new X();
                return (dynamic)b;
            };
            return exp.Invoke();
        }
    }

    protected void init()
    {
        customOperators.Add(&quot;&gt;&quot;, () =&gt; Down());
        customOperators.Add(&quot;&lt;&quot;, () =&gt; Up());
        customOperators.Add(&quot;+&quot;, () =&gt; Self());
        customOperators.Add(&quot;_&quot;, () =&gt; _);
    }

    public X(){
        xwrapper = new XElement(&quot;Wrapper&quot;);
        xplace = xwrapper;
        init();
    }

    public X(XElement xelem)
    {
        xwrapper = xelem;
        xplace = xwrapper.Descendants().LastOrDefault() ?? xwrapper;
        init();
    }

    public X(X builder)
    {
        xwrapper = builder.xwrapper;
        xplace = xwrapper.Descendants().LastOrDefault() ?? xwrapper;
        init();
    }

    public X(X builder1, X builder2)
    {
        builder1.xplace.Add(builder2.xwrapper);
        builder2.xplace = builder1.xplace;
        init();
    }

    public override string ToString()
    {
        var sb = new StringBuilder();
        var content = xwrapper.Descendants();
        foreach (var c in content)
            sb.Append(c.ToString());
        return sb.ToString();
    }

    public static X operator +(X c1, X c2)
    {
        c1.xwrapper.Add(c2.xwrapper.Descendants());
        return c1;
    }

    public static X operator &gt;(X c1, X c2)
    {
        var xlast = c1.xplace.Descendants().LastOrDefault();
        xlast = xlast ?? c1.xplace;
        xlast.Add(c2.xwrapper.Descendants());
        return c1;
    }

    public static X operator &lt;(X c1, X c2)
    {
        var xlast = c1.xplace.Parent.Descendants().LastOrDefault();
        xlast = xlast ?? c1.xplace;
        var parent = xlast.Parent ?? xlast;
        parent = parent.Parent ?? parent;
        parent.Add(c2.xwrapper.Descendants());
        return c1;
    }

    public override bool TryInvoke(InvokeBinder binder, object&amp;#91;&amp;#93; args, out object result)
    {
            return base.TryInvoke(binder, args, out result);
    }

    public override bool TryInvokeMember(InvokeMemberBinder binder, object&amp;#91;&amp;#93; args, out object result)
    {
        result = default(object);

        if (customOperators.ContainsKey(binder.Name))
            result = customOperators&amp;#91;binder.Name&amp;#93;();
        else //build with this call
        {
            var work = new Func&lt;object&gt;(() =&gt;
            {
                var diff = args.Count() - binder.CallInfo.ArgumentNames.Count;
                var innerText = string.Empty;
                var argQueue = new Queue&lt;object&gt;(args);
                if (diff &gt; 0)
                    diff.Times(i =&gt; innerText += argQueue.Dequeue().ToString());

                args = argQueue.ToArray();
                var parameters = new Dictionary&lt;string, object&gt;();
                binder.CallInfo.ArgumentNames.Count().Times(i =&gt;
                {
                    parameters.Add(binder.CallInfo.ArgumentNames&#x5B;i], args&#x5B;i]);
                });

                XElement xelem = new XElement(binder.Name,
                    parameters.ToList().Select(param =&gt; new XAttribute(param.Key, param.Value)));
                xelem.Add(innerText);
                xplace = xelem;
                return xelem;
            });
            var output = work.DynamicInvoke() as XElement;
            xwrapper.Add(output);
            result = this;
        }
        return true;
    }

    public X this&#x5B;string key]
    {
        get { return customOperators&#x5B;key](); }
    }
}
</pre>
<p><strong>Namaste&#8230;</strong></p>
