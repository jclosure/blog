---
layout: post
title: "Property Copying With Dynamic Objects in .NET 4.0"
date: 2009-12-21 23:40:33 -0600
categories: []
tags: []
wordpress_id: 11
original_url: "https://joelholder.com/2009/12/21/property-copying-with-dynamic-objects-in-net-4-0/"
---
<div id="msgcns!3FC3980D58CF7EFB!511" class="bvMsg">
<div>Lately, I&#8217;ve been trying out some of the new .NET 4.0 language features.  Specifically, I&#8217;ve been looking into ways to trivially combine late dispatch and late binding in order to build general purpose convenience objects.   In this case, I wanted an expando object that I could program against with some of the techniques we use in javascript to programmatically build up a graph&#8217;s shape with runtime logic.   The built in System.Dynamic.ExpandoObject was not sufficient for this purpose, in that it does not provide a mechanism for setting property names at runtime via string, not to mention its sealed.   In this post I&#8217;ll quickly show you how to leverage C# dynamic to copy and replicate the shape and values of a POCO at runtime.  By exposing a subclassed DynamicObject&#8217;s properties publicly via a Dictionary<string, object>, we can do things like this:</div>
<div> </div>
<div>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000">        [</font><span style="color:#2b91af;">TestMethod</span><font color="#000000">]</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span><font color="#000000">        </font></span><span style="color:blue;">public</span><font color="#000000"> </font><span style="color:blue;">void</span><font color="#000000"> Can_Set_Get_Properties()</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000"><span>        </span>{</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span><font color="#000000">            </font></span><span style="color:blue;">dynamic</span><font color="#000000"> expandable = </font><span style="color:blue;">new</span><font color="#000000"> </font><span style="color:#2b91af;">ExpandableObject</span><font color="#000000">();</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000"> </font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000"><span>            </span>expandable.Properties.Add(</font><span style="color:#a31515;">&#8220;foo&#8221;</span><font color="#000000">, </font><span style="color:brown;">&#8220;good stuff&#8221;</span><font color="#000000">);</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000"><span>            </span></font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000"><span>            </span></font></span><span style="font-family:Consolas;font-size:9.5pt;"><span style="color:#2b91af;">Assert</span><font color="#000000">.AreEqual(expandable.foo, expandable.Properties[</font><span style="color:#a31515;">&#8220;foo&#8221;</span><font color="#000000">]);</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000"> </font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000"><span>            </span>expandable.bar = </font><span style="color:#a31515;">&#8220;yummy&#8221;</span><font color="#000000">;</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000"></font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span><font color="#000000">            </font></span></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span><font color="#000000">            </font></span><span style="color:#2b91af;">Assert</span><font color="#000000">.AreEqual(expandable.bar,  expandable.Properties[<span style="color:#a31515;">&#8220;bar&#8221;</span><font color="#000000">]</font>);</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000"><span>        </span>}</font></span></p>
</div>
<div> </div>
<div>With a few helper methods this capability becomes more useful.  See here:</div>
<div> </div>
<div>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000">        [</font><span style="color:#2b91af;">TestMethod</span><font color="#000000">()]</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span><font color="#000000">        </font></span><span style="color:blue;">public</span><font color="#000000"> </font><span style="color:blue;">void</span><font color="#000000"> Expandable_Object_Can_Copy_Properties_From_To()</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000"><span>        </span>{</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span><font color="#000000">            </font></span><span style="color:blue;">dynamic</span><font color="#000000"> expandable = </font><span style="color:blue;">new</span><font color="#000000"> </font><span style="color:#2b91af;">ExpandableObject</span><font color="#000000">();</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000"> </font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span><font color="#000000">            </font></span><span style="color:blue;">var</span><font color="#000000"> testObj = </font><span style="color:blue;">new</span><font color="#000000"> </font><span style="color:#2b91af;">TestObject</span></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000"><span>            </span>{</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000"><span>                </span>ID = </font><span style="color:brown;">1</span><font color="#000000">,</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000"><span>                </span>Description = </font><span style="color:#a31515;">&#8220;ASDFASDF&#8221;</span><font color="#000000">,</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000"><span>                </span>Name = </font><span style="color:#a31515;">&#8220;GGGG&#8221;</span><font color="#000000">,</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000"><span>                </span>UnitPrice = </font><span style="color:brown;">6</span></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000"><span>            </span>};</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000"> </font></span></p>
<p><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000"><span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;color:green;font-size:9.5pt;"></span></p>
<p></span></font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000"><span>            </span>expandable.CopyPropertiesFrom(testObj, </font><span style="color:blue;">null</span><font color="#000000">);</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000"></font></span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000"></font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span><font color="#000000">            </font></span><span style="color:#2b91af;">Assert</span><font color="#000000">.AreEqual(expandable.Description, testObj.Description);</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000"> </font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"></span><span style="font-family:Consolas;font-size:9.5pt;"><span><font color="#000000">            </font></span><span style="color:blue;">var</span><font color="#000000"> testObj2 = </font><span style="color:blue;">new</span><font color="#000000"> </font><span style="color:#2b91af;">TestObject</span><font color="#000000">();</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000"></font></span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000"></font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000"><span>            </span>expandable.CopyPropertiesTo(testObj2, </font><span style="color:blue;">null</span><font color="#000000">);</font></span><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000"> </font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000"></font></span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span><font color="#000000">            </font></span><span style="color:#2b91af;">Assert</span><font color="#000000">.AreEqual(testObj, testObj2);</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000"><span></span></font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000"><span>        </span>}</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000"></font></span> </p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000">Here is the implementation of ExpandableObject.</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000"></font></span> </p>
<p><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000"></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span>    </span><span style="color:blue;"></span></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;color:blue;font-size:9.5pt;">    public</span><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000"> </font><span style="color:blue;">class</span><font color="#000000"> </font><span style="color:#2b91af;">ExpandableObject</span><font color="#000000"> : </font><span style="color:#2b91af;">DynamicObject</span></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000"><span>    </span>{</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span><font color="#000000">        </font></span><span style="color:#2b91af;">Dictionary</span><font color="#000000"><</font><span style="color:blue;">string</span><font color="#000000">, </font><span style="color:blue;">object</span><font color="#000000">></font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000"><span>          </span>_properties = </font><span style="color:blue;">new</span><font color="#000000"> </font><span style="color:#2b91af;">Dictionary</span><font color="#000000"><</font><span style="color:blue;">string</span><font color="#000000">, </font><span style="color:blue;">object</span><font color="#000000">>();</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000"> </font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span><font color="#000000">        </font></span><span style="color:blue;">public</span><font color="#000000"> </font><span style="color:#2b91af;">Dictionary</span><font color="#000000"><</font><span style="color:blue;">string</span><font color="#000000">, </font><span style="color:blue;">object</span><font color="#000000">> Properties</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000"><span>        </span>{</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span><font color="#000000">            </font></span><span style="color:blue;">get</span><font color="#000000"> { </font><span style="color:blue;">return</span><font color="#000000"> _properties; }</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span><font color="#000000">            </font></span><span style="color:blue;">set</span><font color="#000000"> { _properties = </font><span style="color:blue;">value</span><font color="#000000">; }</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000"><span>        </span>}</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000"> </font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span><font color="#000000">        </font></span><span style="color:blue;">public</span><font color="#000000"> </font><span style="color:blue;">override</span><font color="#000000"> </font><span style="color:blue;">bool</span><font color="#000000"> TrySetMember(</font><span style="color:#2b91af;">SetMemberBinder</span><font color="#000000"> binder, </font><span style="color:blue;">object</span><font color="#000000"> value)</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000"><span>        </span>{</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000"><span>            </span>_properties[binder.Name] = value;</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span><font color="#000000">            </font></span><span style="color:blue;">return</span><font color="#000000"> </font><span style="color:blue;">true</span><font color="#000000">;</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000"><span>        </span>}</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000"> </font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span><font color="#000000">        </font></span><span style="color:blue;">public</span><font color="#000000"> </font><span style="color:blue;">override</span><font color="#000000"> </font><span style="color:blue;">bool</span><font color="#000000"> TryGetMember(</font><span style="color:#2b91af;">GetMemberBinder</span><font color="#000000"> binder,</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span><font color="#000000">            </font></span><span style="color:blue;">out</span><font color="#000000"> </font><span style="color:blue;">object</span><font color="#000000"> result)</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000"><span>        </span>{</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span><font color="#000000">            </font></span><span style="color:blue;">return</span><font color="#000000"> _properties.TryGetValue(binder.Name, </font><span style="color:blue;">out</span><font color="#000000"> result);</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000"><span>        </span>}</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000"> </font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span><font color="#000000">        </font></span><span style="color:blue;">public</span><font color="#000000"> </font><span style="color:blue;">void</span><font color="#000000"> CopyPropertiesFrom(</font><span style="color:blue;">object</span><font color="#000000"> source, </font><span style="color:#2b91af;">List</span><font color="#000000"><</font><span style="color:blue;">string</span><font color="#000000">> ignoreList)</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000"><span>        </span>{</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000"><span>            </span><span style="font-family:Consolas;font-size:9.5pt;">ignoreList = ignoreList ?? <span style="color:blue;">new</span> <span style="color:#2b91af;">List</span><<span style="color:blue;">string</span>>();</span></font></span></p>
<p></font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000"> </font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span><font color="#000000">            </font></span><span style="color:blue;">foreach</span><font color="#000000"> (</font><span style="color:blue;">var</span><font color="#000000"> property </font><span style="color:blue;">in</span><font color="#000000"> source.GetType().GetProperties().Where(p => p.CanRead))</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000"><span>            </span>{</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span><font color="#000000">                </font></span><span style="color:blue;">var</span><font color="#000000"> key = property.Name;</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span><font color="#000000">                </font></span><span style="color:blue;">if</span><font color="#000000"> (!ignoreList.Contains(key))</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000"><span>                </span>{</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000"><span>                   </span><span> </span></font><span style="color:blue;">var</span><font color="#000000"> value = property.GetValue(source, </font><span style="color:blue;">null</span><font color="#000000">);</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span><font color="#000000">                    </font></span><span style="color:blue;">this</span><font color="#000000">.Properties[key] = value;</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000"><span>                </span>}</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000"><span>            </span>}</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000"><span>        </span>}</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000"> </font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span><font color="#000000">        </font></span><span style="color:blue;">public</span><font color="#000000"> </font><span style="color:blue;">void</span><font color="#000000"> CopyPropertiesTo(</font><span style="color:blue;">object</span><font color="#000000"> destination, </font><span style="color:#2b91af;">List</span><font color="#000000"><</font><span style="color:blue;">string</span><font color="#000000">> ignoreList)</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000"><span>        </span>{</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000"><span>            </span><span style="font-family:Consolas;font-size:9.5pt;">ignoreList = ignoreList ?? <span style="color:blue;">new</span> <span style="color:#2b91af;">List</span><<span style="color:blue;">string</span>>();</span></font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000"> </font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span><font color="#000000">            </font></span><span style="color:blue;">var</span><font color="#000000"> destProps = destination.GetType().GetProperties().ToList();</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span><font color="#000000">            </font></span><span style="color:blue;">this</span><font color="#000000">.Properties.Keys.ToList().ForEach(key =></font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000"><span>            </span>{</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000"></font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000"><span>         </span><span>       </span></font><span style="color:blue;">if</span><font color="#000000"> (!ignoreList.Contains(key))</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000"><span>                </span>{</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span><font color="#000000">                    </font></span><span style="color:blue;">var</span><font color="#000000"> value = </font><span style="color:blue;">this</span><font color="#000000">.Properties[key];</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000"> </font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span><font color="#000000">                    </font></span><span style="color:blue;">var</span><font color="#000000"> property = destProps.Where(p => p.CanWrite &#038;&#038;</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000"><span>                                                   </span>p.Name == key &#038;&#038;</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000"><span>                                                   </span>p.PropertyType == value.GetType()).FirstOrDefault();</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span><font color="#000000">                    </font></span><span style="color:blue;">if</span><font color="#000000"> (property != </font><span style="color:blue;">null</span><font color="#000000">)</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000"><span>                    </span>{</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000"><span>         </span><span>               </span>property.SetValue(destination, value, </font><span style="color:blue;">null</span><font color="#000000">);</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000"><span>                    </span>}</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000"><span>                </span>}</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000"><span>            </span>});</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000"><span>        </span>}</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000"><span>    </span>}</font></span></p>
<p style="line-height:normal;margin:0;">
<p>  </p>
<p style="line-height:normal;margin:0;"> </p>
<p style="line-height:normal;margin:0;">There is no spoon&#8230;</p>
<p style="line-height:normal;margin:0;"> </p>
<p style="line-height:normal;margin:0;">Enjoy&#8230;</p>
</div>
</div>
