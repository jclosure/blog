---
layout: post
title: "DataBinding JS Objects Into HTML Forms"
date: 2010-10-10 20:10:44 -0500
categories: []
tags: []
wordpress_id: 3
original_url: "https://joelholder.com/2010/10/10/databinding-js-objects-into-html-forms-with-jquery-datalink-and-jquery-tmpl/"
---

Till now [chain.js](http://github.com/raid-ox/chain.js/wiki) has been my favorite light touch templating and data-linking library. Today finally the official JQuery templating, data-linking, and globalization plugins are [here](http://blog.jquery.com/2010/10/04/new-official-jquery-plugins-provide-templating-data-linking-and-globalization/). The new plugins are very simple to use and nicely fill 2 very important gaps that really needed officially supported solutions, namely templating and datalinking. I'll show you a little bit of the goodness you can quickly compose using these features together. Here's an example showing how a company object and a form representing a company can be bound together with minimal effort.

```html
<html>
    <head>
        <title>Demo</title>
        <script src="../../jquery-datalink/jquery.js" type="text/javascript"></script>
        <script src="../../jquery-tmpl/jquery.tmpl.js" type="text/javascript"></script>
        <script src="../../jquery-datalink/jquery.datalink.js" type="text/javascript"></script>

        <script type="text/javascript">

            $(document).ready(function () {

                var company = { companyName: 'ABC', companyPhone: '(555) 555-5555' };

                $("#companyDetail")
                    .tmpl(company)                //render object into form template
                    .link(company)                //link object to form fields
                    .appendTo("#renderTarget")     //place the rendered template into the DOM
                    .find("#saveCompany").click(function (evt) {
                        evt.preventDefault();
                        $.ajax({
                            url: "/company/save",
                            data: company,
                            success: function (data) {
                                alert("success");
                            }
                        });
                    });

            });

        </script>
    </head>
    <body>
        <div id="templates">
        <div id="companyDetail" class="company" style="display: none">
            <form action="" method="post">
            <label for="companyName">
                Company Name</label>
            <input type="text" id="companyName" name="companyName" value="${companyName}" />
            <label for="companyPhone">
                Company Phone</label>
            <input type="text" id="companyPhone" name="companyPhone" value="${companyPhone}" />
            <br />
            <input type="button" id="saveCompany" name="saveCompany" style="height: 20px; width: 40px;" />
            </form>
        </div>
    </div>

        <div id="renderTarget"></div>
    </body>
</html>
```

Manually loading and reading data between js objects and forms with JQuery typically makes use of $(…).val() for setting and getting values from form elements. This approach while precise and flexible, it can be very tedious and the work itself is largely just cruft. In order to more easily surface data for reading and writing into screens, I've been mixing templating and data-linking together with HTML forms.

![](/assets/wp/databinding-js-objects-into-html-forms-with-jquery-datalink-and-jquery-tmpl/0a25ecc87a06e17fa1c80f4bf1c5d78f.jpg)

When I make changes to the value in each field, they are immediately propagated to the object and visa versa. I can also make changes to the object and see those changes reflected in the screen.

![](/assets/wp/databinding-js-objects-into-html-forms-with-jquery-datalink-and-jquery-tmpl/bc6627a90206a1751207ff4a6ff14eef.png)

Here I trigger the save back to the server with a button click where I have a debugger statement. I did this to show you that the value of the properties bound to the form have been automatically updated. This is a more natural way to keep data synchronized between markup and javascript objects. Note that I was able to do this with a single chain of JQuery expressions, including the nested ajax function which sends to the "company object" to the server for persisting the change. This general approach takes care of the underlying cruft and allows me to focus on what I really just want to do.. In this case, to save the state changes in the object.
