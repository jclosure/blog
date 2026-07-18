---
layout: post
title: "Implementing method_missing with C# dynamic – Part 2"
date: 2010-03-14 14:53:48 -0600
categories: []
tags: []
wordpress_id: 9
original_url: "https://joelholder.com/2010/03/14/implementing-missing_method-with-c-dynamic-part-2/"
---

In my previous post, [Implementing method_missing with C# dynamic – Part 1](http://uberpwn.spaces.live.com/blog/cns!3FC3980D58CF7EFB!516.entry), I demonstrated a simple approach to plugging a method_missing call routing seam into a DynamicObject. Here I'll take it a step further to implement a generic method_missing function capable of passing any call to a forwarding context object. Note that I do not have to define the method_missing in the calling code; its now automatically setup for me in DynamicObject itself.

```csharp
[TestMethod]
public void Can_Forward_Through_Default_Missing_Method()
{
    dynamic dispatcher1 = new ExpandableDispatcher();
    dynamic dispatcher2 = new ExpandableDispatcher();
    dynamic dispatcher3 = new ExpandableDispatcher();

    //configure forwarding
    dispatcher1.ForwardContext = dispatcher2;
    dispatcher2.ForwardContext = dispatcher3;

    //set responder on dispatcher3
    dispatcher3.Methods["RunMeta"] = new Func<string, string>(param =>
    {
        return "Meta said " + param;
    });

    //try to execute the responder from dispatcher1
    var response = dispatcher1.RunMeta("I am a probe..");

    Assert.IsTrue(response == "Meta said I am a probe..");
}
```

The implementation of ExpandableDispatcher contains a DynamicObject reference called ForwardContext. This handle is for forwarding messages that cannot be responded to by the `this` in the current execution context. Note that in the ctor, the dispatcher sets up its own, method_missing.

```csharp
public class ExpandableDispatcher : DynamicObject
{
    DynamicObject forwardContext;

    public DynamicObject ForwardContext
    {
        get { return forwardContext; }
        set { forwardContext = value; }
    }

    IDictionary<string, object> _methods = new Dictionary<string, object>();

    public IDictionary<string, object> Methods
    {
        get { return _methods; }
        set { _methods = value; }
    }

    public ExpandableDispatcher()
    {
        //setup default method_missing
        this._methods["method_missing"] = new Func<DynamicObject, InvokeMemberBinder, object[], object>((contextObject, binder, args) =>
        {
            dynamic context = contextObject;

            var method = context.Methods.ContainsKey(binder.Name) ? context.Methods[binder.Name] : null;
            var method_missing = context.Methods.ContainsKey("method_missing") ? context.Methods["method_missing"] : null;

            if (method != null)
            {
                if (method.ToString().StartsWith("System.Action"))
                {
                    RunAction(method, args);
                }
                else
                {
                    return RunFunc(method, args);
                }
            }
            else if (method_missing != null)
            {
                return method_missing(context.ForwardContext, binder, args);
            }

            return null;
        });
    }

    private object RunFunc(dynamic method, object[] args)
    {
        switch (args.Length)
        {
            case 0:
                return method();
            case 1:
                return method(args[0]);
            case 2:
                return method(args[0], args[1]);
            case 3:
                return method(args[0], args[1], args[2]);
            case 4:
                return method(args[0], args[1], args[2], args[3]);
            case 5:
                return method(args[0], args[1], args[2], args[3], args[4]);
        }
    }

    private void RunAction(dynamic method, object[] args)
    {
        switch (args.Length)
        {
            case 0:
                method();
                break;
            case 1:
                method(args[0]);
                break;
            case 2:
                method(args[0], args[1]);
                break;
            case 3:
                method(args[0], args[1], args[2]);
                break;
            case 4:
                method(args[0], args[1], args[2], args[3]);
                break;
            case 5:
                method(args[0], args[1], args[2], args[3], args[4]);
                break;
        }
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
            var method_missing = _methods["method_missing"] as Delegate;
            var ctxParam = method_missing.Method.GetParameters().Where(p => p.Position == 0 &&
                                                                        p.ParameterType == typeof(DynamicObject)).FirstOrDefault();
            if (ctxParam != null && forwardContext != null)
            {
                dynamic context = forwardContext;
                result = method_missing.DynamicInvoke(context, binder, args);
                return true;
            }
            else
            {
                result = method_missing.DynamicInvoke(binder, args);
                return true;
            }
        }
        else
        {
            return base.TryInvokeMember(binder, args, out result);
        }
    }
}
```

For further reading on the topics I discussed and demonstrated in this series, [this MSDN article](http://msdn.microsoft.com/en-us/library/ee658247.aspx) shows a clever approach to creating MethodBags by passing lambda Expressions to a DynamicObject, which are then compiled into Delegates and assigned to to the dynamic itself. In successive posts, I'll be exploring the new extensions to the System.Linq.Expressions.Expression API in .NET 4.0.

Enjoy..
