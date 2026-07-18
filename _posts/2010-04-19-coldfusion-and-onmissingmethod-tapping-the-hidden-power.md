---
layout: post
title: "ColdFusion and onMissingMethod – Tapping The Hidden Power"
date: 2010-04-19 00:47:27 -0500
categories: []
tags: []
wordpress_id: 7
original_url: "https://joelholder.com/2010/04/19/coldfusion-and-onmissingmethod-tapping-the-hidden-power/"
---

Recently I had to do some work in ColdFusion. In the midst of the pain, imagine my surprise and delight to find that CF components support a dynamic dispatch construct. While unsightly, you can create wormholes and drop call routing through them.

It works like this. When you attempt a method call against a .cfc and the method does not exist, CF automatically calls a method called "onMissingMethod". You must implement this method of course, otherwise CF dutifully errors. With this done, you have a seam to redispatch the call to another method in the .cfc, or send the the call to another component all together, such as a ResponseLocator that could resolve the message to some external responder. This is the tip of the metaprogramming capability buried in CF, and its quite nice once you deal with the initial abstraction. Having done this a bit now, I prefer to use a dynamic base component from which I extend the other components. My base.cfc has an onMissingMethod that looks for the presence of a well known named service locator component. If its there, it passes any method calls that it cannot resolve locally to a "forwardingContext" component. This allows us to externalize the logic for finding the resolver as well as opens up our ability to have it proxy objects that are proxied by other facades.

Here's the implementation of base.cfc:

```cfscript
<cfcomponent>

    <cfset  forwardContext=createObject("component", "responderLocator")>

    <!--- method_missing: pass the dispatch to a service locator to lookup receiver --->
    <cffunction name="onMissingMethod" access="public" returnType="any" output="true" description="DELEGATE TO A FORWARDCONTEXT OBJECT">

        <cfargument name="missingMethodName" type="string" required="true">
        <cfargument name="missingMethodArguments" type="struct" required="true">
        <cfset var local = {} />
        <cfset local.returnValue = "" />

        <cfif IsDefined("forwardContext")>
            <cfif StructKeyExists(forwardContext, arguments.missingMethodName)>
                <cfset local.meta = getMetadata(forwardContext[arguments.missingMethodName]) />
                <cfset local.i = 1 />
                <cfinvoke component="#forwardContext#" method="#arguments.missingMethodName#" returnvariable="local.returnValue">
                        <cfloop array="#arguments.missingMethodArguments#" index="local.arg">
                            <cfinvokeargument name="#local.meta.parameters[local.i++].name#" value="#local.arg#">
                        </cfloop>
                  </cfinvoke>
            <cfelse>
                <cfinvoke component="#forwardContext#" method="#Arguments.missingMethodName#" argumentcollection="#Arguments.missingMethodArguments#" returnvariable="local.returnValue" />
            </cfif>
        <cfelse>
            <cfset arguments.missingMethodArguments.calledMethodName = Arguments.missingMethodName />
            <cfdump var="#arguments.missingMethodArguments#" expand="yes" label="MISSING METHOD ARGUMENTS" />
        </cfif>

        <cfreturn local.returnValue />

        <cfif NOT StructKeyExists(local,"returnValue")>
            <cfset local.returnValue = "" />
        </cfif>

        <cfreturn local.returnValue />

    </cffunction>

</cfcomponent>
```

A simple responderLocator.cfc could look like this (note that in this case I've put the method being proxied directly on to it, so it does not have to pass the call elsewhere):

```cfscript
<cfcomponent>

    <cffunction name="onMissingMethod" access="public" returnType="any" output="false">
        <cfargument name="missingMethodName" type="string" required="true">
        <cfargument name="missingMethodArguments" type="struct" required="true">
        <cfset tmpReturn = "">
         <cfset functionToCallName = Arguments.missingMethodName>
         <cfset arguments.missingMethodArguments.calledMethodName = Arguments.missingMethodName>
        <cfscript>
            dump(missingMethodArguments, true);
        </cfscript>
        <cfreturn tmpReturn>
    </cffunction>

    <cffunction name="DontExist" access="public" returnType="any" output="false">
        <cfargument name="data" required="true">
        <!--- ECHO BACK FOR EXAMPLE --->
        <cfreturn "You sent me: " & data>
    </cffunction>

    <cffunction name="dump">
        <cfargument name="data" required="true">
        <cfargument name="bAbort" required="false" default="0">
        <cfdump var="#arguments.data#">
        <cfif arguments.bAbort eq 1>
            <cfabort>
        </cfif>
        <cfreturn true>
    </cffunction>

</cfcomponent>
```

Given the above implementation of the responderLocator, I can expect to call a method called "DontExist" on base.cfc or one extended from it that does not have the method, it would pass the call to reponderLocator and expect it to respond. Base.cfc would then pass the response back to the caller. Here's an example:

```cfscript
<cfscript>
    myCfc = createObject("component","base"); <!--- or some component derived from base.cfc --->
    myVal = myCfc.dontExist("foo");
</cfscript>
```

In this case, myVal will equal "**You sent me: foo**", which demonstrates that the call to DontExist was delegated to responderLocator, invoked, and returned to this calling code.

This is a fairly contrived example just to show the pattern off in its simplest form. Beefier implementations might use an Array of responseLocators and loop through them trying to resolve the call. Additionally, note that if **all** the components participating in the pattern are extended from base.cfc, and each has its own spools of locators, you can see how the call resolution attempts could spread across potentially hundreds of components until a responder was located.

Pretty nifty feature.. Enjoy..
