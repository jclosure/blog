---
layout: post
title: "A Straight Forward ASP.NET AJAX Solution With MS Ajax, Restful WCF Services, and A Dash Of JQuery"
date: 2009-04-14 22:22:53 -0500
categories: []
tags: []
wordpress_id: 13
original_url: "https://joelholder.com/2009/04/14/a-straight-forward-asp-net-ajax-solution-with-ms-ajax-restful-wcf-services-and-a-dash-of-jquery/"
---
<div id="msgcns!3FC3980D58CF7EFB!501" class="bvMsg">
<p>One of the main advantages of JSON is that, like XML, it can represent an object graph of any shape.<span>  </span>JSON allows for the natural structure of entity Types to be expressed in the form of nested and aggregated object literals.<span>  </span>The simplicity and small footprint of this format has made it a popular choice for data interchange with the dynamic languages crowd, where JSON can be parsed into native objects with basic language constructs.<span>  </span>This is what makes it most appealing for JavaScript developers.<span>  </span>This article will demonstrate a straight forward way of doing Ajax with <a href="http://msdn.microsoft.com/en-us/netframework/cc950529.aspx">WCF Rest</a>, <a href="http://www.asp.net/ajax/">MS Ajax</a>, <a href="http://objectbakery.codeplex.com/">Object Bakery</a>, and <a href="http://docs.jquery.com/Main_Page">JQuery</a>. </p>
<p style="text-indent:-.25in;margin-left:45pt;"><span><span>1.<span style="line-height:normal;font-variant:normal;font-style:normal;font-size:7pt;font-weight:normal;">       </span></span></span>Create a new WebForms project. </p>
<p style="text-indent:-.25in;margin-left:45pt;"><span><span>2.<span style="line-height:normal;font-variant:normal;font-style:normal;font-size:7pt;font-weight:normal;">       </span></span></span>Drag in a ScriptManager to Default.aspx&#8217;s form element. </p>
<p style="text-indent:-.25in;margin-left:45pt;"><span><span>3.<span style="line-height:normal;font-variant:normal;font-style:normal;font-size:7pt;font-weight:normal;">       </span></span></span>Add JQuery-1.3.2.min.js to the project. </p>
<p style="text-indent:-.25in;margin-left:45pt;"><span><span>4.<span style="line-height:normal;font-variant:normal;font-style:normal;font-size:7pt;font-weight:normal;">       </span></span></span>Drag JQuery-1.3.2.min.js into the head section. </p>
<p style="text-indent:-.25in;margin-left:45pt;"><span><span>5.<span style="line-height:normal;font-variant:normal;font-style:normal;font-size:7pt;font-weight:normal;">       </span></span></span>Add an empty </p>
<p /> to the form. </p>
<p style="text-indent:-.25in;margin-left:45pt;"><span><span>6.<span style="line-height:normal;font-variant:normal;font-style:normal;font-size:7pt;font-weight:normal;">       </span></span></span>Switch to design view. </p>
<p style="text-indent:-.25in;margin-left:45pt;"><span><span>7.<span style="line-height:normal;font-variant:normal;font-style:normal;font-size:7pt;font-weight:normal;">       </span></span></span>Drag in an HTML input button and double click it. </p>
<p>Your markup should now look something like this: </p>
<p style="line-height:normal;margin:0 0 0 .5in;"><span><%</span><span>@</span><span> <span style="color:#a31515;">Page</span> <span style="color:red;">Language</span><span style="color:blue;">=&#8221;C#&#8221;</span> <span style="color:red;">AutoEventWireup</span><span style="color:blue;">=&#8221;true&#8221;</span> <span style="color:red;">CodeBehind</span><span style="color:blue;">=&#8221;Default.aspx.cs&#8221;</span> <span style="color:red;">Inherits</span><span style="color:blue;">=&#8221;OBWeb._Default&#8221;</span> <span style="background:yellow;">%> </span></span></p>
<p style="line-height:normal;margin:0 0 0 .5in;"><span><span style="background:yellow;"></span></span><span><!</span><span>DOCTYPE</span><span> <span style="color:red;">html</span> <span style="color:red;">PUBLIC</span> <span style="color:blue;">&#8220;-//W3C//DTD XHTML 1.0 Transitional//EN&#8221;</span> <span style="color:blue;">&#8220;<a href="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd&#038;#8221" rel="nofollow">http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd&#038;#8221</a>;> </span></span></p>
<p style="line-height:normal;margin:0 0 0 .5in;"><span><span style="color:blue;"></span></span><span><</span><span>html</span><span> <span style="color:red;">xmlns</span><span style="color:blue;">=&#8221;<a href="http://www.w3.org/1999/xhtml&#038;#8221" rel="nofollow">http://www.w3.org/1999/xhtml&#038;#8221</a>;> </span></span></p>
<p style="line-height:normal;margin:0 0 0 .5in;"><span><span style="color:blue;"></span></span><span><</span><span>head</span><span> <span style="color:red;">runat</span><span style="color:blue;">=&#8221;server&#8221;> </span></span> </p>
<p style="line-height:normal;margin:0 0 0 .5in;"><span><span style="color:blue;"><font color="#444444">     </font><</span><span style="color:#a31515;">title</span><span style="color:blue;">></</span><span style="color:#a31515;">title</span><span style="color:blue;">> </span></span></p>
<p style="line-height:normal;margin:0 0 0 .5in;"><span><span style="color:blue;">          </span></span><span><span style="color:blue;"><</span><span style="color:#a31515;">script</span> <span style="color:red;">src</span><span style="color:blue;">=&#8221;js/jquery-1.3.2.min.js&#8221;</span> <span style="color:red;">type</span><span style="color:blue;">=&#8221;text/javascript&#8221;></</span><span style="color:#a31515;">script</span><span style="color:blue;">> </span></span></p>
<p style="line-height:normal;margin:0 0 0 .5in;"><span><span style="color:blue;"></span></span><span><span style="color:blue;">          <</span><span style="color:#a31515;">script</span> <span style="color:red;">type</span><span style="color:blue;">=&#8221;text/javascript&#8221;> </span></span></p>
<p style="line-height:normal;margin:0 0 0 .5in;"><span><span style="color:blue;">               </span></span><span>function</span><span> Button1_onclick() { </span><span></p>
<p></span></p>
<p style="line-height:normal;margin:0 0 0 .5in;"><span><span>              </span>}</span> </p>
<p style="line-height:normal;margin:0 0 0 .5in;"><span>          </span><span><span style="color:blue;"></</span><span style="color:#a31515;">script</span><span style="color:blue;">> </span></span></p>
<p style="line-height:normal;margin:0 0 0 .5in;"><span><span style="color:blue;"></span></span><span></</span><span>head</span><span>> </span></p>
<p style="line-height:normal;margin:0 0 0 .5in;"><span></span><span><</span><span>body</span><span>> </span></p>
<p style="line-height:normal;margin:0 0 0 .5in;"><span></span><span><span style="color:blue;"><</span><span style="color:#a31515;">form</span> <span style="color:red;">id</span><span style="color:blue;">=&#8221;form1&#8243;</span> <span style="color:red;">runat</span><span style="color:blue;">=&#8221;server&#8221;> </span></span></p>
<p style="line-height:normal;margin:0 0 0 .5in;"><span><span style="color:blue;">     </span></span><span><span style="color:blue;"><</span><span style="color:#a31515;">div</span><span style="color:blue;">> </span></span></p>
<p style="line-height:normal;margin:0 0 0 .5in;"><span><span style="color:blue;">          </span></span><span><span style="color:blue;"><</span><span style="color:#a31515;">asp</span><span style="color:blue;">:</span><span style="color:#a31515;">ScriptManager</span> <span style="color:red;">ID</span><span style="color:blue;">=&#8221;ScriptManager1&#8243;</span> <span style="color:red;">runat</span><span style="color:blue;">=&#8221;server&#8221; /> </span></span></p>
<p style="line-height:normal;margin:0 0 0 .5in;"><span><span style="color:blue;">          </span></span><span><span style="color:blue;"><</span><span style="color:#a31515;">input</span> <span style="color:red;">id</span><span style="color:blue;">=&#8221;Button1&#8243;</span> <span style="color:red;">type</span><span style="color:blue;">=&#8221;button&#8221;</span> <span style="color:red;">value</span><span style="color:blue;">=&#8221;submit&#8221;</span> <span style="color:red;">onclick</span><span style="color:blue;">=&#8221;return Button1_onclick()&#8221;</span> <span style="color:blue;">/> </span></span></p>
<p style="line-height:normal;margin:0 0 0 .5in;"><span><span style="color:blue;">          </span></span><span><span style="color:blue;"><</span><span style="color:#a31515;">p</span> <span style="color:blue;">/> </span></span></p>
<p style="line-height:normal;margin:0 0 0 .5in;"><span><span style="color:blue;">     </span></span><span><span style="color:blue;"></</span><span style="color:#a31515;">div</span><span style="color:blue;">> </span></span></p>
<p style="line-height:normal;margin:0 0 0 .5in;"><span><span style="color:blue;"></</span><span style="color:#a31515;">form</span><span style="color:blue;">> </span></span></p>
<p style="line-height:normal;margin:0 0 0 .5in;"><span><span style="color:blue;"></span></span><span></</span><span>body</span><span>> </span></p>
<p style="line-height:normal;margin:0 0 0 .5in;"><span></span><span></</span><span>html</span><span>> </p>
<p></span></p>
<p><p>  Notice that we have a stubbed out JavaScript function wired to our button. </p>
<p style="text-indent:-.25in;margin-left:45pt;"><span><span>8.<span style="line-height:normal;font-variant:normal;font-style:normal;font-size:7pt;font-weight:normal;">       </span></span></span>Add a reference to ObjectBakery.dll, available <a href="http://objectbakery.codeplex.com/">here</a>. </p>
<p style="text-indent:-.25in;margin-left:45pt;"><span><span>9.<span style="line-height:normal;font-variant:normal;font-style:normal;font-size:7pt;font-weight:normal;">       </span></span></span>Add a new “Ajax-enabled WCF Service” to your project. </p>
<p style="text-indent:-.25in;margin-left:45pt;"><span><span>10.<span style="line-height:normal;font-variant:normal;font-style:normal;font-size:7pt;font-weight:normal;">   </span></span></span>Name it Service1. </p>
<p style="text-indent:-.25in;margin-left:45pt;"><span><span>11.<span style="line-height:normal;font-variant:normal;font-style:normal;font-size:7pt;font-weight:normal;">   </span></span></span>Create a sample POCO that we can use for the demo.<span>  </span>Here’s mine: </p>
<p style="line-height:normal;text-indent:.25in;margin:0 0 0 .25in;"><span><span> </span><span><span style="color:blue;">public</span> </span></span><span><span style="color:blue;">class</span> <span style="color:#2b91af;">TestObject</span></span> </p>
<p style="line-height:normal;text-indent:.25in;margin:0 0 0 .25in;"><span><span style="color:#2b91af;"></span></span><span> {</span> </p>
<p style="line-height:normal;text-indent:.25in;margin:0 0 0 .25in;"><span>     <span style="color:blue;">public</span> <span style="color:blue;">int</span> ID { <span style="color:blue;">get</span>; <span style="color:blue;">set</span>; }</span> </p>
<p style="line-height:normal;text-indent:.25in;margin:0 0 0 .25in;"><span>     <span style="color:blue;">public</span> </span><span><span style="color:blue;">string</span> Description { <span style="color:blue;">get</span>; <span style="color:blue;">set</span>; } </span></p>
<p style="line-height:normal;text-indent:.25in;margin:0 0 0 .25in;"><span> }</span> </p>
<p style="line-height:normal;text-indent:.25in;margin:0 0 0 .25in;"><span></span>  </p>
<p><span><span></p>
<p style="text-indent:-.25in;margin-left:45pt;"><span><span>12.<span style="line-height:normal;font-variant:normal;font-style:normal;font-size:7pt;font-weight:normal;">   </span></span></span>Change the stubbed out DoWork method in Service1 to look like this. </p>
<p style="line-height:normal;text-indent:.5in;margin-bottom:0;"><span>[<span style="color:#2b91af;">WebGet</span>] </span></p>
<p style="line-height:normal;text-indent:.5in;margin-bottom:0;"><span></span><span>[<span style="color:#2b91af;">OperationContract</span>] </span></p>
<p style="line-height:normal;text-indent:.5in;margin-bottom:0;"><span></span><span><span style="color:blue;">public</span> <span style="color:blue;">string</span> DoWork(<span style="color:blue;">int</span> id) </span></p>
<p style="line-height:normal;text-indent:.5in;margin-bottom:0;"><span></span><span>{ </span></p>
<p style="line-height:normal;text-indent:.5in;margin-bottom:0;"><span></span><span><span style="color:green;">     //fab some data objects </span></span></p>
<p style="line-height:normal;text-indent:.5in;margin-bottom:0;"><span><span style="color:green;"></span></span><span><span style="color:#2b91af;">     List</span><<span style="color:#2b91af;">TestObject</span>> obs = <span style="color:blue;">new</span> <span style="color:#2b91af;">List</span><<span style="color:#2b91af;">TestObject</span>>(); </span></p>
<p style="line-height:normal;text-indent:.5in;margin-bottom:0;"><span></span><span>     obs.Add(<span style="color:blue;">new</span> <span style="color:#2b91af;">TestObject</span> { ID = id, Description = <span style="color:#a31515;">&#8220;ASDFASDF&#8221;</span> }); </span></p>
<p style="line-height:normal;text-indent:.5in;margin-bottom:0;"><span></span><span>     obs.Add(<span style="color:blue;">new</span> <span style="color:#2b91af;">TestObject</span> { ID = id + 1, Description = <span style="color:#a31515;">&#8220;QWER&#8221;</span> }); </span></p>
<p style="line-height:normal;text-indent:.5in;margin-bottom:0;"><span></span><span>     obs.Add(<span style="color:blue;">new</span> <span style="color:#2b91af;">TestObject</span> { ID = id + 2, Description = <span style="color:#a31515;">&#8220;DFFG&#8221;</span> }); </span></p>
<p style="line-height:normal;text-indent:.5in;margin-bottom:0;"><span></span><span>     obs.Add(<span style="color:blue;">new</span> <span style="color:#2b91af;">TestObject</span> { ID = id + 3, Description = <span style="color:#a31515;">&#8220;ZXCV&#8221;</span> }); </p>
<p></span></p>
<p style="line-height:normal;margin:0 0 0 .25in;"><span><span style="color:green;"><font color="#444444">            </font>//magic </span></span></p>
<p style="line-height:normal;margin:0 0 0 .25in;"><span><span style="color:green;">            </span></span><span><span style="color:blue;">var</span> helper = <span style="color:blue;">new</span> ObjectBakery.Helpers.<span style="color:#2b91af;">SerializationHelper</span>(); </span></p>
<p style="line-height:normal;margin:0 0 0 .25in;"><span>            </span><span><span style="color:blue;">var</span> txtO = helper.JsonSerialize(obs.ToArray()); </span></p>
<p style="line-height:normal;margin:0 0 0 .25in;"><span>            </span><span><span style="color:blue;">return</span> txtO; </span></p>
<p style="line-height:normal;margin:0 0 0 .25in;"><span>       </span><span style="line-height:115%;">}</span> </p>
</p>
</p>
</p>
</p>
</p>
</p>
</p>
</p>
<p></span></span></p>
<p style="text-indent:-.25in;margin-left:45pt;"><span><span></span></span> </p>
<p style="text-indent:-.25in;margin-left:45pt;"><span><span>13.<span style="line-height:normal;font-variant:normal;font-style:normal;font-size:7pt;font-weight:normal;">  </span></span></span><span><span><span style="line-height:normal;font-variant:normal;font-style:normal;font-size:7pt;font-weight:normal;"> </span></span></span>In the page designer right mouse click your ScriptManager and go to properties. </p>
<p style="text-indent:-.25in;margin-left:45pt;"><span><span>14.<span style="line-height:normal;font-variant:normal;font-style:normal;font-size:7pt;font-weight:normal;">   </span></span></span>In the property designer click the ellipsis next to Services </p>
<blockquote style="margin-right:0;">
<p><span><a href="http://blufiles.storage.msn.com/y1pKpUb50qrK6pEZPTbjvD9mY_WHpLjU1jgQtKQMS2SVgqL-ZNF6XJKO0XxWcuANM89Xvx80Kn_U3Q?PARTNER=WRITER"><img decoding="async" border="0" src="http://blufiles.storage.msn.com/y1p9Ge-RNGG43g_zSoi4dvElynfWfPlNWFN8isJOhopr6kYlpRazKJg5bn3rnAw45BovVYrw6_8BQASI0MctSw9Bw?PARTNER=WRITER" /></a></span> </p>
</blockquote>
<p style="text-indent:-.25in;margin-left:45pt;"><span><span>15.<span style="line-height:normal;font-variant:normal;font-style:normal;font-size:7pt;font-weight:normal;">   </span></span></span>Add a Service, setting the Path property to the url of Service1, i.e. “/Service1.svc”. </p>
<p style="text-indent:-.25in;margin-left:45pt;"><span><span>16.<span style="line-height:normal;font-variant:normal;font-style:normal;font-size:7pt;font-weight:normal;">   </span></span></span>Now lets write some JavaScript. </p>
<p style="line-height:normal;text-indent:.25in;margin:0 0 0 .25in;"><span><</span><span>script</span><span> <span style="color:red;">type</span><span style="color:blue;">=&#8221;text/javascript&#8221;> </span></span></p>
<p style="line-height:normal;text-indent:.25in;margin:0 0 0 .25in;"><span><span style="color:blue;">     fu</span></span><span><span style="color:blue;">nction</span> Button1_onclick() { </span></p>
<p style="line-height:normal;text-indent:.25in;margin:0 0 0 .25in;"><span>          </span><span><span style="color:blue;">var</span> service = <span style="color:blue;">new</span> Service1(); </span></p>
<p style="line-height:normal;text-indent:.25in;margin:0 0 0 .25in;"><span>          </span><span>service.DoWork(3, onSuccess, <span style="color:blue;">null</span>, <span style="color:blue;">null</span>); </span></p>
<p style="line-height:normal;text-indent:.25in;margin:0 0 0 .25in;"><span>     </span><span>} </p>
<p></span></p>
<p style="line-height:normal;margin:0 0 0 .25in;"><span><span>            </span><span style="color:blue;">function</span> onSuccess(result) { </span></p>
<p style="line-height:normal;margin:0 0 0 .25in;"><span>               </span><span><span style="color:blue;">var</span> objects = eval(<span style="color:#a31515;">&#8220;(&#8220;</span> + result + <span style="color:#a31515;">&#8220;)&#8221;</span>); </span></p>
<p style="line-height:normal;margin:0 0 0 .25in;"><span>               </span><span><span style="color:blue;">for</span> (<span style="color:blue;">var</span> i <span style="color:blue;">in</span> objects) { </span></p>
<p style="line-height:normal;margin:0 0 0 .25in;"><span>                    </span><span>$(<span style="color:#a31515;">&#8220;p&#8221;</span>).append(objects[i].Description + <span style="color:#a31515;">&#8220;<br />&#8220;</span>); </span></p>
<p style="line-height:normal;margin:0 0 0 .25in;"><span>               </span><span>} </span></p>
<p style="line-height:normal;margin:0 0 0 .25in;"><span>          </span><span>} </span></p>
<p style="line-height:normal;margin:0 0 0 .25in;"><span>          </span><span style="line-height:115%;"><span style="color:blue;"></</span><span style="color:#a31515;">script</span><span style="color:blue;">> </p>
<p></span></span></p>
<p style="margin-left:.25in;">What <span> </span>we did here is fill out our Button1_onclick with code that news up a Service1 reference and invokes its DoWork.<span>  </span>The first argument will be passed as the id parameter to our WebMethod.<span>  </span>The second argument is a callback, in our case the onSuccess method.<span>  </span>Notice the signature of onSuccess takes a result param.<span>  </span>This will be our JSON string returned from DoWork.<span>  </span>Note that we can parse the result into a native JavaScript object graph with a single line of code. </p>
<p style="line-height:normal;text-indent:.25in;margin:0 0 0 .25in;"><span><span><span style="color:blue;">var</span> objects = eval(<span style="color:#a31515;">&#8220;(&#8220;</span> + result + <span style="color:#a31515;">&#8220;)&#8221;</span>); </span></span></p>
<p style="line-height:normal;text-indent:.25in;margin:0 0 0 .25in;"><span></span>  </p>
<p style="margin-left:.25in;">This is pretty cool.<span>  </span><span> </span>We trust our own service, so there’s no issue with using eval, instead of parseJSON().<span>  </span>In our for loop, we use JQuery to add new DOM elements holding the Description property from each of our objects. </p>
<p style="text-indent:.25in;margin-left:.25in;"><span style="line-height:115%;">$(<span style="color:#a31515;">&#8220;p&#8221;</span>).append(objects[i].Description + <span style="color:#a31515;">&#8220;<br />&#8220;</span>);</span> </p>
<p style="margin-left:.25in;"><span><a href="http://blufiles.storage.msn.com/y1pgz0RXbodBG66JHQFhyGLTMiJHK6YLLys_ZwaxOfIc7BL8otLDqhdQ9pW7Tu4af9rpXQ_YaHWnMI_yuVl2YnB1w?PARTNER=WRITER"><img decoding="async" border="0" src="http://blufiles.storage.msn.com/y1pQFvMYhB-F9bnN7rqQHPAJ2mhICqD8hcJ4TbuO_nicRpAjYgXoUrM8euN-z-gg5EBZTh2NtEdaSXD6XYCes4qlQ?PARTNER=WRITER" /></a></span> </p>
<p style="margin-left:.25in;">That’s the basic story.<span>  </span>What we’ve been able to do here is enable the basic async data exchange paradigm between an ASPX page and data enabled Rest services.<span>  </span>There are some fun bits here when you couple this approach with ORM frameworks, such as <a href="http://msdn.microsoft.com/en-us/library/aa697427(VS.80).aspx">Entity Framework</a> or <a href="http://www.hibernate.org/343.html">NHibernate</a>.<span>  </span>We now have the capability to move objects between JavaScript and C# seamlessly.<span>  </span>Object Bakery has helper methods to move between JSON and CLR graphs with a single line of code.<span>  </span>I have found this approach helpful when I need to share objects between client and server, and<span>  </span>I don’t want to worry about the details of data interchange.<span>   </span>Note that Object Bakery also works with Anonymous Types, which allows us to project out objects containing only the data our front-end needs and thus keeps our graphs and their isomorphic JSON strings as small as possible.<span>  </span>Your users will appreciate every bit of responsivity you can give them. </p>
<p style="margin-left:.25in;">You can download the code for this project <a href="http://cid-3fc3980d58cf7efb.skydrive.live.com/self.aspx/Public/OBWeb.zip" target="_blank">here</a>. </p>
<p style="margin-left:.25in;">Enjoy..</p>
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
</div>
