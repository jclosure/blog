---
layout: post
title: "Loading Scripts As Strings into the DOM"
date: 2010-11-01 19:49:24 -0600
categories: []
tags: []
wordpress_id: 43
original_url: "https://joelholder.com/2010/11/01/loading-scripts-as-strings-into-the-dom-with-jquery/"
---

Here's why JavaScript is teh awsome:

```javascript
var ns = {};
$(document).ready(function () {
    $('<scrip'+'t>ns.blah=function(){alert("hi");};</scr'+'ipt>')
        .appendTo('body');
    ns.blah();
});
```

With this I get:

![image](/assets/wp/loading-scripts-as-strings-into-the-dom-with-jquery/image_thumb.png)

Here play with it yourself.

[http://www.jsfiddle.net/nVuNZ/](http://www.jsfiddle.net/nVuNZ/)

Consider the deployment and update scenarios enabled using this technique with a modular application pattern.
