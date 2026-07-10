---
layout: post
title: "Creating a “Supernatural” Self-Adapting REST Proxy in C#"
date: 2011-04-20 23:43:38 -0500
categories: []
tags: []
wordpress_id: 154
original_url: "https://joelholder.com/2011/04/20/creating-a-ghostly-self-adapting-rest-proxy-in-c/"
---
<style>
.entry-content pre,
.entry-content code {
  white-space: pre-wrap;
  overflow-wrap: anywhere;
  word-break: break-word;
}
.entry-content table,
.entry-content img,
.entry-content iframe {
  max-width: 100%;
}
.entry-content {
  overflow-wrap: anywhere;
}
</style>


.NET 4.0’s DynamicObject provides a quick and easy way to hook into and control how a call for a method is dispatched at runtime.  This so called “late dispatch” capability is exactly what we need to easily create dynamic facades over out-of-process APIs, such as those of remote REST services.

In this post, I’ll show you how to take advantage of dynamic dispatch, in order to create an adaptive web agent that gets driven through a normal C# class API.  What I mean by normal, is that familiar dot syntax for calling methods from our objects.  However, in this case the methods we will be calling are not actually there; they are “<a href="http://www.timonv.nl/2011/01/18/unusual-ruby-metaprogramming-101-2-method" target="_blank">ghost methods</a>”.   They do not exist on the object whose receiving the call.  This might sound a bit strange to the uninitiated, but fear not, you’re about to get your secret decoder rings.  C#’s DynamicObject gives us the opportunity to delegate to remote service APIs transparently, without the knowledge or concern of the caller. 

To demonstrate this in action, I created a small class called Flickr.  It inherits from DynamicObject and serves as our call dispatcher to Flickr’s REST API, which is available here: <span style="color:#a31515;"><a href="http://api.flickr.com/services/rest/">http://api.flickr.com/services/rest/</a></span>.  Here is the API documentation: <a title="http://www.flickr.com/services/api/" href="http://www.flickr.com/services/api/">http://www.flickr.com/services/api/</a>.  You can get API keys here: <a title="http://www.flickr.com/services/apps/create/apply" href="http://www.flickr.com/services/apps/create/apply">http://www.flickr.com/services/apps/create/apply</a>.

Each call you see in this TestMethod is actually to a method that does not exist in the definition of the Flickr class.
<pre style="font-family:consolas;">[<span style="color:#2b91af;">TestMethod</span>]
<span style="color:blue;">public</span> <span style="color:blue;">void</span> Testing_Flickr()
{
    <span style="color:blue;">dynamic</span> flickr = <span style="color:blue;">new</span> <span style="color:#2b91af;">Flickr</span>();
 
    <span style="color:blue;">var</span> xml1 = flickr.people_findByUsername(username: <span style="color:#a31515;">"duncandavidson"</span>);
 
    <span style="color:blue;">var</span> xml2 = flickr.collections_getTree(user_id: <span style="color:#a31515;">"59532755@N00"</span>);
 
    <span style="color:blue;">var</span> xml3 = flickr.urls_getUserPhotos(user_id: <span style="color:#a31515;"><a href="mailto:59532755@N00">59532755@N00</a></span>);
}</pre>
Each of these calls succeeds, and returns a response from Flickr’s service.  Note a few things about this code.  Flickr’s API has methods that look like this flickr.people.findByUsername and flickr.urls.getUserPhotos.  Notice the similarity above.  What I’ve done is replaced the dots with underscores, in order to make the functions legal C# method names.  As you’ll see below, we reformat the method name before attempting to call it on the remote Flickr service.  Additionally, note that we are using named parameters above in order to pass in both parameter name and parameter value to our ghost methods.  This allows us to pass any number of key-value paired parameters to any method name we want.  Here is the implementation of the Flickr class.
<pre><span style="font-family:consolas;color:blue;">using</span><span style="font-family:consolas;"> System;
<span style="color:blue;">using</span> System.Collections.Generic;
<span style="color:blue;">using</span> System.Linq;
<span style="color:blue;">using</span> System.Text;
<span style="color:blue;">using</span> System.Dynamic;
<span style="color:blue;">using</span> System.Net;
 
