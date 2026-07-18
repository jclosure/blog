---
layout: post
title: "A config-based approach to pluggable composition"
date: 2008-12-15 00:24:25 -0600
categories: []
tags: []
wordpress_id: 12
original_url: "https://joelholder.com/2008/12/15/a-config-based-approach-to-pluggable-composition/"
---

I wanted to share this sample to demonstrate a simple way to implement a configuration based approach to switching out pluggable dependencies. The example here uses reflection to dynamically load an assembly and then instantiate the targeted class contained therein. The idea with this approach is that you may have different implementations of an interface contained in different assemblies. Thus, you're able to simply target the different implementations of the interface by switching an app config key that specifies a different assembly name. Note the following:

1. The `path` variable is the fully qualified assembly name.
2. The `className` variable is `path` with the name of the class that implements an expected interface appended to it. In this case, we expect the assembly to contain an implementation of `IOrder`.

From [PetShop.NET 4.0 reference app source](http://sharplife.net/2006/02/14/NETPetShop4Released.aspx):

```csharp
using System;
using System.Reflection;
using System.Configuration;

namespace PetShop.MessagingFactory
{
    /// <summary>
    /// This class is implemented following the Abstract Factory pattern to create the Order
    /// Messaging implementation specified from the configuration file
    /// </summary>
    public sealed class QueueAccess
    {
        // Look up the Messaging implementation we should be using
        private static readonly string path = ConfigurationManager.AppSettings["OrderMessaging"];
        private QueueAccess() { }
        public static PetShop.IMessaging.IOrder CreateOrder() {
            string className = path + ".Order";
            return (PetShop.IMessaging.IOrder)Assembly.Load(path).CreateInstance(className);
        }
    }
}
```
