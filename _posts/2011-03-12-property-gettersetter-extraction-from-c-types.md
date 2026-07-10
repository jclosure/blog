---
layout: post
title: "Property getter/setter extraction from C# Types"
date: 2011-03-12 23:41:42 -0600
categories: []
tags: []
wordpress_id: 77
original_url: "https://joelholder.com/2011/03/12/property-gettersetter-extraction-from-c-types/"
---

<p class="MsoNormal">The C# Expression API allows you to scrape property and method definitions from Types and work with them as external references.  See here:</p>


~~~ csharp
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Linq.Expressions;
using System.Dynamic;
using System.Runtime.CompilerServices;

public static class Extensions
~~~



~~~ csharp
 {
       public static Func GetPropertyFunction(this Type source, string name)
          {
             ParameterExpression param = Expression.Parameter(typeof(X), "arg");
             MemberExpression member = Expression.Property(param, name);
             LambdaExpression lambda = Expression.Lambda(typeof(Func), member, param);
             Func compiled = (Func)lambda.Compile();
             return compiled;
         }
}
~~~


<p class="MsoNormal"> </p>
<p class="MsoNormal">And you can use it like this:</p>


~~~ csharp
[TestMethod]
public void TestMethod1()
         {
             var testObj = new TestObject
             {
                 ID = 1,
                 Description = "ASDFASDF",
                 Name = "GGGG",
                 UnitPrice = 6
             };

             Type type = typeof(TestObject);
             var getName = type.GetPropertyFunctionTestObject, String>("Name");
             String value = getName(testObj);

             Assert.IsTrue(value == testObj.Name);
       }
~~~
