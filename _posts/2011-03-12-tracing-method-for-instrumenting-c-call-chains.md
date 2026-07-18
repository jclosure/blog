---
layout: post
title: "Runtime Stack Introspection with C#"
date: 2011-03-12 22:26:10 -0600
categories: []
tags: []
wordpress_id: 68
original_url: "https://joelholder.com/2011/03/12/tracing-method-for-instrumenting-c-call-chains/"
---

```csharp
public static string WhoCalledMe()
{
    var st = new StackTrace();
    var sf = st.GetFrame(1);
    var mb = sf.GetMethod();
    return mb.Name;
}
```
