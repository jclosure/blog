---
layout: post
title: "Implementing method_missing with C# dynamic – Part 1"
date: 2010-03-11 22:50:19 -0600
categories: []
tags: []
wordpress_id: 4
original_url: "https://joelholder.com/2010/03/11/implementing-missing_method-with-c-dynamic-part-1/"
---

One of the neat things about Ruby is its method_missing fallback capability. Using the C# 4.0 DynamicObject, we're also able to control dispatch at runtime. I wanted to see how the method_missing idiom might work with a C# dynamic dispatcher, so I wrote up a small sample.

```csharp
[TestMethod]
public void Can_Control_Dynamic_Dispatch()
{
    dynamic dispatcher1 = new ExpandableDispatcher();

    dynamic dispatcher2 = new ExpandableDispatcher();

    dispatcher1.Methods["method_missing"] = new Func<string, object>(param =>
    {
        return dispatcher2.RunMeta(param);
    });

    dispatcher2.Methods["RunMeta"] = new Func<string, string>(param =>
    {
        return "Meta said " + param;
    });

    var response = dispatcher1.RunMeta("I am a probe..");

    Assert.IsTrue(response == "Meta said I am a probe..");
}
```

Note that an attempt to execute RunMeta is made on dispatcher1, but RunMeta is not defined on dispatcher1; its on dispatcher2. The call gets routed by method_missing to dispatcher2 for execution. In this simple case, the call is passed from a Delegate in dispatcher1 to one in dispatcher2 via a closure reference set in the calling code. A more elaborate message passing implementation, however, will allow method_missing to forward the call to a ServiceLocator or back up the call stack until it finds a method with a matching name and signature.

Here's the simplest implementation of ExpandableDispatcher.

```csharp
public class ExpandableDispatcher : DynamicObject
{
    IDictionary<string, object> _methods = new Dictionary<string, object>();
    public IDictionary<string, object> Methods
    {
        get { return _methods; }
        set { _methods = value; }
    }

    public override bool TryInvokeMember(InvokeMemberBinder binder, object[] args, out object result)
    {
        if (_methods.ContainsKey(binder.Name) && _methods[binder.Name] is Delegate)
        {
            result = (_methods[binder.Name] as Delegate).DynamicInvoke(args);
            return true;
        }
        else if (_methods.ContainsKey("method_missing") && _methods["method_missing"] is Delegate)
        {
            result = (_methods["method_missing"] as Delegate).DynamicInvoke(args);
            return true;
        }
        else
        {
            return base.TryInvokeMember(binder, args, out result);
        }
    }
}
```

As you can see, dynamic dispatch in C# 4.0 gives us the power to define method calling routes with an emphasis on runtime behavioral composition. This enables a new family patterns in C# that leverage dynamic message routing using runtime assignment of Delegates to DynamicObject facades. For more reading on this topic, see the follow up post, [Implementing method_missing with C# dynamic – Part 2](http://uberpwn.spaces.live.com/blog/cns!3FC3980D58CF7EFB!518.entry).

Enjoy..