<span style="color:blue;">public</span> <span style="color:blue;">class</span> <span style="color:#2b91af;">Flickr</span> : <span style="color:#2b91af;">DynamicObject</span>
{
    <span style="color:blue;">public</span> <span style="color:blue;">override</span> <span style="color:blue;">bool</span> TryInvokeMember(<span style="color:#2b91af;">InvokeMemberBinder</span> binder, <span style="color:blue;">object</span>[] args, <span style="color:blue;">out</span> <span style="color:blue;">object</span> result)
    {
        <span style="color:blue;">dynamic</span> request;
 
        request = <span style="color:blue;">new</span> <span style="color:#2b91af;">Func</span><<span style="color:blue;">object</span>>(() =>
        {
            <span style="color:green;">//format methodname</span>
            <span style="color:blue;">var</span> remoteMethodName = binder.Name.Replace(<span style="color:#a31515;">'_'</span>, <span style="color:#a31515;">'.'</span>);
 
            <span style="color:green;">//format parameters</span>
            <span style="color:blue;">var</span> queryStringBuilder = <span style="color:blue;">new</span> <span style="color:#2b91af;">StringBuilder</span>();
            <span style="color:blue;">for</span> (<span style="color:blue;">var</span> i = 0; i < binder.CallInfo.ArgumentNames.Count; i++)
            {
                queryStringBuilder.Append(binder.CallInfo.ArgumentNames[i] + <span style="color:#a31515;">"="</span> + args[i] + <span style="color:#a31515;">"&"</span>);
            }
 
            <span style="color:green;">//build rest message</span>
            <span style="color:blue;">var</span> baseUrl = <span style="color:#a31515;"><a href="http://api.flickr.com/services/rest/">http://api.flickr.com/services/rest/</a></span>;
            <span style="color:blue;">var</span> message = <span style="color:blue;">string</span>.Format(baseUrl + <span style="color:#a31515;">"?method=flickr.{0}&{1}api_key=YOUR_KEY_HERE"</span>,
                                        remoteMethodName,
                                        queryStringBuilder.ToString());
 

            <span style="color:green;">//send</span>
            <span style="color:blue;">var</span> strResponse = <span style="color:blue;">new</span> <span style="color:#2b91af;">WebClient</span>().DownloadString(message);
 
            <span style="color:green;">//respond</span>
            <span style="color:blue;">return</span> strResponse;
        });
 
        result = (request <span style="color:blue;">as</span> <span style="color:#2b91af;">Delegate</span>).DynamicInvoke(); <span style="color:green;">//no need to pass args. they were set via closures above</span>
        <span style="color:blue;">return</span> <span style="color:blue;">true</span>;
    }
}
 </span></pre>
As you can see, its DynamicObject’s TryInvokeMember method that is our seam for redelegating the call out to the web.   You may be asking yourself, why in the world would I want to do this.  The biggest advantage is that your local proxy API will always stay in sync with the Flickr service.  Even if they, extend the remote API I can call those methods without having to write a single line of additional plumbing code.  The reason is the responder to the call is not the actual Flickr class, but rather Flickr itself out on the web.  This seems simple and natural.  As it turns out, this type of runtime metaprogramming is becoming the preferred approach to interacting with cloud services via dynamic languages such as Python, Ruby, and JavaScript.  It enables applications to adapt to changes in one another&#8217;s interfaces automatically.   Now that C# has been endowed with dynamic, we can capitalize on the feature to build client-server apps that are less brittle and require little to no maintenance around the edges.  Perhaps best of all, the client api automatically already supports new behaviors immediately when they show up on the server.  Thats instant gratification for the extraordinarily low price of free.
