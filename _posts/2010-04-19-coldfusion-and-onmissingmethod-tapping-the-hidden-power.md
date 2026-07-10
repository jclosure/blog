---
layout: post
title: "ColdFusion and onMissingMethod – Tapping The Hidden Power"
date: 2010-04-19 00:47:27 -0500
categories: []
tags: []
wordpress_id: 7
original_url: "https://joelholder.com/2010/04/19/coldfusion-and-onmissingmethod-tapping-the-hidden-power/"
---
<p>Recently I had to do some work in ColdFusion.  In the midst of the pain, imagine my surprise and delight to find that CF components support a dynamic dispatch construct. While unsightly, you can create wormholes and drop call routing through them</p>
<p>It works like this.  When you attempt a method call against a .cfc and the method does not exist, CF automatically calls a method called “onMissingMethod”.  You must implement this method of course, otherwise CF dutifully errors. With this done, you have a seam to redispatch the call to another method in the .cfc, or send the the call to another component all together, such as a ResponseLocator that could resolve the message to some external responder.  This is the tip of the metaprogramming capability buried in CF, and its quite nice once you deal with the initial abstraction.  Having done this a bit now, I prefer to use a dynamic base component from which I extend the other components. My base.cfc has an onMissingMethod that looks for the presence of a well known named service locator component.  If its there, it passes any method calls that it cannot resolve locally to a “forwardingContext” component.  This allows us to externalize the logic for finding the resolver as well as opens up our ability to have it proxy objects that are proxied by other facades.</p>
<p>Here’s the implementation of base.cfc:</p>
<pre class="brush: coldfusion; title: ; notranslate" title="">
&lt;cfcomponent&gt;

    &lt;cfset  forwardContext=createObject(&quot;component&quot;, &quot;responderLocator&quot;)&gt;

    &lt;!--- method_missing: pass the dispatch to a service locator to lookup receiver ---&gt;
    &lt;cffunction name=&quot;onMissingMethod&quot; access=&quot;public&quot; returnType=&quot;any&quot; output=&quot;true&quot; description=&quot;DELEGATE TO A FORWARDCONTEXT OBJECT&quot;&gt;

        &lt;cfargument name=&quot;missingMethodName&quot; type=&quot;string&quot; required=&quot;true&quot;&gt;
        &lt;cfargument name=&quot;missingMethodArguments&quot; type=&quot;struct&quot; required=&quot;true&quot;&gt;
        &lt;cfset var local = {} /&gt;
        &lt;cfset local.returnValue = &quot;&quot; /&gt;

        &lt;cfif IsDefined(&quot;forwardContext&quot;)&gt;
            &lt;cfif StructKeyExists(forwardContext, arguments.missingMethodName)&gt;
                &lt;cfset local.meta = getMetadata(forwardContext&amp;#91;arguments.missingMethodName&amp;#93;) /&gt;
                &lt;cfset local.i = 1 /&gt;
                &lt;cfinvoke component=&quot;#forwardContext#&quot; method=&quot;#arguments.missingMethodName#&quot; returnvariable=&quot;local.returnValue&quot;&gt;
                        &lt;cfloop array=&quot;#arguments.missingMethodArguments#&quot; index=&quot;local.arg&quot;&gt;
                            &lt;cfinvokeargument name=&quot;#local.meta.parameters&amp;#91;local.i++&amp;#93;.name#&quot; value=&quot;#local.arg#&quot;&gt;
                        &lt;/cfloop&gt;
                  &lt;/cfinvoke&gt;
            &lt;cfelse&gt;
                &lt;cfinvoke component=&quot;#forwardContext#&quot; method=&quot;#Arguments.missingMethodName#&quot; argumentcollection=&quot;#Arguments.missingMethodArguments#&quot; returnvariable=&quot;local.returnValue&quot; /&gt;
            &lt;/cfif&gt;
        &lt;cfelse&gt;
            &lt;cfset arguments.missingMethodArguments.calledMethodName = Arguments.missingMethodName /&gt;
            &lt;cfdump var=&quot;#arguments.missingMethodArguments#&quot; expand=&quot;yes&quot; label=&quot;MISSING METHOD ARGUMENTS&quot; /&gt;
        &lt;/cfif&gt;

        &lt;cfreturn local.returnValue /&gt;

        &lt;cfif NOT StructKeyExists(local,&quot;returnValue&quot;)&gt;
            &lt;cfset local.returnValue = &quot;&quot; /&gt;
        &lt;/cfif&gt;

        &lt;cfreturn local.returnValue /&gt;

    &lt;/cffunction&gt;

&lt;/cfcomponent&gt;
</pre>
<p>A simple responderLocator.cfc could look like this (note that in this case I’ve put the method being proxied directly on to it, so it does not have to pass the call elsewhere):</p>
<pre class="brush: coldfusion; title: ; notranslate" title="">
&lt;cfcomponent&gt;

    &lt;cffunction name=&quot;onMissingMethod&quot; access=&quot;public&quot; returnType=&quot;any&quot; output=&quot;false&quot;&gt;
        &lt;cfargument name=&quot;missingMethodName&quot; type=&quot;string&quot; required=&quot;true&quot;&gt;
        &lt;cfargument name=&quot;missingMethodArguments&quot; type=&quot;struct&quot; required=&quot;true&quot;&gt;
        &lt;cfset tmpReturn = &quot;&quot;&gt;
         &lt;cfset functionToCallName = Arguments.missingMethodName&gt;
         &lt;cfset arguments.missingMethodArguments.calledMethodName = Arguments.missingMethodName&gt;
        &lt;cfscript&gt;
            dump(missingMethodArguments, true);
        &lt;/cfscript&gt;
        &lt;cfreturn tmpReturn&gt;
    &lt;/cffunction&gt;

    &lt;cffunction name=&quot;DontExist&quot; access=&quot;public&quot; returnType=&quot;any&quot; output=&quot;false&quot;&gt;
        &lt;cfargument name=&quot;data&quot; required=&quot;true&quot;&gt;
        &lt;!--- ECHO BACK FOR EXAMPLE ---&gt;
        &lt;cfreturn &quot;You sent me: &quot; &amp; data&gt;
    &lt;/cffunction&gt;

    &lt;cffunction name=&quot;dump&quot;&gt;
        &lt;cfargument name=&quot;data&quot; required=&quot;true&quot;&gt;
        &lt;cfargument name=&quot;bAbort&quot; required=&quot;false&quot; default=&quot;0&quot;&gt;
        &lt;cfdump var=&quot;#arguments.data#&quot;&gt;
        &lt;cfif arguments.bAbort eq 1&gt;
            &lt;cfabort&gt;
        &lt;/cfif&gt;
        &lt;cfreturn true&gt;
    &lt;/cffunction&gt;

&lt;/cfcomponent&gt;
</pre>
<p>Given the above implementation of the responderLocator, I can expect to call a method called “DontExist” on base.cfc or one extended from it that does not have the method, it would pass the call to reponderLocator and expect it to respond.  Base.cfc would then pass the response back to the caller.Here’s an example:</p>
<pre class="brush: coldfusion; title: ; notranslate" title="">
&lt;cfscript&gt;
    myCfc = createObject(&quot;component&quot;,&quot;base&quot;); &lt;!--- or some component derived from base.cfc ---&gt;
    myVal = myCfc.dontExist(&quot;foo&quot;);
&lt;/cfscript&gt;
</pre>
<p>In this case, myVal will equal “<strong>You sent me: foo</strong>”, which demonstrates that the call to DontExist was delegated to responderLocator, invoked, and returned to this calling code.</p>
<p>This is a fairly contrived example just to show the pattern off in its simplest form.  Beefier implementations might use an Array of responseLocators and loop through them trying to resolve the call.  Additionally, note that if <strong>all</strong> the components participating in the pattern are extended from base.cfc, and each has its own spools of locators, you can see how the call resolution attempts could spread across potentially hundreds of components until a responder was located.</p>
<p>Pretty nifty feature..  Enjoy..</p>
