---
layout: post
title: "Fat-Free Templating with Barebones Javascript"
date: 2010-03-17 23:11:03 -0600
categories: []
tags: []
wordpress_id: 6
original_url: "https://joelholder.com/2010/03/17/fat-free-templating-with-barebones-javascript/"
---

Today I'm going to demonstrate a straight-forward and very effective technique for markup templating. I've borrowed the supplant prototype function from [Douglas Crockford's – And Then There Was Javascript](http://developer.yahoo.com/yui/theater/video.php?v=crockonjs-2) presentation, in order to show you how to inject values from custom data structures directly into into strings. We'll be doing a minimal implementation here in order to show the great outcomes you can get without requiring buy in to one of the many over engineered frameworks that do this.

First we extend the prototype of the built in String type.

```javascript
String.prototype.supplant = function(o) {
    return this.replace(/{([^{}]*)}/g,
        function(a, b) {
            var r = o[b];
            return typeof r === 'string' || typeof r === 'number' ? r : a;
        }
    );
};
```

With this minimalist formatter in place we are able to do string manipulation like this:

```javascript
var result = "{a}-{b}-{c}".supplant({"a": "Foo", "b": "Bar", "c": "Baz"});
```

The resulting string would be: `"Foo-Bar-Baz"`. As you can see, we've essentially got a string formatting extension to all objects of type String here. Where this becomes immediately useful to us in our web pages, is for injecting objects directly into markup strings, which can then be programmatically added to the DOM. This technique is shown below in only 4 lines (statements) of Javascript.

```html
<div id="container" />

<script type="text/javascript">

    var template = '<table border="{border}">' +
                    '<tr><th>Last</th><td>{last}</td></tr>' +
                    '<tr><th>First</th><td>{first}</td></tr>' +
                    '</table>';

    var data = {
        "first": "Carl",
        "last": "Hollywood",
        "border": 2
    };

    var container = document.getElementById("container");
    container.innerHTML = template.supplant(data);

</script>
```

As you can see, we start with a template String and a JSON data Object. Then we get our target DOM node and simply set its `.innerHTML` property to the output of the template running its own `.supplant()` function against the data object. Very sparse, no heavy framework.. Its just the bare bones Javascript and a helper function. Here's an example of using this technique to set the .src property of an `<img>` DOM node.

Assuming I have an image file that I want to be targetable based on some script logic, it looks like this.

[![](/assets/wp/fat-free-templating-with-barebones-javascript/691c5d943ed0031de58500cd5504f44c.png)](/assets/wp/fat-free-templating-with-barebones-javascript/691c5d943ed0031de58500cd5504f44c.png)

The code that I need to target this file at runtime looks like this:

```html
<img id="logo" src="" />
<script type="text/javascript">

    var param = { domain: 'memecannon.com', media: '/Content/ninja' };
    var url = "{media}.jpg".supplant(param);

    var logo = document.getElementById("logo");
    logo.setAttribute("src", url);

</script>
```

The output looks like this:

[![](/assets/wp/fat-free-templating-with-barebones-javascript/71d9ae617d4ba755d8b6bab619f77e12.jpg)](/assets/wp/fat-free-templating-with-barebones-javascript/71d9ae617d4ba755d8b6bab619f77e12.jpg)

Using this approach, its quite easy to do targeting of custom skin artifacts and layout structures. Other uses of this approach are to programmatically inject variables into CSS strings and runtime script includes. As you can see, the basics for screen templating are exposed near the surface of DOM scripting with Javascript. That said, I do typically use [JQuery](http://jquery.com/) plugins for this type of screen composition. I've surveyed most of the JQuery plugins in this space. I recommend [JSRepeater](http://jsrepeater.devprog.com/google.search.websearch.example.html) for ease of use and support for automatic iterating over collections and dealing with heirarchal data structures. For an extremely unobtrusive templating solution, you can't beat [NoTemplate](http://plugins.jquery.com/project/noTemplate). It provides a level of externalized purity, in that you don't need to hack replacement ${targets} into your markup at all; rather, it uses selectors to reach down into your markup for mapping data to screen targets.

Hopefully, in this article I've informed, if not convinced you that you have the power to blend your data and markup in whatever ways you need purely with Javascript and with a minimum of effort. In a successive post, I'll show you how to interact this approach with Ajax Services to bring your screens to life.

Enjoy..
