---
layout: post
title: "Object Bakery – Fun with .NET Serialization and Crypto: Part 1"
date: 2009-01-12 21:22:13 -0600
categories: []
tags: []
wordpress_id: 14
original_url: "https://joelholder.com/2009/01/12/object-bakery-fun-with-net-serialization-and-crypto-part-1/"
---
<div id="msgcns!3FC3980D58CF7EFB!475" class="bvMsg">
<p style="margin:0 0 10pt;"><font size="3"><font color="#000000"><font face="Calibri">Being able to snapshot an object graph at runtime can be a valuable capability.<span>  </span>I have had occasion to capture objects during a run for the purpose of analyzing and debugging problems that require comparison across multiple runs.<span>  </span>Additionally, the power to dehydrate objects and store them in a disk based cache, can also prove quite useful in certain scenarios.<span>  </span>Some other capabilities include capturing archetypal object instances to file and adding them as embedded resources to test projects to serve as <span> </span>stubs and/or test doubles.<span>  </span>Some other ways to work with objects offline might include sending dehydrated objects through FTP, Email , Message Queues, etc.<span>  </span>I present here a few helper classes that I have used for the purposes described and more.<span>  </span></font></font></font></p>
<p style="margin:0 0 10pt;"><font color="#000000" size="3" face="Calibri">First, when security is not a concern, serialization to plain text Xml can be an effective means of quick object dehydration.<span>  </span>I wrote the SerializationHelper for this purpose.<span>  </span>Below is a test that demonstrates instancing a serializable entity class (a Product), converting it to an Xml string representation, and converting the string back into an object. </font></p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><font color="#000000"><span>        </span>[</font><span style="color:#2b91af;">TestMethod</span><font color="#000000">]</font></span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span><font color="#000000">        </font></span><span style="color:blue;">public</span><font color="#000000"> </font><span style="color:blue;">void</span><font color="#000000"> CanSerializeToandFromXml()</font></span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><font color="#000000"><span>        </span>{</font></span> </p>
<p style="line-height:normal;text-indent:.5in;margin:0 0 0 .5in;"><span style="font-family:'Courier New';color:#2b91af;font-size:10pt;">Product</span><span style="font-family:'Courier New';font-size:10pt;"><font color="#000000"> product1 = </font><span style="color:blue;">new</span><font color="#000000"> </font><span style="color:#2b91af;">TestProductFactory</span><font color="#000000">().Build()[0];</font></span> </p>
<p style="margin:0 0 10pt;"><span style="line-height:115%;font-family:'Courier New';color:#2b91af;font-size:10pt;">            SerializationHelper</span><span style="line-height:115%;font-family:'Courier New';font-size:10pt;"><font color="#000000"> serializationHelper = </font><span style="color:blue;">new</span><font color="#000000"> </font><span style="color:#2b91af;">SerializationHelper</span><font color="#000000">();</font></span> </p>
<p style="margin:0 0 10pt;"><span style="line-height:115%;font-family:'Courier New';font-size:10pt;"><font color="#000000">            </font></span><span style="font-family:'Courier New';font-size:10pt;"><span style="color:blue;">string</span><font color="#000000"> sProduct1 = </font><span style="color:#2b91af;"><span style="color:#2b91af;"><font color="#000000">serializationHelper</font></span></span><font color="#000000">.XmlSerialize(product1);</font></span> <span style="font-family:'Courier New';font-size:10pt;"><span style="color:#2b91af;"></p>
<p style="margin:0 0 10pt;"><span style="line-height:115%;font-family:'Courier New';color:#2b91af;font-size:10pt;">            Product</span><span style="line-height:115%;font-family:'Courier New';font-size:10pt;"><font color="#000000"> product2 = serializationHelper.XmlDeserialize<</font><span style="color:#2b91af;">Product</span><font color="#000000">>(sProduct1);</font></span></span></span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span><font color="#000000">            </font></span><span style="color:#2b91af;">XmlDocument</span><font color="#000000"> testLoadDoc = </font><span style="color:blue;">new</span><font color="#000000"> </font><span style="color:#2b91af;">XmlDocument</span><font color="#000000">();</font></span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><font color="#000000"><span>            </span>testLoadDoc.LoadXml(sProduct1); </font><span style="color:green;">//throws exception if not well formed</span></span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';color:green;font-size:10pt;"> </span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span><font color="#000000">            </font></span><span style="color:#2b91af;">Assert</span><font color="#000000">.IsTrue(product1.ID.Equals(product2.ID) &#038;&#038; </font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><font color="#000000">                    product1.Name.Equals(product2.Name));</font></span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><font color="#000000"> </font></span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span><font color="#000000">            </font></span><span style="color:green;">//the products themselves are not the same instance, but instead deep copies</span></span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span><font color="#000000">            </font></span><span style="color:#2b91af;">Assert</span><font color="#000000">.IsFalse(product1.Equals(product2));</font></span> </p>
<p style="margin:0 0 10pt;"><span style="line-height:115%;font-family:'Courier New';font-size:10pt;"><font color="#000000"><span>        </span>}</font></span> </p>
<p style="margin:0 0 10pt;"><font color="#000000" size="3" face="Calibri">As you can see the assertions, show that the two Product objects have the same data, but they are in fact not the same object.<span>  </span>With this we have created a deep copy of the original product as it makes it through the round trip.<span>  </span>The dehydrated Product looks in this case looks something like this:</font> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';color:blue;font-size:10pt;"><?</span><span style="font-family:'Courier New';color:#a31515;font-size:10pt;">xml</span><span style="font-family:'Courier New';color:blue;font-size:10pt;"> </span><span style="font-family:'Courier New';color:red;font-size:10pt;">version</span><span style="font-family:'Courier New';color:blue;font-size:10pt;">=</span><span style="font-family:'Courier New';font-size:10pt;"><font color="#000000">&#8220;</font><span style="color:blue;">1.0</span><font color="#000000">&#8220;</font><span style="color:blue;">?></span></span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';color:blue;font-size:10pt;"><</span><span style="font-family:'Courier New';color:#a31515;font-size:10pt;">Product</span><span style="font-family:'Courier New';color:blue;font-size:10pt;"> </span><span style="font-family:'Courier New';color:red;font-size:10pt;">xmlns:xsi</span><span style="font-family:'Courier New';color:blue;font-size:10pt;">=</span><span style="font-family:'Courier New';font-size:10pt;"><font color="#000000">&#8220;</font><span style="color:blue;"><a href="http://www.w3.org/2001/XMLSchema-instance" rel="nofollow">http://www.w3.org/2001/XMLSchema-instance</a></span><font color="#000000">&#8220;</font><span style="color:blue;"> </span><span style="color:red;">xmlns:xsd</span><span style="color:blue;">=</span><font color="#000000">&#8220;</font><span style="color:blue;"><a href="http://www.w3.org/2001/XMLSchema" rel="nofollow">http://www.w3.org/2001/XMLSchema</a></span><font color="#000000">&#8220;</font><span style="color:blue;">></span></span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';color:blue;font-size:10pt;"><span>  </span><</span><span style="font-family:'Courier New';color:#a31515;font-size:10pt;">ID</span><span style="font-family:'Courier New';color:blue;font-size:10pt;">></span><span style="font-family:'Courier New';font-size:10pt;"><font color="#000000">1</font><span style="color:blue;"></</span><span style="color:#a31515;">ID</span><span style="color:blue;">></span></span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';color:blue;font-size:10pt;"><span>  </span><</span><span style="font-family:'Courier New';color:#a31515;font-size:10pt;">SKU</span><span style="font-family:'Courier New';color:blue;font-size:10pt;">></span><span style="font-family:'Courier New';font-size:10pt;"><font color="#000000">fa8f0777-74e7-4aeb-926f-a554b5dc191e</font><span style="color:blue;"></</span><span style="color:#a31515;">SKU</span><span style="color:blue;">></span></span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';color:blue;font-size:10pt;"><span>  </span><</span><span style="font-family:'Courier New';color:#a31515;font-size:10pt;">Name</span><span style="font-family:'Courier New';color:blue;font-size:10pt;">></span><span style="font-family:'Courier New';font-size:10pt;"><font color="#000000">Monkey</font><span style="color:blue;"></</span><span style="color:#a31515;">Name</span><span style="color:blue;">></span></span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';color:blue;font-size:10pt;"><span>  </span><</span><span style="font-family:'Courier New';color:#a31515;font-size:10pt;">Description</span><span style="font-family:'Courier New';color:blue;font-size:10pt;">></span><span style="font-family:'Courier New';font-size:10pt;"><font color="#000000">Squirrel Monkey.<span>  Aggressive</span> disposition.  Likes icecream and hugs.</font><span style="color:blue;"></</span><span style="color:#a31515;">Description</span><span style="color:blue;">></span></span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';color:blue;font-size:10pt;"><span>  </span><</span><span style="font-family:'Courier New';color:#a31515;font-size:10pt;">Assets</span><span style="font-family:'Courier New';color:blue;font-size:10pt;">></span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';color:blue;font-size:10pt;"><span>    </span><</span><span style="font-family:'Courier New';color:#a31515;font-size:10pt;">Asset</span><span style="font-family:'Courier New';color:blue;font-size:10pt;">></span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';color:blue;font-size:10pt;"><span>      </span><</span><span style="font-family:'Courier New';color:#a31515;font-size:10pt;">Format</span><span style="font-family:'Courier New';color:blue;font-size:10pt;">></span><span style="font-family:'Courier New';font-size:10pt;"><font color="#000000">Docx</font><span style="color:blue;"></</span><span style="color:#a31515;">Format</span><span style="color:blue;">></span></span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';color:blue;font-size:10pt;"><span>      </span><</span><span style="font-family:'Courier New';color:#a31515;font-size:10pt;">Data</span><span style="font-family:'Courier New';color:blue;font-size:10pt;">></span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><font color="#000000"><span>        </span>UEsDBBQABgAIAAAAIQAeGe91cwEAAFQFAAATAAgCW0NvbnRlbnRfVHlwZXNdLnhtbCCiBAIooAACAAAAAAAAAAAAAAA</font><span style="color:blue;"></</span><span style="color:#a31515;">Data</span><span style="color:blue;">></span></span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';color:blue;font-size:10pt;"><span>        </span><</span><span style="font-family:'Courier New';color:#a31515;font-size:10pt;">ID</span><span style="font-family:'Courier New';color:blue;font-size:10pt;">></span><span style="font-family:'Courier New';font-size:10pt;"><font color="#000000">1</font><span style="color:blue;"></</span><span style="color:#a31515;">ID</span><span style="color:blue;">></span></span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';color:blue;font-size:10pt;"><span>      </span><</span><span style="font-family:'Courier New';color:#a31515;font-size:10pt;">Name</span><span style="font-family:'Courier New';color:blue;font-size:10pt;">></span><span style="font-family:'Courier New';font-size:10pt;"><font color="#000000">Brochure</font><span style="color:blue;"></</span><span style="color:#a31515;">Name</span><span style="color:blue;">></span></span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';color:blue;font-size:10pt;"><span>    </span></</span><span style="font-family:'Courier New';color:#a31515;font-size:10pt;">Asset</span><span style="font-family:'Courier New';color:blue;font-size:10pt;">></span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';color:blue;font-size:10pt;"><span>    </span><</span><span style="font-family:'Courier New';color:#a31515;font-size:10pt;">Asset</span><span style="font-family:'Courier New';color:blue;font-size:10pt;">></span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';color:blue;font-size:10pt;"><span>      </span><</span><span style="font-family:'Courier New';color:#a31515;font-size:10pt;">Format</span><span style="font-family:'Courier New';color:blue;font-size:10pt;">></span><span style="font-family:'Courier New';font-size:10pt;"><font color="#000000">Jpg</font><span style="color:blue;"></</span><span style="color:#a31515;">Format</span><span style="color:blue;">></span></span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';color:blue;font-size:10pt;"><span>      </span><</span><span style="font-family:'Courier New';color:#a31515;font-size:10pt;">Data</span><span style="font-family:'Courier New';color:blue;font-size:10pt;">></span><span style="font-family:'Courier New';font-size:10pt;"><font color="#000000">/9j/4U5uRXhpZgAATU0AKgAAAAgACgEPAAIAAAAGAAAAhgEQAAIAAAAPAAAAjAESAAMAAAABAAEAAAEaAAUAAAA</font><span style="color:blue;"></</span><span style="color:#a31515;">Data</span><span style="color:blue;">></span></span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';color:blue;font-size:10pt;"><span>        </span><</span><span style="font-family:'Courier New';color:#a31515;font-size:10pt;">ID</span><span style="font-family:'Courier New';color:blue;font-size:10pt;">></span><span style="font-family:'Courier New';font-size:10pt;"><font color="#000000">2</font><span style="color:blue;"></</span><span style="color:#a31515;">ID</span><span style="color:blue;">></span></span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';color:blue;font-size:10pt;"><span>      </span><</span><span style="font-family:'Courier New';color:#a31515;font-size:10pt;">Name</span><span style="font-family:'Courier New';color:blue;font-size:10pt;">></span><span style="font-family:'Courier New';font-size:10pt;"><font color="#000000">Image1</font><span style="color:blue;"></</span><span style="color:#a31515;">Name</span><span style="color:blue;">></span></span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';color:blue;font-size:10pt;"><span>    </span></</span><span style="font-family:'Courier New';color:#a31515;font-size:10pt;">Asset</span><span style="font-family:'Courier New';color:blue;font-size:10pt;">></span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';color:blue;font-size:10pt;"><span>    </span><</span><span style="font-family:'Courier New';color:#a31515;font-size:10pt;">Asset</span><span style="font-family:'Courier New';color:blue;font-size:10pt;">></span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';color:blue;font-size:10pt;"><span>      </span><</span><span style="font-family:'Courier New';color:#a31515;font-size:10pt;">Format</span><span style="font-family:'Courier New';color:blue;font-size:10pt;">></span><span style="font-family:'Courier New';font-size:10pt;"><font color="#000000">Jpg</font><span style="color:blue;"></</span><span style="color:#a31515;">Format</span><span style="color:blue;">></span></span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';color:blue;font-size:10pt;"><span>      </span><</span><span style="font-family:'Courier New';color:#a31515;font-size:10pt;">Data</span><span style="font-family:'Courier New';color:blue;font-size:10pt;">></span><span style="font-family:'Courier New';font-size:10pt;"><font color="#000000">/9j/4VsfRXhpZgAATU0AKgAAAAgACgEPAAIAAAAGAAAAhgEQAAIAAAAPAAAAjAESAAMAAAABAAEAAAEaAAUAAAAB</font><span style="color:blue;"></</span><span style="color:#a31515;">Data</span><span style="color:blue;">></span></span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';color:blue;font-size:10pt;"><span>      </span><</span><span style="font-family:'Courier New';color:#a31515;font-size:10pt;">ID</span><span style="font-family:'Courier New';color:blue;font-size:10pt;">></span><span style="font-family:'Courier New';font-size:10pt;"><font color="#000000">3</font><span style="color:blue;"></</span><span style="color:#a31515;">ID</span><span style="color:blue;">></span></span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';color:blue;font-size:10pt;"><span>      </span><</span><span style="font-family:'Courier New';color:#a31515;font-size:10pt;">Name</span><span style="font-family:'Courier New';color:blue;font-size:10pt;">></span><span style="font-family:'Courier New';font-size:10pt;"><font color="#000000">Image2</font><span style="color:blue;"></</span><span style="color:#a31515;">Name</span><span style="color:blue;">></span></span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';color:blue;font-size:10pt;"><span>    </span></</span><span style="font-family:'Courier New';color:#a31515;font-size:10pt;">Asset</span><span style="font-family:'Courier New';color:blue;font-size:10pt;">></span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';color:blue;font-size:10pt;"><span>  </span></</span><span style="font-family:'Courier New';color:#a31515;font-size:10pt;">Assets</span><span style="font-family:'Courier New';color:blue;font-size:10pt;">></span> </p>
<p style="margin:0 0 10pt;"><span style="line-height:115%;font-family:'Courier New';color:blue;font-size:10pt;"></</span><span style="line-height:115%;font-family:'Courier New';color:#a31515;font-size:10pt;">Product</span><span style="line-height:115%;font-family:'Courier New';color:blue;font-size:10pt;">></span> </p>
<p><p style="margin:0 0 10pt;"><font color="#000000" size="3" face="Calibri">Note that in this case, the Product class carries with it a generic List of Assets, which themselves carry byte arrays that represent images, documents, brochures, etc..<span>  </span>Thus with this approach I’m able to flatten an object graph that carries file assets send it somewhere as Xml, reconstitute it, save off its byte arrays to disk, and then open them with the appropriate program.</font> </p>
<p style="margin:0 0 10pt;"><font color="#000000" size="3" face="Calibri">If the entity objects that you are working with do not implement ISerializable, they should be tagged with the Serializable attribute.<span>  </span>In the case where you have not explicitly implemented ISerializable and some of the properties are not set, you’ll find that these properties are missing from the Xml that results from serialization with XmlSerializer, SoapFormatter, or BinaryFormatter.  </font><font color="#000000" size="3" face="Calibri"><span></span>The DataContractSerialize/DataContractDeserialize helper methods allow you to provide a Type that is attributed with WCF DataContract and DataMember attributes to give the serializer hints on how to work with the object. </font><span style="font-family:'Courier New';font-size:10pt;"><font color="#000000"> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;">        [<span style="color:#2b91af;">TestMethod</span>]</span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>        </span><span style="color:blue;">public</span> <span style="color:blue;">void</span> CanDataContractSerializeDeserialize()</span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>        </span>{</span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>            </span><span style="color:#2b91af;">Product</span> product = <span style="color:blue;">new</span> <span style="color:#2b91af;">TestProductFactory</span>().Build()[0];</span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>            </span><span style="color:blue;">var</span> serializationHelper = <span style="color:blue;">new</span><span>  </span><span style="color:#2b91af;">SerializationHelper</span>();</span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"> </span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>            </span><span style="color:blue;">var</span> pBytes = serializationHelper.DataConractSerialize<<span style="color:#2b91af;">Product</span>>(product);</span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>            </span><span style="color:blue;">string</span> xstring = <span style="color:#2b91af;">Encoding</span>.UTF8.GetString(pBytes);</span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"> </span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>            </span><span style="color:blue;">var</span> pBytes2 = <span style="color:#2b91af;">Encoding</span>.UTF8.GetBytes(xstring);</span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>            </span><span style="color:#2b91af;">Product</span> product2 = serializationHelper.DataConractDeserialize<<span style="color:#2b91af;">Product</span>>(pBytes2);</span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"> </span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>            </span><span style="color:green;">//verify </span></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>            </span><span style="color:#2b91af;">Assert</span>.IsTrue(product.Name.Equals(product2.Name) &#038;&#038; product.ID.Equals(product2.ID));</span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>            </span><span style="color:#2b91af;">Assert</span>.IsFalse(product.Equals(product2)); <span style="color:green;">//deep copy</span></span> </p>
<p style="margin:0 0 10pt;"><span style="line-height:115%;font-family:'Courier New';font-size:10pt;"><span>        </span>}</span></p>
</p>
</p>
</p>
</p>
</p>
</p>
</p>
</p>
<p></font></span> </p>
<p style="margin:0 0 10pt;"><font color="#000000" size="3" face="Calibri">Now the Class..</font><font color="#000000" size="3" face="Calibri"> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';color:blue;font-size:10pt;">    public</span><span style="font-family:'Courier New';font-size:10pt;"> <span style="color:blue;">class</span> <span style="color:#2b91af;">SerializationHelper</span></span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>    </span>{</span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>        </span><span style="color:blue;">public</span> <span style="color:blue;">string</span> XmlSerialize(<span style="color:blue;">object</span> Member)</span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>        </span>{</span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>            </span><span style="color:blue;">using</span> (<span style="color:#2b91af;">MemoryStream</span> b = <span style="color:blue;">new</span> <span style="color:#2b91af;">MemoryStream</span>())</span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>      </span><span>      </span>{</span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>                </span><span style="color:#2b91af;">XmlSerializer</span> xs = <span style="color:blue;">new</span></span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>                    </span><span style="color:#2b91af;">XmlSerializer</span>(Member.GetType());</span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>                </span>xs.Serialize(b, Member);</span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>                </span><span style="color:blue;">return</span> <span style="color:#2b91af;">Encoding</span>.UTF8.GetString(b.ToArray());</span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>            </span>}</span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>        </span>}</span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>        </span><span style="color:blue;">public</span> T XmlDeserialize<T>(<span style="color:blue;">string</span> Serialized)</span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>        </span>{</span> </p>
<p style="line-height:normal;margin:0;">
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"></span><span style="font-family:'Courier New';font-size:10pt;"><span>            </span><span style="color:blue;">using</span> (<span style="color:#2b91af;">MemoryStream</span> b =</span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>                </span><span style="color:blue;">new</span> <span style="color:#2b91af;">MemoryStream</span>(<span style="color:#2b91af;">Encoding</span>.UTF8.GetBytes(Serialized)))</span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>                </span>{</span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>                    </span><span style="color:#2b91af;">XmlSerializer</span> xs = <span style="color:blue;">new</span> <span style="color:#2b91af;">XmlSerializer</span>(<span style="color:blue;">typeof</span>(T));</span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>                    </span><span style="color:blue;">return</span> (T)xs.Deserialize(b);</span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>                </span>}</span> </p>
<p style="line-height:normal;margin:0;">
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"></span><span style="font-family:'Courier New';font-size:10pt;"><span>        </span>}</span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>        </span><span style="color:blue;">public</span> <span style="color:blue;">byte</span>[] SoapSerialize<T>(T obj)</span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>        </span>{</span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>            </span><span style="color:blue;">byte</span>[] bytes = <span style="color:blue;">null</span>;</span> </p>
<p style="line-height:normal;margin:0;">
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"></span><span style="font-family:'Courier New';font-size:10pt;"><span>            </span><span style="color:blue;">using</span> (<span style="color:#2b91af;">MemoryStream</span> b = <span style="color:blue;">new</span> <span style="color:#2b91af;">MemoryStream</span>())</span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>            </span>{</span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>                </span><span style="color:#2b91af;">SoapFormatter</span> formatter = <span style="color:blue;">new</span> <span style="color:#2b91af;">SoapFormatter</span>();</span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>                </span>formatter.Serialize(b, obj);</span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>                </span>bytes = b.ToArray();</span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>            </span>}</span> </p>
<p style="line-height:normal;margin:0;">
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"></span><span style="font-family:'Courier New';font-size:10pt;"><span>            </span><span style="color:blue;">return</span> bytes;</span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>        </span>}</span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>        </span><span style="color:blue;">public</span> T SoapDeserialize<T>(<span style="color:blue;">byte</span>[] blob)</span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>        </span>{</span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>            </span>T obj = <span style="color:blue;">default</span>(T);</span> </p>
<p style="line-height:normal;margin:0;">
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"></span><span style="font-family:'Courier New';font-size:10pt;"><span>    </span><span>        </span><span style="color:blue;">using</span> (<span style="color:#2b91af;">MemoryStream</span> b = <span style="color:blue;">new</span> <span style="color:#2b91af;">MemoryStream</span>(blob))</span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>            </span>{</span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>                </span><span style="color:#2b91af;">SoapFormatter</span> formatter = <span style="color:blue;">new</span> <span style="color:#2b91af;">SoapFormatter</span>();</span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>                </span>obj = (T)formatter.Deserialize(b);</span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>            </span>}</span> </p>
<p style="line-height:normal;margin:0;">
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"></span><span style="font-family:'Courier New';font-size:10pt;"><span>            </span><span style="color:blue;">return</span> obj;</span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>        </span>}</span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>        </span><span style="color:blue;">public</span> <span style="color:blue;">byte</span>[] BinarySerialize(<span style="color:blue;">object</span> obj)</span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>        </span>{</span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>            </span><span style="color:blue;">byte</span>[] bytes = <span style="color:blue;">null</span>;</span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>            </span><span style="color:#2b91af;">IFormatter</span> formatter = <span style="color:blue;">new</span> <span style="color:#2b91af;">BinaryFormatter</span>();</span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>            </span><span style="color:blue;">using</span> (<span style="color:#2b91af;">MemoryStream</span> stream = <span style="color:blue;">new</span> <span style="color:#2b91af;">MemoryStream</span>())</span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>            </span>{</span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>                </span>formatter.Serialize(stream, obj);</span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>                </span>bytes = stream.ToArray();</span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>            </span>}</span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>            </span><span style="color:blue;">return</span> bytes;</span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>        </span>}</span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>        </span><span style="color:blue;">public</span> T BinaryDeserialize<T>(<span style="color:blue;">byte</span>[] bytes)</span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>        </span>{</span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>            </span>T instance = <span style="color:blue;">default</span>(T);</span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>            </span><span style="color:#2b91af;">IFormatter</span> formatter = <span style="color:blue;">new</span> <span style="color:#2b91af;">BinaryFormatter</span>();</span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>            </span><span style="color:blue;">using</span> (<span style="color:#2b91af;">MemoryStream</span> stream = <span style="color:blue;">new</span> <span style="color:#2b91af;">MemoryStream</span>(bytes))</span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>            </span>{</span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>                </span>instance = (T)formatter.Deserialize(stream);</span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>                </span>bytes = stream.ToArray();</span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>            </span>}</span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>            </span><span style="color:blue;">return</span> instance;</span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>        </span>}</span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>        </span><span style="color:blue;">public</span> <span style="color:blue;">virtual</span> T DataConractDeserialize<T>(<span style="color:blue;">byte</span>[] bytes)</span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>        </span>{</span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>            </span>T result = <span style="color:blue;">default</span>(T);</span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>            </span><span style="color:blue;">using</span> (<span style="color:blue;">var</span> stream = <span style="color:blue;">new</span> <span style="color:#2b91af;">MemoryStream</span>(bytes))</span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>            </span>{</span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>                </span><span style="color:#2b91af;">XmlReader</span> reader = <span style="color:#2b91af;">XmlReader</span>.Create(stream);</span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>                </span><span style="color:#2b91af;">DataContractSerializer</span> serializer = <span style="color:blue;">new</span> <span style="color:#2b91af;">DataContractSerializer</span>(<span style="color:blue;">typeof</span>(T));</span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>                </span>result = (T)serializer.ReadObject(reader);</span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>            </span>}</span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>            </span><span style="color:blue;">return</span> result;</span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>        </span>}</span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>        </span><span style="color:blue;">public</span> <span style="color:blue;">virtual</span> <span style="color:blue;">byte</span>[] DataConractSerialize<T>(T obj)</span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>        </span>{</span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>            </span><span style="color:blue;">byte</span>[] bytes = <span style="color:blue;">new</span> <span style="color:blue;">byte</span>[] { };</span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>            </span><span style="color:blue;">using</span> (<span style="color:blue;">var</span> stream = <span style="color:blue;">new</span> <span style="color:#2b91af;">MemoryStream</span>())</span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>            </span>{</span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>                </span><span style="color:#2b91af;">XmlWriter</span> writer = <span style="color:#2b91af;">XmlWriter</span>.Create(stream);</span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>                </span><span style="color:#2b91af;">DataContractSerializer</span> serializer = <span style="color:blue;">new</span> <span style="color:#2b91af;">DataContractSerializer</span>(<span style="color:blue;">typeof</span>(T));</span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>                </span>serializer.WriteObject(writer, obj);</span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>   </span><span>             </span>writer.Flush();</span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>                </span>bytes = stream.ToArray();</span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>            </span>}</span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>            </span><span style="color:blue;">return</span> bytes;</span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><span>        </span>}</span> </p>
<p style="margin:0 0 10pt;"><span style="line-height:115%;font-family:'Courier New';font-size:10pt;"><span>    </span>}</span> </p>
<p style="line-height:normal;margin:0;">
<p style="margin:0 0 10pt;">
<p style="line-height:normal;margin:0;">
</p>
</p>
</p>
</p>
</p>
</p>
</p>
</p>
</p>
</p>
</p>
</p>
</p>
</p>
</p>
</p>
</p>
</p>
</p>
</p>
</p>
</p>
</p>
</p>
</p>
</p>
</p>
</p>
</p>
</p>
</p>
</p>
</p>
</p>
</p>
</p>
</p>
</p>
</p>
</p>
</p>
<p></font><span style="font-family:Calibri,sans-serif;color:black;font-size:11pt;"></p>
<p style="margin-bottom:10pt;"><span style="font-family:Calibri,sans-serif;color:black;font-size:11pt;">Thats the basic scenario.  In</span><span style="font-family:Calibri,sans-serif;color:#444444;font-size:11pt;"> <a href="http://uberpwn.spaces.live.com/blog/cns!3FC3980D58CF7EFB!479.entry"><u><font color="#800080">part 2</font></u></a> </span><span style="font-family:Calibri,sans-serif;color:black;font-size:11pt;">of this article, I&#8217;ll demonstrate how to do secure object persistence to disk.  You&#8217;ll also be able to download the source for both parts.  Enjoy and happy baking&#8230; </span></p>
<p></span></p>
</p>
</p>
</p>
</p>
</p>
</p>
</p>
</p>
</p>
</p>
</p>
</p>
</p>
</p>
</p>
</p>
</p>
</p>
</p>
</p>
</div>
