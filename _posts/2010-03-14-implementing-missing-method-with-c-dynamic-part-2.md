---
layout: post
title: "Implementing method_missing with C# dynamic – Part 2"
date: 2010-03-14 14:53:48 -0600
categories: []
tags: []
wordpress_id: 9
original_url: "https://joelholder.com/2010/03/14/implementing-missing_method-with-c-dynamic-part-2/"
---
<div id="msgcns!3FC3980D58CF7EFB!518" class="bvMsg">
<div>
<p style="margin:0 0 10pt;"><font size="3"><font face="Calibri"><span style="color:black;">In my previous post,</span><font color="#000000"> </font></font></font><a href="http://uberpwn.spaces.live.com/blog/cns!3FC3980D58CF7EFB!516.entry"><span style="color:purple;"><u><font size="3" face="Calibri">Implementing method_missing with C# dynamic &#8211; Part 1</font></u></span></a><span style="color:black;"><font size="3"><font face="Calibri">, I demonstrated a simple approach to plugging a method_missing call routing seam into a DynamicObject.  Here I&#8217;ll take it a step further to implement a generic method_missing function capable of passing any call to a forwarding context object.  Note that I do not have to define the method_missing in the calling code; its now automatically setup for me in DynamicObject itself.</font></font></span></p>
</div>
<div>              </div>
<div><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000"></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;">[<span style="color:#2b91af;">TestMethod</span>]</span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;color:blue;font-size:9.5pt;">public</span><span style="font-family:Consolas;font-size:9.5pt;"> <span style="color:blue;">void</span> Can_Forward_Through_Default_Missing_Method()</span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;">{</span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span>    </span><span style="color:blue;">dynamic</span> dispatcher1 = <span style="color:blue;">new</span> <span style="color:#2b91af;"><span style="color:#2b91af;">ExpandableDispatcher</span></span>();</span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span>    </span><span style="color:blue;">dynamic</span> dispatcher2 = <span style="color:blue;">new</span> <span style="color:#2b91af;"><span style="color:#2b91af;">ExpandableDispatcher</span></span>();</span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span>    </span><span style="color:blue;">dynamic</span> dispatcher3 = <span style="color:blue;">new</span> <span style="color:#2b91af;"><span style="color:#2b91af;">ExpandableDispatcher</span></span>();</span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"> </span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span>    </span><span style="color:green;">//configure forwarding</span></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span>    </span><span style="font-family:Consolas;font-size:9.5pt;">dispatcher1.ForwardContext = dispatcher2;</span></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span>    </span>dispatcher2.ForwardContext = dispatcher3;</span></p>
<p style="line-height:normal;margin:0;"></font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"> </span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span>    </span><span style="color:green;">//set responder on dispatcher3</span></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span>    </span>dispatcher3.Methods[<span style="color:#a31515;">&#8220;RunMeta&#8221;</span>] = <span style="color:blue;">new</span> <span style="color:#2b91af;">Func</span><<span style="color:blue;">string</span>, <span style="color:blue;">string</span>>(param =></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span>    </span>{</span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span>        </span><span style="color:blue;">return</span> <span style="color:#a31515;">&#8220;Meta said &#8220;</span> + param;</span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span>    </span>});</span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"> </span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span>    </span><span style="color:green;">//try to execute the responder from dispatcher1</span></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span>    </span><span style="color:blue;">var</span> response = dispatcher1.RunMeta(<span style="color:#a31515;">&#8220;I am a probe..&#8221;</span>);</span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"> </span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span>    </span><span style="color:#2b91af;">Assert</span>.IsTrue(response == <span style="color:#a31515;">&#8220;Meta said I am a probe..&#8221;</span>);</span></p>
<p style="line-height:normal;margin:0;"><span style="line-height:115%;font-family:Consolas;font-size:9.5pt;">}</span></p>
</div>
<div>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000"> </font></span></p>
<p><span style="line-height:115%;font-family:Consolas;font-size:9.5pt;"><font color="#000000"></font></span></div>
<div>
<p style="margin:0 0 10pt;"><font size="3"><font face="Calibri"><span style="color:black;">The implementation of ExpandableDispatcher contains a DynamicObject reference called ForwardContext.  This handle is for forwarding messages that cannot be responded to by the</span><font color="#000000"> </font></font></font><span style="line-height:115%;font-family:Consolas;color:blue;font-size:10pt;">this</span><span style="color:black;"><font size="3" face="Calibri"> in the current execution context.  Note that in the ctor, the dispatcher sets up its own, method_missing.  </font></span></p>
</div>
<div> </div>
<p style="line-height:normal;margin:0;">
<p><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000"></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;color:blue;font-size:9.5pt;">public</span><span style="font-family:Consolas;font-size:9.5pt;"> <span style="color:blue;">class</span> <span style="color:#2b91af;">ExpandableDispatcher</span> : <span style="color:#2b91af;">DynamicObject</span></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;">{</span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span>    </span><span style="color:#2b91af;">DynamicObject</span> forwardContext;</span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"> </span></p>
<p><span style="font-family:Consolas;font-size:9.5pt;"></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;color:blue;font-size:9.5pt;">    public</span><span style="font-family:Consolas;font-size:9.5pt;"> <span style="color:#2b91af;">DynamicObject</span> ForwardContext</span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span>    </span>{</span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span>        </span><span style="color:blue;">get</span> { <span style="color:blue;">return</span> forwardContext; }</span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span>        </span><span style="color:blue;">set</span> { forwardContext = <span style="color:blue;">value</span>; }</span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span>    </span>}</span></p>
<p style="line-height:normal;margin:0;">
<p></span><span style="font-family:Consolas;font-size:9.5pt;"></span>  </p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span>    </span><span style="color:#2b91af;">IDictionary</span><<span style="color:blue;">string</span>, <span style="color:blue;">object</span>> _methods = <span style="color:blue;">new</span> <span style="color:#2b91af;">Dictionary</span><<span style="color:blue;">string</span>, <span style="color:blue;">object</span>>();</span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"> </span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span>    </span><span style="color:blue;">public</span> <span style="color:#2b91af;">IDictionary</span><<span style="color:blue;">string</span>, <span style="color:blue;">object</span>> Methods</span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span>    </span>{</span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span>        </span><span style="color:blue;">get</span> { <span style="color:blue;">return</span> _methods; }</span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span>        </span><span style="color:blue;">set</span> { _methods = <span style="color:blue;">value</span>; }</span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span>    </span>}</span><span style="font-family:Consolas;font-size:9.5pt;"> </span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span>    </span></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;color:blue;font-size:9.5pt;">    public</span><span style="font-family:Consolas;font-size:9.5pt;"> ExpandableDispatcher()</span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span>    </span>{</span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"> </span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span>        </span><span style="color:green;">//setup default method_missing</span></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span>        </span><span style="color:blue;">this</span>._methods[<span style="color:#a31515;">&#8220;method_missing&#8221;</span>] = <span style="color:blue;">new</span> <span style="color:#2b91af;">Func</span><<span style="color:#2b91af;">DynamicObject</span>, <span style="color:#2b91af;">InvokeMemberBinder</span>, <span style="color:blue;">object</span>[], <span style="color:blue;">object</span>>((contextObject, binder, args) =></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span>        </span>{</span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"> </span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span>            </span><span style="color:blue;">dynamic</span> context = contextObject;</span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"> </span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span>            </span><span style="color:blue;">var</span> method = context.Methods.ContainsKey(binder.Name) ? context.Methods[binder.Name] : <span style="color:blue;">null</span>;</span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span>            </span><span style="color:blue;">var</span> method_missing = context.Methods.ContainsKey(<span style="color:#a31515;">&#8220;method_missing&#8221;</span>) ? context.Methods[<span style="color:#a31515;">&#8220;method_missing&#8221;</span>] : <span style="color:blue;">null</span>;</span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"> </span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span>            </span><span style="color:blue;">if</span> (method != <span style="color:blue;">null</span>)</span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span>            </span>{</span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span>                </span><span style="color:blue;">if</span> (method.ToString().StartsWith(<span style="color:#a31515;">&#8220;System.Action&#8221;</span>))</span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span>                </span>{</span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span>                    </span>RunAction(method, args);</span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span>                </span>}</span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span>                </span><span style="color:blue;">else</span></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span>                </span>{</span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span>                    </span><span style="color:blue;">return</span> RunFunc(method, args);</span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span>                </span>}</span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span>            </span>}</span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span>            </span><span style="color:blue;">else</span> <span style="color:blue;">if</span> (method_missing != <span style="color:blue;">null</span>)</span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span>            </span>{</span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span>                </span><span style="color:blue;">return</span> method_missing(context.ForwardContext, binder, args);</span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span>            </span>}</span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"> </span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span>            </span><span style="color:blue;">return</span> <span style="color:blue;">null</span>;</span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span>        </span>});</span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span>    </span>}</span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"> </span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span>    </span><span style="color:blue;">private</span> <span style="color:blue;">object</span> RunFunc(<span style="color:blue;">dynamic</span> method, <span style="color:blue;">object</span>[] args)</span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span>    </span>{</span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span>        </span><span style="color:blue;">switch</span> (args.Length)</span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span>        </span>{</span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span>            </span><span style="color:blue;">case</span> <span style="color:brown;">0</span>:</span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span>                </span><span style="color:blue;">return</span> method();</span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span>            </span><span style="color:blue;">case</span> <span style="color:brown;">1</span>:</span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span>                </span><span style="color:blue;">return</span> method(args[<span style="color:brown;">0</span>]);</span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span>            </span><span style="color:blue;">case</span> <span style="color:brown;">2</span>:</span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span>                </span><span style="color:blue;">return</span> method(args[<span style="color:brown;">0</span>], args[<span style="color:brown;">1</span>]);</span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span>            </span><span style="color:blue;">case</span> <span style="color:brown;">3</span>:</span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span>                </span><span style="color:blue;">return</span> method(args[<span style="color:brown;">0</span>], args[<span style="color:brown;">1</span>], args[<span style="color:brown;">2</span>]);</span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span>            </span><span style="color:blue;">case</span> <span style="color:brown;">4</span>:</span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span>                </span><span style="color:blue;">return</span> method(args[<span style="color:brown;">0</span>], args[<span style="color:brown;">1</span>], args[<span style="color:brown;">2</span>], args[<span style="color:brown;">3</span>]);</span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span>            </span><span style="color:blue;">case</span> <span style="color:brown;">5</span>:</span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span>                </span><span style="color:blue;">return</span> method(args[<span style="color:brown;">0</span>], args[<span style="color:brown;">1</span>], args[<span style="color:brown;">2</span>], args[<span style="color:brown;">3</span>], args[<span style="color:brown;">4</span>]);</span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span>        </span>}</span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span>    </span>}</span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"> </span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span>    </span><span style="color:blue;">private</span> <span style="color:blue;">void</span> RunAction(<span style="color:blue;">dynamic</span> method, <span style="color:blue;">object</span>[] args)</span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span>    </span>{</span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span>        </span><span style="color:blue;">switch</span> (args.Length)</span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span>        </span>{</span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span>            </span><span style="color:blue;">case</span> <span style="color:brown;">0</span>:</span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span>                </span>method();</span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span>                </span><span style="color:blue;">break</span>;</span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span>            </span><span style="color:blue;">case</span> <span style="color:brown;">1</span>:</span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span>                </span>method(args[<span style="color:brown;">0</span>]);</span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span>                </span><span style="color:blue;">break</span>;</span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span>            </span><span style="color:blue;">case</span> <span style="color:brown;">2</span>:</span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span>                </span>method(args[<span style="color:brown;">0</span>], args[<span style="color:brown;">1</span>]);</span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span>                </span><span style="color:blue;">break</span>;</span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span>            </span><span style="color:blue;">case</span> <span style="color:brown;">3</span>:</span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span>                </span>method(args[<span style="color:brown;">0</span>], args[<span style="color:brown;">1</span>], args[<span style="color:brown;">2</span>]);</span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span>                </span><span style="color:blue;">break</span>;</span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span>            </span><span style="color:blue;">case</span> <span style="color:brown;">4</span>:</span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span>                </span>method(args[<span style="color:brown;">0</span>], args[<span style="color:brown;">1</span>], args[<span style="color:brown;">2</span>], args[<span style="color:brown;">3</span>]);</span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span>                </span><span style="color:blue;">break</span>;</span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span>            </span><span style="color:blue;">case</span> <span style="color:brown;">5</span>:</span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span>                </span>method(args[<span style="color:brown;">0</span>], args[<span style="color:brown;">1</span>], args[<span style="color:brown;">2</span>], args[<span style="color:brown;">3</span>], args[<span style="color:brown;">4</span>]);</span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span>                </span><span style="color:blue;">break</span>;</span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span>        </span>}</span></p>
<p style="line-height:normal;margin:0;"><span style="line-height:115%;font-family:Consolas;font-size:9.5pt;"><span>    </span>}</span></p>
<p></font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"> </span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span></span></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;color:blue;font-size:9.5pt;">    public</span><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000"> </font><span style="color:blue;">override</span><font color="#000000"> </font><span style="color:blue;">bool</span><font color="#000000"> TryInvokeMember(</font><span style="color:#2b91af;">InvokeMemberBinder</span><font color="#000000"> binder, </font><span style="color:blue;">object</span><font color="#000000">[] args, </font><span style="color:blue;">out</span><font color="#000000"> </font><span style="color:blue;">object</span><font color="#000000"> result)</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000"><span>    </span>{</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span><font color="#000000">        </font></span><span style="color:blue;">if</span><font color="#000000"> (_methods.ContainsKey(binder.Name) &#038;&#038; _methods[binder.Name] </font><span style="color:blue;">is</span><font color="#000000"> </font><span style="color:#2b91af;">Delegate</span><font color="#000000">)</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000"><span>        </span>{</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000"><span>            </span>result = (_methods[binder.Name] </font><span style="color:blue;">as</span><font color="#000000"> </font><span style="color:#2b91af;">Delegate</span><font color="#000000">).DynamicInvoke(args);</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span><font color="#000000">            </font></span><span style="color:blue;">return</span><font color="#000000"> </font><span style="color:blue;">true</span><font color="#000000">;</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000"><span>        </span>}</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span><font color="#000000">        </font></span><span style="color:blue;">else</span><font color="#000000"> </font><span style="color:blue;">if</span><font color="#000000"> (_methods.ContainsKey(</font><span style="color:#a31515;">&#8220;method_missing&#8221;</span><font color="#000000">) &#038;&#038; _methods[</font><span style="color:#a31515;">&#8220;method_missing&#8221;</span><font color="#000000">] </font><span style="color:blue;">is</span><font color="#000000"> </font><span style="color:#2b91af;">Delegate</span><font color="#000000">)</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000"><span>        </span>{</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span><font color="#000000">            </font></span><span style="color:blue;">var</span><font color="#000000"> method_missing = _methods[</font><span style="color:#a31515;">&#8220;method_missing&#8221;</span><font color="#000000">] </font><span style="color:blue;">as</span><font color="#000000"> </font><span style="color:#2b91af;">Delegate</span><font color="#000000">;</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span><font color="#000000">            </font></span><span style="color:blue;">var</span><font color="#000000"> ctxParam = method_missing.Method.GetParameters().Where(p => p.Position == </font><span style="color:brown;">0</span><font color="#000000"> &#038;&#038;</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000"><span>                                                                        </span>p.ParameterType == </font><span style="color:blue;">typeof</span><font color="#000000">(</font><span style="color:#2b91af;">DynamicObject</span><font color="#000000">)).FirstOrDefault();</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span><font color="#000000">            </font></span><span style="color:blue;">if</span><font color="#000000"> (ctxParam != </font><span style="color:blue;">null</span><font color="#000000"> &#038;&#038; forwardContext != </font><span style="color:blue;">null</span><font color="#000000">)</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000"><span>            </span>{</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span><font color="#000000">                </font></span><span style="color:blue;">dynamic</span><font color="#000000"> context = forwardContext;</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000"><span>                </span>result = method_missing.DynamicInvoke(context, binder, args);</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span><font color="#000000">                </font></span><span style="color:blue;">return</span><font color="#000000"> </font><span style="color:blue;">true</span><font color="#000000">;</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000"><span>            </span>}</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span><font color="#000000">            </font></span><span style="color:blue;">else</span></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000"><span>            </span>{</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000"><span>                </span>result = method_missing.DynamicInvoke(binder, args);</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span><font color="#000000">                </font></span><span style="color:blue;">return</span><font color="#000000"> </font><span style="color:blue;">true</span><font color="#000000">;</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000"><span>      </span><span>      </span>}</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000"><span>        </span>}</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span><font color="#000000">        </font></span><span style="color:blue;">else</span></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000"><span>        </span>{</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><span><font color="#000000">            </font></span><span style="color:blue;">return</span><font color="#000000"> </font><span style="color:blue;">base</span><font color="#000000">.TryInvokeMember(binder, args, </font><span style="color:blue;">out</span><font color="#000000"> result);</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000"><span>        </span>}</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000"><span>    </span>}</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000">}</font></span></p>
<p style="line-height:normal;margin:0;"><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000"></font></span> </p>
<p><span style="font-family:Consolas;font-size:9.5pt;"><font color="#000000"></p>
<p style="margin:0 0 10pt;"><span style="line-height:115%;font-family:Consolas;font-size:9.5pt;"><span style="color:black;">For further reading on the topics I discussed and demonstrated in this series,</span><span style="color:black;"> <a href="http://msdn.microsoft.com/en-us/library/ee658247.aspx" target="_blank"><u><font color="#800080">this MSDN article</font></u></a> </span><span style="color:black;">shows a clever approach to creating MethodBags by passing lambda Expressions to a DynamicObject, which are then compiled into Delegates and assigned to to the dynamic itself.  In successive posts, I&#8217;ll be exploring the new extensions to the System.Linq.Expressions.Expression API in .NET 4.0.</span></span></p>
<p style="margin:0 0 10pt;"><span style="line-height:115%;font-family:Consolas;font-size:9.5pt;"><span style="color:black;">Enjoy..</span></span></p>
<p></font></span></div>
