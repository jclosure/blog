---
layout: post
title: "Symmetric Hashing With .NET Crypto Service Providers and COM Interop"
date: 2008-12-31 20:05:53 -0600
categories: []
tags: []
wordpress_id: 20
original_url: "https://joelholder.com/2008/12/31/symmetric-hashing-with-net-crypto-service-providers-and-com-interop/"
---
<div id="msgcns!3FC3980D58CF7EFB!465" class="bvMsg">
<div>I wrote the DotNetCryptoCOM (DNCC) library because I  wanted to be able to generate and reverse cypher text between .NET and COM applications using a single .dll.  It allows developers to drive the builtin .NET Cryptographic Service Providers with a simple API.  I&#8217;ve used this lib in VB, Managed C++, and of course C# applications.  Some of you may find it useful as well.</div>
<div> </div>
<div>A few notes of interest:</div>
<div> </div>
<div>1.  If you plan to use it from COM apps, you&#8217;ll need to do the following from a cmd shell: <font size="2"></p>
<p>(hint, use a Visual Studio Shell to have the path var in your env setup properly)</font><font size="2"></font></div>
<div>
<p>     copy DotNetCryptoCOM.dll  %windir%\system32 </p>
<p>     cd %windir%\system32 </p>
<p>     regasm %windir%\system32\DotNetCryptoCOM.dll /tlb:DotNetCryptoCOM.tlb </p>
<p>     gacutil /i DotNetCryptoCOM.dll </p>
<p>2.  If you plan to use it in Classic ASP apps, you&#8217;ll also need to remember to configure IIS to support ASP pages and from a cmd shell type: </p>
<p>     iisreset. </p>
<p>Now, I present a brief sample that shows how to use DNCC.  </p>
<p>First, I&#8217;ll encrypt some text in VBScript with it: </p>
<p>&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8211; </p>
<p><font color="#008000" size="2"><font color="#008000" size="2">&#8216; Set raw text<font color="#008000" size="2"><font color="#008000" size="2"><font color="#0000ff" size="2"><font color="#0000ff" size="2"> </p>
<p>Dim</p>
<p></font></font><font size="2"><font color="#000000"> strRawData <font size="2"></p>
<p>strRawData = </p>
<p></font><font color="#a31515" size="2"><font color="#a31515" size="2">&#8220;super secret message&#8221;</font></font></font></font></font></font></font></font></p>
</div>
<p><font size="2"><font color="#008000">&#8216; Set secret key<font color="#008000" size="2"><font color="#008000" size="2"><font color="#0000ff" size="2"><font color="#0000ff" size="2"> </p>
<p>Dim</font></font><font size="2"><font color="#000000"> strKey<font size="2"> </p>
<p>strKey = </font><font color="#a31515" size="2"><font color="#a31515" size="2">&#8220;shhhh&#8221;</font></font></font></font></font></font></font></font>   </p>
<p><font size="2"><font color="#008000" size="2"><font color="#008000" size="2">&#8216; Set an instance of the CryptoProvider</font></font><font size="2"> </p>
<p></font><font color="#0000ff" size="2"><font color="#0000ff" size="2">Set</font></font><font size="2"> <font color="#000000">dncc = CreateObject(</font></font><font color="#a31515" size="2"><font color="#a31515" size="2">&#8220;DotNetCryptoCOM.CryptoClass&#8221;</font></font><font size="2"><font color="#000000">)</font> </p>
<p></font><font color="#008000" size="2"><font color="#008000" size="2">&#8216; Encrypt the data with key</font></font><font color="#000000" size="2"> </p>
<p>strEncryptedData = dncc.Encrypt(strRawData, strKey)</p>
<p></font> </p>
<p>&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8211; </p>
<p>Now assume you&#8217;ve provided strEncryptedData to a C# .NET application. </p>
<p>&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8211;<font color="#0000ff" size="2"><font color="#0000ff" size="2"> </p>
<p>string</p>
<p></font></font><font color="#000000" size="2"> secretKey = </font><font color="#a31515" size="2"><font color="#a31515" size="2">&#8220;shhhh&#8221;</font></font><font size="2"><font color="#000000">;</font></font><font size="2"> </p>
<p><font color="#000000">DotNetCryptoCOM.</font></p>
<p></font><font color="#2b91af" size="2"><font color="#2b91af" size="2">CryptoClass</font></font><font color="#000000" size="2"> dncc = </font><font color="#0000ff" size="2"><font color="#0000ff" size="2">new</font></font><font size="2"> <font color="#000000">DotNetCryptoCOM.</font></font><font color="#2b91af" size="2"><font color="#2b91af" size="2">CryptoClass</font></font><font size="2">();</font><font color="#0000ff" size="2"><font color="#0000ff" size="2"><font color="#0000ff" size="2"><font color="#0000ff" size="2"> </p>
<p>string</p>
<p></font></font><font size="2"><font color="#000000"> strRawData </font><font color="#000000">=</font></font></font></font><font color="#000000" size="2"> dncc.Decrypt(strEncryptedData, secretKey);</font> </p>
<p><font size="2">&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8212;&#8211;</font> </p>
<p>Voila..  Secure trip between domains.  Note, the default Cryptographic Service Provider is DES. </p>
<p>If you&#8217;re interested in DNCC&#8217;s internal implementation, I&#8217;ll leave that to your curiosity and <a href="http://www.red-gate.com/products/reflector/" target="_blank">reflector</a>.  </p>
<p>Its really pretty straight forward if you take a look inside&#8230; </p>
<p>I have provided the DNCC library for download <a href="http://cid-3fc3980d58cf7efb.skydrive.live.com/self.aspx/Public/DotNetCryptoCOM.dll" target="_blank">here</a>. </p>
<p>A more complete example of an ASP to ASP.NET shared authentication solution uses it <a href="http://cid-3fc3980d58cf7efb.skydrive.live.com/self.aspx/Public/DotNetCryptoCOMSpike.zip" target="_blank">here</a>. </p>
<p>Happy hashing and best of luck..</p>
</p>
</p>
</p>
</p>
<p></font></p>
</p>
</div>
