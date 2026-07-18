---
layout: post
title: "Symmetric Hashing With .NET Crypto Service Providers and COM Interop"
date: 2008-12-31 20:05:53 -0600
categories: []
tags: []
wordpress_id: 20
original_url: "https://joelholder.com/2008/12/31/symmetric-hashing-with-net-crypto-service-providers-and-com-interop/"
---

I wrote the DotNetCryptoCOM (DNCC) library because I wanted to be able to generate and reverse cypher text between .NET and COM applications using a single .dll. It allows developers to drive the builtin .NET Cryptographic Service Providers with a simple API. I've used this lib in VB, Managed C++, and of course C# applications. Some of you may find it useful as well.

A few notes of interest:

1. If you plan to use it from COM apps, you'll need to do the following from a cmd shell (hint, use a Visual Studio Shell to have the path var in your env setup properly):

```
copy DotNetCryptoCOM.dll  %windir%\system32
cd %windir%\system32
regasm %windir%\system32\DotNetCryptoCOM.dll /tlb:DotNetCryptoCOM.tlb
gacutil /i DotNetCryptoCOM.dll
```

2. If you plan to use it in Classic ASP apps, you'll also need to remember to configure IIS to support ASP pages and from a cmd shell type:

```
iisreset.
```

Now, I present a brief sample that shows how to use DNCC.

First, I'll encrypt some text in VBScript with it:

```vbscript
' Set raw text
Dim strRawData
strRawData = "super secret message"

' Set secret key
Dim strKey
strKey = "shhhh"

' Set an instance of the CryptoProvider
Set dncc = CreateObject("DotNetCryptoCOM.CryptoClass")
' Encrypt the data with key
strEncryptedData = dncc.Encrypt(strRawData, strKey)
```

Now assume you've provided strEncryptedData to a C# .NET application.

```csharp
string secretKey = "shhhh";
DotNetCryptoCOM.CryptoClass dncc = new DotNetCryptoCOM.CryptoClass();
string strRawData = dncc.Decrypt(strEncryptedData, secretKey);
```

Voila.. Secure trip between domains. Note, the default Cryptographic Service Provider is DES.

If you're interested in DNCC's internal implementation, I'll leave that to your curiosity and [reflector](http://www.red-gate.com/products/reflector/).

Its really pretty straight forward if you take a look inside...

I have provided the DNCC library for download [here](http://cid-3fc3980d58cf7efb.skydrive.live.com/self.aspx/Public/DotNetCryptoCOM.dll).

A more complete example of an ASP to ASP.NET shared authentication solution uses it [here](http://cid-3fc3980d58cf7efb.skydrive.live.com/self.aspx/Public/DotNetCryptoCOMSpike.zip).

Happy hashing and best of luck..
