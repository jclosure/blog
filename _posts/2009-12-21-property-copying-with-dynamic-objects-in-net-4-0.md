---
layout: post
title: "Property Copying With Dynamic Objects in .NET 4.0"
date: 2009-12-21 23:40:33 -0600
categories: []
tags: []
wordpress_id: 11
original_url: "https://joelholder.com/2009/12/21/property-copying-with-dynamic-objects-in-net-4-0/"
---

Lately, I've been trying out some of the new .NET 4.0 language features. Specifically, I've been looking into ways to trivially combine late dispatch and late binding in order to build general purpose convenience objects. In this case, I wanted an expando object that I could program against with some of the techniques we use in javascript to programmatically build up a graph's shape with runtime logic. The built in System.Dynamic.ExpandoObject was not sufficient for this purpose, in that it does not provide a mechanism for setting property names at runtime via string, not to mention its sealed. In this post I'll quickly show you how to leverage C# dynamic to copy and replicate the shape and values of a POCO at runtime. By exposing a subclassed DynamicObject's properties publicly via a Dictionary<string, object>, we can do things like this:

```csharp
[TestMethod]
public void Can_Set_Get_Properties()
{
    dynamic expandable = new ExpandableObject();

    expandable.Properties.Add("foo", "good stuff");

    Assert.AreEqual(expandable.foo, expandable.Properties["foo"]);

    expandable.bar = "yummy";

    Assert.AreEqual(expandable.bar,  expandable.Properties["bar"]);
}
```

With a few helper methods this capability becomes more useful. See here:

```csharp
[TestMethod()]
public void Expandable_Object_Can_Copy_Properties_From_To()
{
    dynamic expandable = new ExpandableObject();

    var testObj = new TestObject
    {
        ID = 1,
        Description = "ASDFASDF",
        Name = "GGGG",
        UnitPrice = 6
    };

    expandable.CopyPropertiesFrom(testObj, null);

    Assert.AreEqual(expandable.Description, testObj.Description);

    var testObj2 = new TestObject();

    expandable.CopyPropertiesTo(testObj2, null);

    Assert.AreEqual(testObj, testObj2);
}
```

Here is the implementation of ExpandableObject.

```csharp
public class ExpandableObject : DynamicObject
{
    Dictionary<string, object>
      _properties = new Dictionary<string, object>();

    public Dictionary<string, object> Properties
    {
        get { return _properties; }
        set { _properties = value; }
    }

    public override bool TrySetMember(SetMemberBinder binder, object value)
    {
        _properties[binder.Name] = value;
        return true;
    }

    public override bool TryGetMember(GetMemberBinder binder,
        out object result)
    {
        return _properties.TryGetValue(binder.Name, out result);
    }

    public void CopyPropertiesFrom(object source, List<string> ignoreList)
    {
        ignoreList = ignoreList ?? new List<string>();

        foreach (var property in source.GetType().GetProperties().Where(p => p.CanRead))
        {
            var key = property.Name;
            if (!ignoreList.Contains(key))
            {
                var value = property.GetValue(source, null);
                this.Properties[key] = value;
            }
        }
    }

    public void CopyPropertiesTo(object destination, List<string> ignoreList)
    {
        ignoreList = ignoreList ?? new List<string>();

        var destProps = destination.GetType().GetProperties().ToList();
        this.Properties.Keys.ToList().ForEach(key =>
        {
            if (!ignoreList.Contains(key))
            {
                var value = this.Properties[key];

                var property = destProps.Where(p => p.CanWrite &&
                                               p.Name == key &&
                                               p.PropertyType == value.GetType()).FirstOrDefault();
                if (property != null)
                {
                    property.SetValue(destination, value, null);
                }
            }
        });
    }
}
```

There is no spoon...

Enjoy...
