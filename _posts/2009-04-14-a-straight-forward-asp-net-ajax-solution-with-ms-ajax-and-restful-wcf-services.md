---
layout: post
title: "A Straight Forward ASP.NET AJAX Solution With MS Ajax and Restful WCF Services"
date: 2009-04-14 22:22:53 -0500
categories: []
tags: []
wordpress_id: 13
original_url: "https://joelholder.com/2009/04/14/a-straight-forward-asp-net-ajax-solution-with-ms-ajax-restful-wcf-services-and-a-dash-of-jquery/"
---

One of the main advantages of JSON is that, like XML, it can represent an object graph of any shape. JSON allows for the natural structure of entity Types to be expressed in the form of nested and aggregated object literals. The simplicity and small footprint of this format has made it a popular choice for data interchange with the dynamic languages crowd, where JSON can be parsed into native objects with basic language constructs. This is what makes it most appealing for JavaScript developers. This article will demonstrate a straight forward way of doing Ajax with [WCF Rest](http://msdn.microsoft.com/en-us/netframework/cc950529.aspx), [MS Ajax](http://www.asp.net/ajax/), [Object Bakery](http://objectbakery.codeplex.com/), and [JQuery](http://docs.jquery.com/Main_Page).

1. Create a new WebForms project.
2. Drag in a ScriptManager to Default.aspx's form element.
3. Add JQuery-1.3.2.min.js to the project.
4. Drag JQuery-1.3.2.min.js into the head section.
5. Add an empty `<p />` to the form.
6. Switch to design view.
7. Drag in an HTML input button and double click it.

Your markup should now look something like this:

```html
<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="OBWeb._Default" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script src="js/jquery-1.3.2.min.js" type="text/javascript"></script>
    <script type="text/javascript">
        function Button1_onclick() {
        }
    </script>
</head>
<body>
<form id="form1" runat="server">
    <div>
        <asp:ScriptManager ID="ScriptManager1" runat="server" />
        <input id="Button1" type="button" value="submit" onclick="return Button1_onclick()" />
        <p />
    </div>
</form>
</body>
</html>
```

Notice that we have a stubbed out JavaScript function wired to our button.

8. Add a reference to ObjectBakery.dll, available [here](http://objectbakery.codeplex.com/).
9. Add a new "Ajax-enabled WCF Service" to your project.
10. Name it Service1.
11. Create a sample POCO that we can use for the demo. Here's mine:

```csharp
public class TestObject
{
    public int ID { get; set; }
    public string Description { get; set; }
}
```

12. Change the stubbed out DoWork method in Service1 to look like this.

```csharp
[WebGet]
[OperationContract]
public string DoWork(int id)
{
     //fab some data objects
     List<TestObject> obs = new List<TestObject>();
     obs.Add(new TestObject { ID = id, Description = "ASDFASDF" });
     obs.Add(new TestObject { ID = id + 1, Description = "QWER" });
     obs.Add(new TestObject { ID = id + 2, Description = "DFFG" });
     obs.Add(new TestObject { ID = id + 3, Description = "ZXCV" });

     //magic
     var helper = new ObjectBakery.Helpers.SerializationHelper();
     var txtO = helper.JsonSerialize(obs.ToArray());
     return txtO;
}
```

13. In the page designer right mouse click your ScriptManager and go to properties.
14. In the property designer click the ellipsis next to Services

[![ScriptManager Services property editor](http://blufiles.storage.msn.com/y1p9Ge-RNGG43g_zSoi4dvElynfWfPlNWFN8isJOhopr6kYlpRazKJg5bn3rnAw45BovVYrw6_8BQASI0MctSw9Bw?PARTNER=WRITER)](http://blufiles.storage.msn.com/y1pKpUb50qrK6pEZPTbjvD9mY_WHpLjU1jgQtKQMS2SVgqL-ZNF6XJKO0XxWcuANM89Xvx80Kn_U3Q?PARTNER=WRITER)

15. Add a Service, setting the Path property to the url of Service1, i.e. "/Service1.svc".
16. Now lets write some JavaScript.

```javascript
function Button1_onclick() {
    var service = new Service1();
    service.DoWork(3, onSuccess, null, null);
}

function onSuccess(result) {
    var objects = eval("(" + result + ")");
    for (var i in objects) {
        $("p").append(objects[i].Description + "<br />");
    }
}
```

What we did here is fill out our Button1_onclick with code that news up a Service1 reference and invokes its DoWork. The first argument will be passed as the id parameter to our WebMethod. The second argument is a callback, in our case the onSuccess method. Notice the signature of onSuccess takes a result param. This will be our JSON string returned from DoWork. Note that we can parse the result into a native JavaScript object graph with a single line of code.

```javascript
var objects = eval("(" + result + ")");
```

This is pretty cool. We trust our own service, so there's no issue with using eval, instead of parseJSON(). In our for loop, we use JQuery to add new DOM elements holding the Description property from each of our objects.

```javascript
$("p").append(objects[i].Description + "<br />");
```

[![Rendered results of the Description properties appended to the page](http://blufiles.storage.msn.com/y1pQFvMYhB-F9bnN7rqQHPAJ2mhICqD8hcJ4TbuO_nicRpAjYgXoUrM8euN-z-gg5EBZTh2NtEdaSXD6XYCes4qlQ?PARTNER=WRITER)](http://blufiles.storage.msn.com/y1pgz0RXbodBG66JHQFhyGLTMiJHK6YLLys_ZwaxOfIc7BL8otLDqhdQ9pW7Tu4af9rpXQ_YaHWnMI_yuVl2YnB1w?PARTNER=WRITER)

That's the basic story. What we've been able to do here is enable the basic async data exchange paradigm between an ASPX page and data enabled Rest services. There are some fun bits here when you couple this approach with ORM frameworks, such as [Entity Framework](http://msdn.microsoft.com/en-us/library/aa697427(VS.80).aspx) or [NHibernate](http://www.hibernate.org/343.html). We now have the capability to move objects between JavaScript and C# seamlessly. Object Bakery has helper methods to move between JSON and CLR graphs with a single line of code. I have found this approach helpful when I need to share objects between client and server, and I don't want to worry about the details of data interchange. Note that Object Bakery also works with Anonymous Types, which allows us to project out objects containing only the data our front-end needs and thus keeps our graphs and their isomorphic JSON strings as small as possible. Your users will appreciate every bit of responsivity you can give them.

You can download the code for this project [here](http://cid-3fc3980d58cf7efb.skydrive.live.com/self.aspx/Public/OBWeb.zip).

Enjoy..
