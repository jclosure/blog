---
layout: post
title: "A Small Javascript To Safely Load Scripts and Styles Into The DOM"
date: 2010-01-19 23:32:59 -0600
categories: []
tags: []
wordpress_id: 10
original_url: "https://joelholder.com/2010/01/19/a-small-javascript-to-safely-load-scripts-and-styles-into-the-dom/"
---

Consider scenarios where you have pages composed of parts that are combined at runtime. If the many authors of those parts have external script references sprinkeled throughout, there is the chance that author2 might over write author1's reference of JQuery or some other script dependency. The consequences of doing this are usually breakage. I wrote this little script to allow all authors to call their scripts into page parts safely, ensuring that a script or stylesheet reference never overwrites another. This script assumes that URI is sufficient to uniquely identify a script. It does not attempt to deal with the situation where 2 developers might both load the same library from different URIs.

```html
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title></title>
    <script type="text/javascript">

        /**
        * Function object to carry DOM management behaviors
        */
        function bootStrapper() {

            var head = document.getElementsByTagName("head")[0];

            /**
            * Loads an external javascript source by creating a <script> tag
            * and injecting it into the DOM.
            * @param {string} src Url of the content uri
            * @param {string} opt_id An optional id for the <script> tag
            */
            this.addScriptReference = function (url, opt_id) {
                if (!isLoaded(head, 'script', 'src', url)) {
                    var script = document.createElement('script');
                    if (opt_id)
                        script.id = opt_id;
                    script.type = 'text/javascript';
                    script.src = url;
                    head.appendChild(script);
                }
            };

            /**
            * Loads an external style source by creating a <link> tag
            * and injecting it into the DOM.
            * @param {string} src Url of the content uri
            * @param {string} opt_id An optional id for the <link> tag
            */
            this.addStyleReference = function (url, opt_id) {
                if (!isLoaded(head, 'link', 'href', url)) {
                    var style = document.createElement('link');
                    if (opt_id)
                        style.id = opt_id;
                    style.href = url;
                    style.rel = "stylesheet";
                    style.type = "text/css";
                    head.appendChild(style);
                }
            };

            /**
            * Tests to see if tag with matching key and value properties is
            * present in container
            * @param {DOM Node} container dom element to search
            * @param {string} name of the tag to be searched for
            * @param {string} name of the attribute of belonging to the tag
            * @param {string} value of the attribute of belonging to the tag
            */
            function isLoaded(container, tagName, propKey, propValue) {
                var elems = container.getElementsByTagName(tagName);

                var alreadyLoaded = false;
                for (var i = 0, elem; elem = elems[i]; i++) {
                    if (elem[propKey] == propValue) {
                        alreadyLoaded = true;
                        break;
                    }
                }
                return alreadyLoaded;
            };
        }

    </script>

    <script type="text/javascript">

        var boot = new bootStrapper();

        //redundant script
        boot.addScriptReference('http://ajax.googleapis.com/ajax/libs/jquery/1/jquery.min.js', "jQuery1");
        boot.addScriptReference('http://ajax.googleapis.com/ajax/libs/jquery/1/jquery.min.js', "jQuery2");

        //redundant style
        boot.addStyleReference('http://www.codeweblog.com/template/andy/css/style.css', "Style1");
        boot.addStyleReference('http://www.codeweblog.com/template/andy/css/style.css', "Style2");

    </script>

</head>
<body>

    <p>Example Usage...</p>

</body>
</html>
```

The result of the above usage is that only 1 instance of the Javascript and only 1 instance of the stylesheet is loaded.
