---
layout: post
title: "Webshims – HTML5 For The Masses"
date: 2011-02-25 00:39:30 -0600
categories: []
tags: []
wordpress_id: 60
original_url: "https://joelholder.com/2011/02/25/webshims-html5-now-html5-everywhere/"
---

I've been researching the available shimming libaries out there that provide old browsers with modern features. The [Webshims](http://afarkas.github.com/webshim/demos/) library does this in an efficient and unobtrusive way, always defering to the browser's built in feature if it exists natively. With 2 lines of code you tell it where to find its shim scripts and then to discover and patch any missing HTML5 features in your browser. I've provided a complete working sample of how to ensure the HTML5 localStorage API in all browsers.

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">

    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.4/jquery.min.js"></script>

    <script src="/scripts/js-webshim/dev/polyfiller.js"></script>

    <script>

    //path is path of polyfiller.js-code + shims/
    $.webshims.loader.basePath += 'shims/';
    //load and implement all unsupported features
    $.webshims.polyfill();

    </script>


    <script>
    $.webshims.ready('json-storage', function () {
        //work with JSON and localStorage
        localStorage.setItem("name", "Hello World!"); //saves to the database, "key", "value"
        document.write(window.localStorage.getItem("name")); //Hello World!
        localStorage.removeItem("name"); //deletes the matching item from the database
    });
    </script>

    <title>localStorage() – Sample</title>
</head>
<body>

</body>
</html>
```
