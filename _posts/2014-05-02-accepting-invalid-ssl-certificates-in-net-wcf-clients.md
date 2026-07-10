---
layout: post
title: "Accepting Invalid SSL Certificates in .NET WCF Clients"
date: 2014-05-02 16:35:53 -0500
categories: []
tags: ["C#", "SSL", "WCF"]
wordpress_id: 605
original_url: "https://joelholder.com/2014/05/02/accepting-invalid-ssl-certificates-in-net-wcf-clients/"
---
<p>There are times when SSL certificates are used to verify identity and to provide TLS and there are cases when only the wire encryption matters.  In the later case, I sometimes need to be able handle server certificates that are not valid by SSL&#8217;s standard rules.  This could be because the cert is not signed by a trusted certificate authority or is expired, etc.  When I encounter this problem and am for various reasons unable to deal with the root cause, there is a simple technique that allows you to plug in your own strategy to determine certificate validity.</p>
<p>Basically you do the following:</p>
<ul>
<li>In a seam of bootstrapping code, you&#8217;ll want to add a ServerCertificateValidationCallback to the WCF ServicePointManager</li>
</ul>
<p>Here&#8217;s a working example that accepts any SSL Certificate as valid:</p>

~~~ csharp
ServicePointManager.ServerCertificateValidationCallback =
     (object sender, X509Certificate cert, X509Chain chain, SslPolicyErrors errors)
          => true;
~~~

<p>With this patched strategy in place, your WCF client will now accept any SSL certificate its given. Note that, in the lambda body, you can put in your own logic to interrogate the parameters for what you consider to be acceptable:</p>
<p>X509Certificate cert</p>
<p>X509Chain chain</p>
<p>SslPolicyErrors errors</p>
<p>The logic applied can be more or less rigorous than the default certificate validation strategy.  The beauty of this approach is in the power of its simple implementation.</p>
<p>Enjoy..</p>
