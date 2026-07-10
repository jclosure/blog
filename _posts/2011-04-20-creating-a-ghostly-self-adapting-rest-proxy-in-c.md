---
layout: post
title: "Creating a “Supernatural” Self-Adapting REST Proxy in C#"
date: 2011-04-20 23:43:38 -0500
categories: []
tags: []
wordpress_id: 154
original_url: "https://joelholder.com/2011/04/20/creating-a-ghostly-self-adapting-rest-proxy-in-c/"
---

.NET 4.0’s DynamicObject provides a quick and easy way to hook into and control how a call for a method is dispatched at runtime.  This so called “late dispatch” capability is exactly what we need to easily create dynamic facades over out-of-process APIs, such as those of remote REST services.

In this post, I’ll show you how to take advantage of dynamic dispatch, in order to create an adaptive web agent that gets driven through a normal C# class API.  What I mean by normal, is that familiar dot syntax for calling methods from our objects.  However, in this case the methods we will be calling are not actually there; they are “<a href="http://www.timonv.nl/2011/01/18/unusual-ruby-metaprogramming-101-2-method" target="_blank">ghost methods</a>”.   They do not exist on the object whose receiving the call.  This might sound a bit strange to the uninitiated, but fear not, you’re about to get your secret decoder rings.  C#’s DynamicObject gives us the opportunity to delegate to remote service APIs transparently, without the knowledge or concern of the caller. 

To demonstrate this in action, I created a small class called Flickr.  It inherits from DynamicObject and serves as our call dispatcher to Flickr’s REST API, which is available here: <span style="color:#a31515;"><a href="http://api.flickr.com/services/rest/">http://api.flickr.com/services/rest/</a></span>.  Here is the API documentation: <a title="http://www.flickr.com/services/api/" href="http://www.flickr.com/services/api/">http://www.flickr.com/services/api/</a>.  You can get API keys here: <a title="http://www.flickr.com/services/apps/create/apply" href="http://www.flickr.com/services/apps/create/apply">http://www.flickr.com/services/apps/create/apply</a>.

Each call you see in this TestMethod is actually to a method that does not exist in the definition of the Flickr class.

~~~ text
[TestMethod]
public void Testing_Flickr()
{
    dynamic flickr = new Flickr();

    var xml1 = flickr.people_findByUsername(username: "duncandavidson");

    var xml2 = flickr.collections_getTree(user_id: "59532755@N00");

    var xml3 = flickr.urls_getUserPhotos(user_id: 59532755@N00);
}
~~~

Each of these calls succeeds, and returns a response from Flickr’s service.  Note a few things about this code.  Flickr’s API has methods that look like this flickr.people.findByUsername and flickr.urls.getUserPhotos.  Notice the similarity above.  What I’ve done is replaced the dots with underscores, in order to make the functions legal C# method names.  As you’ll see below, we reformat the method name before attempting to call it on the remote Flickr service.  Additionally, note that we are using named parameters above in order to pass in both parameter name and parameter value to our ghost methods.  This allows us to pass any number of key-value paired parameters to any method name we want.  Here is the implementation of the Flickr class.

~~~ text
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Dynamic;
using System.Net;

public class Flickr : DynamicObject
{
    public override bool TryInvokeMember(InvokeMemberBinder binder, object[] args, out object result)
    {
        dynamic request;

        request = new Funcobject>(() =>
        {
            //format methodname
            var remoteMethodName = binder.Name.Replace('_', '.');

            //format parameters
            var queryStringBuilder = new StringBuilder();
            for (var i = 0; i "=" + args[i] + "&");
            }

            //build rest message
            var baseUrl = http://api.flickr.com/services/rest/;
            var message = string.Format(baseUrl + "?method=flickr.{0}&{1}api_key=YOUR_KEY_HERE",
                                        remoteMethodName,
                                        queryStringBuilder.ToString());


            //send
            var strResponse = new WebClient().DownloadString(message);

            //respond
            return strResponse;
        });

        result = (request as Delegate).DynamicInvoke(); //no need to pass args. they were set via closures above
        return true;
    }
}

~~~

As you can see, its DynamicObject’s TryInvokeMember method that is our seam for redelegating the call out to the web.   You may be asking yourself, why in the world would I want to do this.  The biggest advantage is that your local proxy API will always stay in sync with the Flickr service.  Even if they, extend the remote API I can call those methods without having to write a single line of additional plumbing code.  The reason is the responder to the call is not the actual Flickr class, but rather Flickr itself out on the web.  This seems simple and natural.  As it turns out, this type of runtime metaprogramming is becoming the preferred approach to interacting with cloud services via dynamic languages such as Python, Ruby, and JavaScript.  It enables applications to adapt to changes in one another&#8217;s interfaces automatically.   Now that C# has been endowed with dynamic, we can capitalize on the feature to build client-server apps that are less brittle and require little to no maintenance around the edges.  Perhaps best of all, the client api automatically already supports new behaviors immediately when they show up on the server.  Thats instant gratification for the extraordinarily low price of free.
