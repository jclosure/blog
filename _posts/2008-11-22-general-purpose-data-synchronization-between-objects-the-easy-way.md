---
layout: post
title: "General Purpose Data Synchronization Between Objects – The Easy Way"
date: 2008-11-22 02:37:48 -0600
categories: []
tags: []
wordpress_id: 23
original_url: "https://joelholder.com/2008/11/22/general-purpose-data-synchronization-between-objects-the-easy-way/"
---
<div id="msgcns!3FC3980D58CF7EFB!229" class="bvMsg">
<p style="margin:0;"><span style="font-size:10pt;color:blue;font-family:'Courier New';"></span><font face="Arial"><strong>  </strong></font></p>
<div style="margin:0;"><font size="1"><font face="Segoe UI"><span style="font-size:10pt;color:blue;font-family:'Courier New';"><font color="#262626">When moving messages between systems, I&#8217;ve often found myself confronted with the need to copy values from one object representation to another.  The objects may or may not have any Properties whose names and Types match, so the solution to this problem must be tolerant of incongruent data shapes.  This can always be achieved by writing specific Type mapping and converter classes to do this work, however I wanted to deal with this problem in the most generic way possible.  With the aim of flexibility being the main goal, I present a solution that can synchronize properties between objects accurately,  and yet is generic enough to work with any two objects.  I do not require nor enforce any data contract(s) between the objects being synchronized, such as by implementing a common interface or inheriting from a common base class.  </font></span></font></font></div>
<div style="margin:0;"><font face="Tahoma"></font> </div>
<div style="margin:0;"><span style="font-size:10pt;color:blue;font-family:'Courier New';"><font color="#000000"></font></span><font face="Tahoma">  example 1:</font></div>
<div style="margin:0;"><font face="Tahoma"><font color="#2b91af" size="2"><font color="#2b91af" size="2"></p>
<p>SomeObjectA</font></font><font color="#000000" size="2"> sourceObjRef = </font><font color="#0000ff" size="2"><font color="#0000ff" size="2">new</font></font><font color="#000000" size="2"> </font><font color="#2b91af" size="2"><font color="#2b91af" size="2">SomeObjectA</font></font><font size="2"><font color="#000000">();<font color="#2b91af"> </font></font></font></p>
<p><font size="2"><font color="#000000"><font color="#2b91af">SomeObjectB</font><font color="#000000" size="2"> </font><font color="#000000" size="2">targetObjRef = </font><font color="#0000ff" size="2"><font color="#0000ff" size="2">new</font></font><font color="#000000" size="2"> </font><font color="#2b91af" size="2"><font color="#2b91af" size="2">SomeObjectB</font></font><font size="2"><font color="#000000">();</font></font></font></font><font size="2"> </p>
<p></font><font color="#0000ff" size="2"><font color="#0000ff" size="2">new</font></font><font size="2"> </font><font color="#2b91af" size="2"><font color="#2b91af" size="2"><span style="color:#2b91af;"><font face="Courier New">ReflectionSynchronizer</font></span></font></font><font size="2">().Sync(sourceObjRef , targetObjRef ); </font></p>
<p></font></div>
<div style="margin:0;"><font face="Tahoma"></font> </div>
<div style="margin:0;"><font face="Tahoma"></font> </div>
<div style="margin:0;"><font face="Tahoma">example 2:</font></div>
<div style="margin:0;"><font face="Tahoma"></font> </div>
<div style="margin:0;"><font face="Tahoma"><font color="#2b91af" size="2"></font></p>
<p><font color="#000000" size="2"><font color="#2b91af">IDictionary </font>sourceDictionary = </font><font color="#0000ff" size="2"><font color="#0000ff" size="2">new</font></font><font color="#000000" size="2"> </font><font color="#2b91af" size="2"><font color="#2b91af" size="2">Hashtable</font></font><font size="2"><font color="#000000">();<font color="#2b91af"> </font></font></font></p>
<p><font size="2"><font color="#000000"><font color="#2b91af">SomeObject</font><font color="#000000" size="2"> </font><font color="#000000" size="2">targetObjRef = </font><font color="#0000ff" size="2"><font color="#0000ff" size="2">new</font></font><font color="#000000" size="2"> </font><font color="#2b91af" size="2"><font color="#2b91af" size="2">SomeObject</font></font><font size="2"><font color="#000000">();</font></font></font></font><font size="2"> </p>
<p></font><font color="#0000ff" size="2"><font color="#0000ff" size="2">new</font></font><font size="2"> </font><font color="#2b91af" size="2"><font color="#2b91af" size="2"><span style="color:#2b91af;"><font face="Courier New">ReflectionSynchronizer</font></span></font></font><font size="2">().Sync(sourceDictionary , targetObjRef );</font>  </p>
<p>here is the class: </p>
</p>
<p></font> </div>
<p style="margin:0;"><span style="font-size:10pt;color:blue;font-family:'Courier New';">using</span><span style="font-size:10pt;font-family:'Courier New';"><font color="#000000"> System;</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;color:blue;font-family:'Courier New';">using</span><span style="font-size:10pt;font-family:'Courier New';"><font color="#000000"> System.Collections.Generic;</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;color:blue;font-family:'Courier New';">using</span><span style="font-size:10pt;font-family:'Courier New';"><font color="#000000"> System.Linq;</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;color:blue;font-family:'Courier New';">using</span><span style="font-size:10pt;font-family:'Courier New';"><font color="#000000"> System.Web;</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;color:blue;font-family:'Courier New';">using</span><span style="font-size:10pt;font-family:'Courier New';"><font color="#000000"> System.Reflection;</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;color:blue;font-family:'Courier New';">using</span><span style="font-size:10pt;font-family:'Courier New';"><font color="#000000"> System.Diagnostics;</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;color:blue;font-family:'Courier New';">using</span><span style="font-size:10pt;font-family:'Courier New';"><font color="#000000"> System.Collections;</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><font color="#000000"> </font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;color:blue;font-family:'Courier New';">namespace</span><span style="font-size:10pt;font-family:'Courier New';"><font color="#000000"> Helpers</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><font color="#000000">{</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><span><font color="#000000">    </font></span><span style="color:blue;">public</span><font color="#000000"> </font><span style="color:blue;">class</span><font color="#000000"> </font><span style="color:#2b91af;">ReflectionSynchronizer</span></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><font color="#000000"><span>    </span>{</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><span><font color="#000000">        </font></span><span style="color:gray;">///</span><span style="color:green;"> </span><span style="color:gray;"></p>
<summary></span></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><span><font color="#000000">        </font></span><span style="color:gray;">///</span><span style="color:green;"> synchronizes a Dictionary to an objects properties</span></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><span><font color="#000000">        </font></span><span style="color:gray;">///</span><span style="color:green;"> uses reflection to figure out types to convert objects in entry.Value to when setting object&#8217;s properties</span></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><span><font color="#000000">        </font></span><span style="color:gray;">///</span><span style="color:green;"> </span><span style="color:gray;"></summary>
<p></span></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><span><font color="#000000">        </font></span><span style="color:gray;">///</span><span style="color:green;"> </span><span style="color:gray;"><param name="source"></param></span></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><span><font color="#000000">        </font></span><span style="color:gray;">///</span><span style="color:green;"> </span><span style="color:gray;"><param name="target"></param></span></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><span><font color="#000000">        </font></span><span style="color:blue;">public</span><span><font color="#000000">  </font></span><span style="color:blue;">void</span><font color="#000000"> Sync(</font><span style="color:#2b91af;">IDictionary</span><font color="#000000"> source, </font><span style="color:blue;">object</span><font color="#000000"> target)</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><font color="#000000"><span>        </span>{</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><span><font color="#000000">            </font></span><span style="color:blue;">foreach</span><font color="#000000"> (</font><span style="color:#2b91af;">DictionaryEntry</span><font color="#000000"> entry </font><span style="color:blue;">in</span><font color="#000000"> source)</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><font color="#000000"><span>            </span>{</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><span><font color="#000000">                </font></span><span style="color:blue;">try</span></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><font color="#000000"><span>                </span>{</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><span><font color="#000000">                        </font></span><span style="color:#2b91af;">PropertyInfo</span><font color="#000000"> targetObjectProperty = target.GetType().GetProperty(entry.Key.ToString());</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><font color="#000000"> </font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><font color="#000000"><span>   </span><span>                     </span></font><span style="color:blue;">if</span><font color="#000000"> (targetObjectProperty != </font><span style="color:blue;">null</span><font color="#000000">)</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><font color="#000000"><span>                        </span>{</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><span><font color="#000000">                            </font></span><span style="color:blue;">object</span><font color="#000000"> sourceObjectValue = entry.Value;</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><font color="#000000"> </font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><span><font color="#000000">                            </font></span><span style="color:blue;">if</span><font color="#000000"> (sourceObjectValue != </font><span style="color:blue;">null</span><font color="#000000">)</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><font color="#000000"><span>                            </span>{</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><font color="#000000"><span>                 </span><span>               </span></font><span style="color:green;">//does handle nullable types &#8211; see overload for known in advanced</span></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><span><font color="#000000">                                </font></span><span style="color:blue;">object</span><font color="#000000"> valueToAssign = </font><span style="color:blue;">null</span><font color="#000000">;</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><font color="#000000"><span>                                </span>To(sourceObjectValue, </font><span style="color:blue;">out</span><font color="#000000"> valueToAssign, sourceObjectValue.GetType());</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><font color="#000000"> </font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><font color="#000000"><span>          </span><span>                      </span></font><span style="color:blue;">if</span><font color="#000000"> (valueToAssign != </font><span style="color:blue;">null</span><font color="#000000">)</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><font color="#000000"><span>                                </span>{</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><font color="#000000"><span>                                    </span>targetObjectProperty.SetValue(target, valueToAssign, </font><span style="color:blue;">null</span><font color="#000000">);</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><font color="#000000"><span>                                </span>}</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><font color="#000000"><span>                            </span>}</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><font color="#000000"><span>                        </span>}</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><font color="#000000"><span>                </span>}</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><span><font color="#000000">                </font></span><span style="color:blue;">catch</span><font color="#000000"> (</font><span style="color:#2b91af;">ApplicationException</span><font color="#000000"> ex)</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><font color="#000000"><span>                </span>{</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><span><font color="#000000">                    </font></span><span style="color:#2b91af;">Debug</span><font color="#000000">.WriteLine(ex.Message);</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><font color="#000000"><span>                </span>}</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><font color="#000000"><span>            </span>}</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><font color="#000000"><span>        </span>}</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><font color="#000000"> </font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><span><font color="#000000">        </font></span><span style="color:gray;">///</span><span style="color:green;"> </span><span style="color:gray;"></p>
<summary></span></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><span><font color="#000000">        </font></span><span style="color:gray;">///</span><span style="color:green;"> synchronizes an object reference&#8217;s properties&#8217; values to another object reference&#8217;s properties&#8217; values</span></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><span><font color="#000000">        </font></span><span style="color:gray;">///</span><span style="color:green;"> </span><span style="color:gray;"></summary>
<p></span></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><span><font color="#000000">        </font></span><span style="color:gray;">///</span><span style="color:green;"> </span><span style="color:gray;"><param name="source"></param></span></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><span><font color="#000000">        </font></span><span style="color:gray;">///</span><span style="color:green;"> </span><span style="color:gray;"><param name="target"></param></span></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><span><font color="#000000">        </font></span><span style="color:blue;">public</span><span><font color="#000000">  </font></span><span style="color:blue;">void</span><font color="#000000"> Sync(</font><span style="color:blue;">object</span><font color="#000000"> source, </font><span style="color:blue;">object</span><font color="#000000"> target)</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><font color="#000000"><span>        </span>{</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><span><font color="#000000">            </font></span><span style="color:blue;">foreach</span><font color="#000000"> (</font><span style="color:#2b91af;">PropertyInfo</span><font color="#000000"> sourceObjectProperty </font><span style="color:blue;">in</span><font color="#000000"> source.GetType().GetProperties())</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><font color="#000000"><span>            </span>{</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><span><font color="#000000">                </font></span><span style="color:blue;">try</span></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><font color="#000000"><span>                </span>{</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><span><font color="#000000">                    </font></span><span style="color:#2b91af;">PropertyInfo</span><font color="#000000"> targetObjectProperty = target.GetType().GetProperty(sourceObjectProperty.Name);</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><font color="#000000"> </font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><span><font color="#000000">                    </font></span><span style="color:blue;">if</span><font color="#000000"> (targetObjectProperty != </font><span style="color:blue;">null</span><font color="#000000"> &#038;&#038; targetObjectProperty.PropertyType.Equals(sourceObjectProperty.PropertyType))</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><font color="#000000"><span>                    </span>{</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><span><font color="#000000">                        </font></span><span style="color:blue;">object</span><font color="#000000"> sourceObjectValue = sourceObjectProperty.GetValue(source, </font><span style="color:blue;">null</span><font color="#000000">);</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><font color="#000000"> </font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><span><font color="#000000">                        </font></span><span style="color:blue;">if</span><font color="#000000"> (sourceObjectValue != </font><span style="color:blue;">null</span><font color="#000000">)</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><font color="#000000"><span>                        </span>{</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><span><font color="#000000">                            </font></span><span style="color:green;">//does handle nullable types &#8211; see overload for known in advanced</span></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><span><font color="#000000">                            </font></span><span style="color:blue;">object</span><font color="#000000"> valueToAssign = </font><span style="color:blue;">null</span><font color="#000000">;</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><font color="#000000"><span>                            </span>To(sourceObjectValue, </font><span style="color:blue;">out</span><font color="#000000"> valueToAssign, sourceObjectValue.GetType());</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><font color="#000000"> </font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><span><font color="#000000">                            </font></span><span style="color:blue;">if</span><font color="#000000"> (valueToAssign != </font><span style="color:blue;">null</span><font color="#000000">)</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><font color="#000000"><span>                            </span>{</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><font color="#000000"><span>                                </span>targetObjectProperty.SetValue(target, valueToAssign, </font><span style="color:blue;">null</span><font color="#000000">);</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><font color="#000000"><span>                            </span>}</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><font color="#000000"><span>                        </span>}</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><font color="#000000"><span>                    </span>}</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><font color="#000000"> </font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><font color="#000000"><span>                </span>}</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><span><font color="#000000">                </font></span><span style="color:blue;">catch</span><font color="#000000"> (</font><span style="color:#2b91af;">ApplicationException</span><font color="#000000"> ex)</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><font color="#000000"><span>                </span>{</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><span><font color="#000000">                    </font></span><span style="color:#2b91af;">Debug</span><font color="#000000">.WriteLine(ex.Message);</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><font color="#000000"><span>                </span>}</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><font color="#000000"><span>     </span><span>       </span>}</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><font color="#000000"><span>        </span>}</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><font color="#000000"> </font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><span><font color="#000000">        </font></span><span style="color:gray;">///</span><span style="color:green;"> </span><span style="color:gray;"></p>
<summary></span></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><span><font color="#000000">        </font></span><span style="color:gray;">///</span><span style="color:green;"> copies a value to another </span></span></p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><span><font color="#000000">        </font></span><span style="color:gray;">///</span><span style="color:green;"> </span><span style="color:gray;"></summary>
<p></span></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><span><font color="#000000">        </font></span><span style="color:gray;">///</span><span style="color:green;"> </span><span style="color:gray;"><param name="srcValue"></param></span></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><span><font color="#000000">        </font></span><span style="color:gray;">///</span><span style="color:green;"> </span><span style="color:gray;"><param name="targetValue"></param></span></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><span><font color="#000000">        </font></span><span style="color:gray;">///</span><span style="color:green;"> </span><span style="color:gray;"><param name="t"></param></span></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><span><font color="#000000">        </font></span><span style="color:blue;">public</span><span><font color="#000000">  </font></span><span style="color:blue;">void</span><font color="#000000"> To(</font><span style="color:blue;">object</span><font color="#000000"> srcValue, </font><span style="color:blue;">out</span><font color="#000000"> </font><span style="color:blue;">object</span><font color="#000000"> targetValue, </font><span style="color:#2b91af;">Type</span><font color="#000000"> t)</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><font color="#000000"><span>        </span>{</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><font color="#000000"><span>            </span>targetValue = </font><span style="color:blue;">null</span><font color="#000000">;</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><span><font color="#000000">            </font></span><span style="color:blue;">if</span><font color="#000000"> (srcValue == </font><span style="color:#2b91af;">DBNull</span><font color="#000000">.Value) </font><span style="color:blue;">return</span><font color="#000000">;</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><font color="#000000"> </font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><span><font color="#000000">            </font></span><span style="color:blue;">if</span><font color="#000000"> (IsNullable(t))</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><font color="#000000"><span>            </span>{</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><span><font color="#000000">                </font></span><span style="color:blue;">if</span><font color="#000000"> (srcValue == </font><span style="color:blue;">null</span><font color="#000000">)</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><font color="#000000"><span>                </span>{</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><span><font color="#000000">                    </font></span><span style="color:blue;">return</span><font color="#000000">;</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><font color="#000000"><span>                </span>}</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><font color="#000000"><span>                </span>targetValue = UnderlyingTypeOf(t);</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><font color="#000000"><span>            </span>}</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><font color="#000000"> </font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><font color="#000000"><span>            </span>targetValue = </font><span style="color:#2b91af;">Convert</span><font color="#000000">.ChangeType(srcValue, t);</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><font color="#000000"><span>        </span>}</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><font color="#000000"> </font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><span><font color="#000000">        </font></span><span style="color:gray;">///</span><span style="color:green;"> </span><span style="color:gray;"></p>
<summary></span></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><span><font color="#000000">        </font></span><span style="color:gray;">///</span><span style="color:green;"> generic version of To</span></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><span><font color="#000000">        </font></span><span style="color:gray;">///</span><span style="color:green;"> </span><span style="color:gray;"></summary>
<p></span></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><span><font color="#000000">        </font></span><span style="color:gray;">///</span><span style="color:green;"> </span><span style="color:gray;"><typeparam name="T"></typeparam></span></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><span><font color="#000000">        </font></span><span style="color:gray;">///</span><span style="color:green;"> </span><span style="color:gray;"><param name="value"></param></span></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><span><font color="#000000">        </font></span><span style="color:gray;">///</span><span style="color:green;"> </span><span style="color:gray;"><param name="defaultValue"></param></span></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><span><font color="#000000">        </font></span><span style="color:gray;">///</span><span style="color:green;"> </span><span style="color:gray;"><returns></returns></span></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><span><font color="#000000">        </font></span><span style="color:blue;">public</span><font color="#000000"><span>  </span>T To<T>(</font><span style="color:blue;">object</span><font color="#000000"> value, T defaultValue)</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><font color="#000000"><span>        </span>{</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><span><font color="#000000">            </font></span><span style="color:blue;">if</span><font color="#000000"> (value == </font><span style="color:#2b91af;">DBNull</span><font color="#000000">.Value) </font><span style="color:blue;">return</span><font color="#000000"> defaultValue;</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><span><font color="#000000">            </font></span><span style="color:#2b91af;">Type</span><font color="#000000"> t = </font><span style="color:blue;">typeof</span><font color="#000000">(T);</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><span><font color="#000000">            </font></span><span style="color:blue;">if</span><font color="#000000"> (IsNullable(t))</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><font color="#000000"><span>            </span>{</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><span><font color="#000000">                </font></span><span style="color:blue;">if</span><font color="#000000"> (value == </font><span style="color:blue;">null</span><font color="#000000">) </font><span style="color:blue;">return</span><font color="#000000"> </font><span style="color:blue;">default</span><font color="#000000">(T); </font></span></p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><font color="#000000"><span>                </span>t = UnderlyingTypeOf(t);</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><font color="#000000"><span>            </span>}</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><font color="#000000"> </font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><span><font color="#000000">            </font></span><span style="color:blue;">return</span><font color="#000000"> (T)</font><span style="color:#2b91af;">Convert</span><font color="#000000">.ChangeType(value, t);</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><font color="#000000"><span>        </span>}</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><font color="#000000"> </font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><span><font color="#000000">        </font></span><span style="color:gray;">///</span><span style="color:green;"> </span><span style="color:gray;"></p>
<summary></span></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><span><font color="#000000">        </font></span><span style="color:gray;">///</span><span style="color:green;"> figures out if the Type is Nullable&#8221;/></span></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><span><font color="#000000">        </font></span><span style="color:gray;">///</span><span style="color:green;"> </span><span style="color:gray;"></summary>
<p></span></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><span><font color="#000000">        </font></span><span style="color:gray;">///</span><span style="color:green;"> </span><span style="color:gray;"><param name="t"></param></span></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><span><font color="#000000">        </font></span><span style="color:gray;">///</span><span style="color:green;"> </span><span style="color:gray;"><returns></returns></span></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><span><font color="#000000">        </font></span><span style="color:blue;">private</span><span><font color="#000000">  </font></span><span style="color:blue;">bool</span><font color="#000000"> IsNullable(</font><span style="color:#2b91af;">Type</span><font color="#000000"> t)</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><font color="#000000"><span>        </span>{</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><font color="#000000"><span>      </span><span>      </span></font><span style="color:blue;">if</span><font color="#000000"> (!t.IsGenericType) </font><span style="color:blue;">return</span><font color="#000000"> </font><span style="color:blue;">false</span><font color="#000000">;</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><span><font color="#000000">            </font></span><span style="color:#2b91af;">Type</span><font color="#000000"> g = t.GetGenericTypeDefinition();</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><span><font color="#000000">            </font></span><span style="color:blue;">return</span><font color="#000000"> (g.Equals(</font><span style="color:blue;">typeof</span><font color="#000000">(</font><span style="color:#2b91af;">Nullable</span><font color="#000000"><>)));</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><font color="#000000"><span>        </span>}</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><font color="#000000"> </font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><span><font color="#000000">        </font></span><span style="color:gray;">///</span><span style="color:green;"> </span><span style="color:gray;"></p>
<summary></span></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><span><font color="#000000">        </font></span><span style="color:gray;">///</span><span style="color:green;"> gets the underlying Type</span></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><span><font color="#000000">        </font></span><span style="color:gray;">///</span><span style="color:green;"> </span><span style="color:gray;"></summary>
<p></span></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><span><font color="#000000">        </font></span><span style="color:gray;">///</span><span style="color:green;"> </span><span style="color:gray;"><param name="t"></param></span></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><span><font color="#000000">        </font></span><span style="color:gray;">///</span><span style="color:green;"> </span><span style="color:gray;"><returns></returns></span></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><span><font color="#000000">        </font></span><span style="color:blue;">private</span><span><font color="#000000">  </font></span><span style="color:#2b91af;">Type</span><font color="#000000"> UnderlyingTypeOf(</font><span style="color:#2b91af;">Type</span><font color="#000000"> t)</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><font color="#000000"><span>        </span>{</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><span><font color="#000000">            </font></span><span style="color:blue;">return</span><font color="#000000"> t.GetGenericArguments()[0];</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><font color="#000000"><span>        </span>}</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><font color="#000000"> </font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><font color="#000000"> </font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><font color="#000000"> </font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><font color="#000000"> </font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><font color="#000000"> </font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><font color="#000000"><span>    </span>}</font></span> </p>
<p style="margin:0;"><span style="font-size:10pt;font-family:'Courier New';"><font color="#000000">}</font></span> </p>
<p style="margin:0;"><font face="Calibri" color="#000000" size="3"> </font></p>
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
</div>
