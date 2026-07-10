---
layout: post
title: "EventBusBridges for Great Good"
date: 2016-06-19 02:09:22 -0500
categories: []
tags: []
wordpress_id: 1100
original_url: "https://joelholder.com/2016/06/19/eventbusbridges-for-great-good/"
---
<style>
.entry-content pre,
.entry-content code {
  white-space: pre-wrap;
  overflow-wrap: anywhere;
  word-break: break-word;
}
.entry-content table,
.entry-content img,
.entry-content iframe {
  max-width: 100%;
}
.entry-content {
  overflow-wrap: anywhere;
}
</style>



<p class="wp-block-paragraph">The <a href="http://sockjs.org">SockJS protocol</a> provides a fast and reliable mechanism for providing duplex communication via Websockets.  Vertx has a particularly nice implementation of this in the form of <a href="http://vertx.io/docs/vertx-web/java/#_handling_event_bus_bridge_events">EventBusBridges</a>, which make it easy to create secure communication pipelines between an HttpServer Verticle and a variety of polyglot SockJS clients via Websockets or fallback transports.  Surprisingly, a Java-based EventBusBridgeClient is not among the ootb facilities, even though Java is the main story on the server.  Here I will show you how easy to create your own and a few of the awesome things you can do with it.</p>



<h4 class="wp-block-heading">The EventBusBridge Server</h4>


<div class="wp-block-code">
	<div class="cm-editor">
		<div class="cm-scroller">
			
<pre>
<code class="language-java"><div class="cm-line"><span class="tok-typeName">Router</span> <span class="tok-variableName tok-definition">router</span> <span class="tok-operator">=</span> <span class="tok-variableName">Router</span><span class="tok-operator">.</span><span class="tok-variableName">router</span><span class="tok-punctuation">(</span><span class="tok-variableName">vertx</span><span class="tok-punctuation">)</span><span class="tok-punctuation">;</span></div><div class="cm-line"></div><div class="cm-line"><span class="tok-comment">// Allow all addresses to flow in and out on the bridge</span></div><div class="cm-line"></div><div class="cm-line"><span class="tok-typeName">BridgeOptions</span> <span class="tok-variableName tok-definition">options</span> <span class="tok-operator">=</span> <span class="tok-keyword">new</span> <span class="tok-typeName">BridgeOptions</span><span class="tok-punctuation">(</span><span class="tok-punctuation">)</span></div><div class="cm-line">  <span class="tok-operator">.</span><span class="tok-variableName">addInboundPermitted</span><span class="tok-punctuation">(</span><span class="tok-keyword">new</span> <span class="tok-typeName">PermittedOptions</span><span class="tok-punctuation">(</span><span class="tok-punctuation">)</span><span class="tok-operator">.</span><span class="tok-variableName">setAddressRegex</span><span class="tok-punctuation">(</span><span class="tok-string">&quot;.+&quot;</span><span class="tok-punctuation">)</span><span class="tok-punctuation">)</span></div><div class="cm-line">  <span class="tok-operator">.</span><span class="tok-variableName">addOutboundPermitted</span><span class="tok-punctuation">(</span><span class="tok-keyword">new</span> <span class="tok-typeName">PermittedOptions</span><span class="tok-punctuation">(</span><span class="tok-punctuation">)</span><span class="tok-operator">.</span><span class="tok-variableName">setAddressRegex</span><span class="tok-punctuation">(</span><span class="tok-string">&quot;.+&quot;</span><span class="tok-punctuation">)</span><span class="tok-punctuation">)</span><span class="tok-punctuation">;</span></div><div class="cm-line"></div><div class="cm-line"><span class="tok-variableName">router</span><span class="tok-operator">.</span><span class="tok-variableName">route</span><span class="tok-punctuation">(</span><span class="tok-string">&quot;/eventbus/*&quot;</span><span class="tok-punctuation">)</span><span class="tok-operator">.</span><span class="tok-variableName">handler</span><span class="tok-punctuation">(</span></div><div class="cm-line">  <span class="tok-variableName">SockJSHandler</span><span class="tok-operator">.</span><span class="tok-variableName">create</span><span class="tok-punctuation">(</span><span class="tok-variableName">vertx</span><span class="tok-punctuation">)</span><span class="tok-operator">.</span><span class="tok-variableName">bridge</span><span class="tok-punctuation">(</span><span class="tok-variableName">options</span><span class="tok-punctuation">)</span></div><div class="cm-line"><span class="tok-punctuation">)</span><span class="tok-punctuation">;</span></div><div class="cm-line"></div><div class="cm-line"><span class="tok-comment">// Setup a body handler</span></div><div class="cm-line"><span class="tok-variableName">router</span><span class="tok-operator">.</span><span class="tok-variableName">route</span><span class="tok-punctuation">(</span><span class="tok-punctuation">)</span><span class="tok-operator">.</span><span class="tok-variableName">handler</span><span class="tok-punctuation">(</span><span class="tok-variableName">BodyHandler</span><span class="tok-operator">.</span><span class="tok-variableName">create</span><span class="tok-punctuation">(</span><span class="tok-punctuation">)</span><span class="tok-punctuation">)</span><span class="tok-punctuation">;</span></div><div class="cm-line"></div><div class="cm-line"><span class="tok-typeName">HttpServer</span> <span class="tok-variableName tok-definition">httpServer</span> <span class="tok-operator">=</span> <span class="tok-variableName">vertx</span><span class="tok-operator">.</span><span class="tok-variableName">createHttpServer</span><span class="tok-punctuation">(</span><span class="tok-punctuation">)</span><span class="tok-punctuation">;</span></div><div class="cm-line"><span class="tok-variableName">httpServer</span><span class="tok-operator">.</span><span class="tok-variableName">requestHandler</span><span class="tok-punctuation">(</span><span class="tok-variableName">router</span>::<span class="tok-variableName">accept</span><span class="tok-punctuation">)</span><span class="tok-operator">.</span><span class="tok-variableName">listen</span><span class="tok-punctuation">(</span><span class="tok-number">8080</span><span class="tok-punctuation">)</span><span class="tok-punctuation">;</span></div><div class="cm-line"></div><div class="cm-line"><span class="tok-comment">// do server wiring</span></div><div class="cm-line"></div><div class="cm-line"><span class="tok-comment">// Publish a message to &quot;someaddress&quot; on interval</span></div><div class="cm-line"><span class="tok-variableName">vertx</span><span class="tok-operator">.</span><span class="tok-variableName">setPeriodic</span><span class="tok-punctuation">(</span><span class="tok-number">5000</span><span class="tok-punctuation">,</span> <span class="tok-variableName tok-definition">t</span> -&gt; <span class="tok-punctuation">{</span></div><div class="cm-line">  <span class="tok-typeName">JsonObject</span> <span class="tok-variableName tok-definition">msg</span> <span class="tok-operator">=</span> <span class="tok-keyword">new</span> <span class="tok-typeName">JsonObject</span><span class="tok-punctuation">(</span><span class="tok-punctuation">)</span><span class="tok-operator">.</span><span class="tok-variableName">put</span><span class="tok-punctuation">(</span><span class="tok-string">&quot;packet&quot;</span><span class="tok-punctuation">,</span> <span class="tok-string">&quot;stuff&quot;</span><span class="tok-punctuation">)</span><span class="tok-punctuation">;</span></div><div class="cm-line">  <span class="tok-variableName">vertx</span><span class="tok-operator">.</span><span class="tok-variableName">eventBus</span><span class="tok-punctuation">(</span><span class="tok-punctuation">)</span><span class="tok-operator">.</span><span class="tok-variableName">publish</span><span class="tok-punctuation">(</span><span class="tok-string">&quot;someaddress&quot;</span><span class="tok-punctuation">,</span> <span class="tok-variableName">msg</span><span class="tok-punctuation">)</span><span class="tok-punctuation">;</span></div><div class="cm-line"><span class="tok-punctuation">}</span><span class="tok-punctuation">)</span><span class="tok-punctuation">;</span></div><div class="cm-line"></div><div class="cm-line"><span class="tok-comment">// Consume messages the &quot;importantstuff&quot; address</span></div><div class="cm-line"><span class="tok-variableName">vertx</span><span class="tok-operator">.</span><span class="tok-variableName">eventBus</span><span class="tok-punctuation">(</span><span class="tok-punctuation">)</span><span class="tok-operator">.</span><span class="tok-variableName">consumer</span><span class="tok-punctuation">(</span><span class="tok-string">&quot;importantstuff&quot;</span><span class="tok-punctuation">,</span> <span class="tok-variableName tok-definition">msg</span> -&gt; <span class="tok-punctuation">{</span></div><div class="cm-line">  <span class="tok-variableName">logger</span><span class="tok-operator">.</span><span class="tok-variableName">warn</span><span class="tok-punctuation">(</span><span class="tok-variableName">msg</span><span class="tok-operator">.</span><span class="tok-variableName">body</span><span class="tok-punctuation">(</span><span class="tok-punctuation">)</span><span class="tok-punctuation">)</span><span class="tok-punctuation">;</span></div><div class="cm-line"><span class="tok-punctuation">}</span><span class="tok-punctuation">)</span><span class="tok-punctuation">;</span></div><div class="cm-line"></div></code></pre>
		</div>
	</div>
</div>


<p class="wp-block-paragraph">With this server code we are extending the EventBus via a Websocket. It&#8217;s available to <a href="https://github.com/sockjs/sockjs-client">any client</a> that can speak the SockJS protocol. We can also easily write a Java client that will speak the SockJS-protocol to our server.</p>



<h4 class="wp-block-heading">The Java SockJS Client</h4>


<div class="wp-block-code">
	<div class="cm-editor">
		<div class="cm-scroller">
			
<pre>
<code class="language-java"><div class="cm-line"><span class="tok-keyword">private</span> <span class="tok-keyword">static</span> <span class="tok-keyword">final</span> <span class="tok-typeName">String</span> <span class="tok-variableName tok-definition">pingMessage</span><span class="tok-punctuation">;</span></div><div class="cm-line"></div><div class="cm-line"><span class="tok-keyword">static</span> <span class="tok-punctuation">{</span></div><div class="cm-line">  <span class="tok-typeName">JsonObject</span> <span class="tok-variableName tok-definition">json</span> <span class="tok-operator">=</span> <span class="tok-keyword">new</span> <span class="tok-typeName">JsonObject</span><span class="tok-punctuation">(</span><span class="tok-punctuation">)</span><span class="tok-punctuation">;</span></div><div class="cm-line">  <span class="tok-variableName">json</span><span class="tok-operator">.</span><span class="tok-variableName">put</span><span class="tok-punctuation">(</span><span class="tok-string">&quot;type&quot;</span><span class="tok-punctuation">,</span> <span class="tok-string">&quot;ping&quot;</span><span class="tok-punctuation">)</span><span class="tok-punctuation">;</span></div><div class="cm-line">  <span class="tok-variableName">pingMessage</span> <span class="tok-operator">=</span> <span class="tok-variableName">json</span><span class="tok-operator">.</span><span class="tok-variableName">encode</span><span class="tok-punctuation">(</span><span class="tok-punctuation">)</span><span class="tok-punctuation">;</span></div><div class="cm-line"><span class="tok-punctuation">}</span></div><div class="cm-line"></div><div class="cm-line"><span class="tok-typeName">HttpClient</span> <span class="tok-variableName tok-definition">client</span> <span class="tok-operator">=</span> <span class="tok-variableName">vertx</span><span class="tok-operator">.</span><span class="tok-variableName">createHttpClient</span><span class="tok-punctuation">(</span><span class="tok-punctuation">)</span><span class="tok-punctuation">;</span></div><div class="cm-line"></div><div class="cm-line"><span class="tok-comment">// We use raw websocket transport</span></div><div class="cm-line"><span class="tok-variableName">client</span><span class="tok-operator">.</span><span class="tok-variableName">websocket</span><span class="tok-punctuation">(</span><span class="tok-variableName">port</span><span class="tok-punctuation">,</span> <span class="tok-variableName">host</span><span class="tok-punctuation">,</span> <span class="tok-string">&quot;/eventbus/websocket&quot;</span><span class="tok-punctuation">,</span> <span class="tok-variableName tok-definition">websocket</span> -&gt; <span class="tok-punctuation">{</span></div><div class="cm-line"></div><div class="cm-line"><span class="tok-comment">// Register</span></div><div class="cm-line"><span class="tok-typeName">JsonObject</span> <span class="tok-variableName tok-definition">msg</span> <span class="tok-operator">=</span> <span class="tok-keyword">new</span> <span class="tok-typeName">JsonObject</span><span class="tok-punctuation">(</span><span class="tok-punctuation">)</span><span class="tok-operator">.</span><span class="tok-variableName">put</span><span class="tok-punctuation">(</span><span class="tok-string">&quot;type&quot;</span><span class="tok-punctuation">,</span> <span class="tok-string">&quot;register&quot;</span><span class="tok-punctuation">)</span><span class="tok-operator">.</span><span class="tok-variableName">put</span><span class="tok-punctuation">(</span></div><div class="cm-line">  <span class="tok-string">&quot;address&quot;</span><span class="tok-punctuation">,</span> <span class="tok-string">&quot;someaddress&quot;</span></div><div class="cm-line"><span class="tok-punctuation">)</span><span class="tok-punctuation">;</span></div><div class="cm-line"><span class="tok-variableName">websocket</span><span class="tok-operator">.</span><span class="tok-variableName">writeFinalTextFrame</span><span class="tok-punctuation">(</span><span class="tok-variableName">msg</span><span class="tok-operator">.</span><span class="tok-variableName">encode</span><span class="tok-punctuation">(</span><span class="tok-punctuation">)</span><span class="tok-punctuation">)</span><span class="tok-punctuation">;</span></div><div class="cm-line"></div><div class="cm-line"><span class="tok-comment">// Setup pinging for keepalive</span></div><div class="cm-line"><span class="tok-variableName">pingTimerId</span> <span class="tok-operator">=</span> <span class="tok-variableName">Vertx</span><span class="tok-operator">.</span><span class="tok-variableName">currentContext</span><span class="tok-punctuation">(</span><span class="tok-punctuation">)</span><span class="tok-operator">.</span><span class="tok-variableName">owner</span><span class="tok-punctuation">(</span><span class="tok-punctuation">)</span><span class="tok-operator">.</span><span class="tok-variableName">setPeriodic</span><span class="tok-punctuation">(</span></div><div class="cm-line">  <span class="tok-number">5000</span><span class="tok-punctuation">,</span> <span class="tok-variableName tok-definition">event</span> -&gt; <span class="tok-punctuation">{</span></div><div class="cm-line">    <span class="tok-variableName">websocket</span><span class="tok-operator">.</span><span class="tok-variableName">writeFinalTextFrame</span><span class="tok-punctuation">(</span><span class="tok-variableName">pingMessage</span><span class="tok-punctuation">)</span><span class="tok-punctuation">;</span></div><div class="cm-line">  <span class="tok-punctuation">}</span></div><div class="cm-line"><span class="tok-punctuation">)</span><span class="tok-punctuation">;</span></div><div class="cm-line"></div><div class="cm-line"><span class="tok-comment">// Send to the server</span></div><div class="cm-line"><span class="tok-variableName">msg</span> <span class="tok-operator">=</span> <span class="tok-keyword">new</span> <span class="tok-typeName">JsonObject</span><span class="tok-punctuation">(</span><span class="tok-punctuation">)</span><span class="tok-operator">.</span><span class="tok-variableName">put</span><span class="tok-punctuation">(</span><span class="tok-string">&quot;type&quot;</span><span class="tok-punctuation">,</span> <span class="tok-string">&quot;send&quot;</span><span class="tok-punctuation">)</span></div><div class="cm-line"><span class="tok-operator">.</span><span class="tok-variableName">put</span><span class="tok-punctuation">(</span><span class="tok-string">&quot;address&quot;</span><span class="tok-punctuation">,</span> <span class="tok-string">&quot;importantstuff&quot;</span><span class="tok-punctuation">)</span></div><div class="cm-line"><span class="tok-operator">.</span><span class="tok-variableName">put</span><span class="tok-punctuation">(</span><span class="tok-string">&quot;body&quot;</span><span class="tok-punctuation">,</span> <span class="tok-keyword">new</span> <span class="tok-typeName">JsonObject</span><span class="tok-punctuation">(</span><span class="tok-punctuation">)</span><span class="tok-operator">.</span><span class="tok-variableName">put</span><span class="tok-punctuation">(</span><span class="tok-string">&quot;foo&quot;</span><span class="tok-punctuation">,</span> <span class="tok-string">&quot;bar&quot;</span><span class="tok-punctuation">)</span><span class="tok-punctuation">)</span><span class="tok-punctuation">;</span></div><div class="cm-line"><span class="tok-variableName">websocket</span><span class="tok-operator">.</span><span class="tok-variableName">writeFinalTextFrame</span><span class="tok-punctuation">(</span><span class="tok-variableName">msg</span><span class="tok-operator">.</span><span class="tok-variableName">encode</span><span class="tok-punctuation">(</span><span class="tok-punctuation">)</span><span class="tok-punctuation">)</span><span class="tok-punctuation">;</span></div><div class="cm-line"></div><div class="cm-line"><span class="tok-comment">// Receive from the server</span></div><div class="cm-line"><span class="tok-variableName">websocket</span><span class="tok-operator">.</span><span class="tok-variableName">handler</span><span class="tok-punctuation">(</span><span class="tok-variableName tok-definition">buffer</span> -&gt; <span class="tok-punctuation">{</span></div><div class="cm-line">  <span class="tok-typeName">JsonObject</span> <span class="tok-variableName tok-definition">received</span> <span class="tok-operator">=</span> <span class="tok-keyword">new</span> <span class="tok-typeName">JsonObject</span><span class="tok-punctuation">(</span><span class="tok-variableName">buffer</span><span class="tok-operator">.</span><span class="tok-variableName">toString</span><span class="tok-punctuation">(</span><span class="tok-punctuation">)</span><span class="tok-punctuation">)</span><span class="tok-punctuation">;</span></div><div class="cm-line"></div><div class="cm-line">  <span class="tok-variableName">logger</span><span class="tok-operator">.</span><span class="tok-variableName">info</span><span class="tok-punctuation">(</span></div><div class="cm-line">    <span class="tok-string">&quot;received message on address: &quot;</span> <span class="tok-operator">+</span> <span class="tok-variableName">received</span><span class="tok-operator">.</span><span class="tok-variableName">getString</span><span class="tok-punctuation">(</span><span class="tok-string">&quot;address&quot;</span><span class="tok-punctuation">)</span></div><div class="cm-line">  <span class="tok-punctuation">)</span><span class="tok-punctuation">;</span></div><div class="cm-line">  <span class="tok-variableName">logger</span><span class="tok-operator">.</span><span class="tok-variableName">info</span><span class="tok-punctuation">(</span><span class="tok-string">&quot;message body: &quot;</span> <span class="tok-operator">+</span> <span class="tok-variableName">received</span><span class="tok-operator">.</span><span class="tok-variableName">getString</span><span class="tok-punctuation">(</span><span class="tok-string">&quot;body&quot;</span><span class="tok-punctuation">)</span><span class="tok-punctuation">)</span><span class="tok-punctuation">;</span></div><div class="cm-line">  <span class="tok-punctuation">}</span><span class="tok-punctuation">)</span><span class="tok-punctuation">;</span></div><div class="cm-line"><span class="tok-punctuation">}</span><span class="tok-punctuation">)</span><span class="tok-punctuation">;</span></div><div class="cm-line"></div></code></pre>
		</div>
	</div>
</div>


<p class="wp-block-paragraph">Note that first we must &#8220;register&#8221; the client with the server. This is accomplished by sending a properly crafted register message, which is just a json packet with the type set to &#8220;register&#8221; along with the address the client wants to subscribe to. Additionally, the SockJS protocol specifies a &#8220;ping&#8221; message for keep alive on the socket. We provide a properly crafted pingMessage to enable this at the top of this code.</p>



<p class="wp-block-paragraph">The envelope for SockJS messages is specified in the protocol to look like this:</p>


<div class="wp-block-code">
	<div class="cm-editor">
		<div class="cm-scroller">
			
<pre>
<code class="language-javascript"><div class="cm-line"><span class="tok-punctuation">{</span></div><div class="cm-line"><span class="tok-string">&quot;type&quot;</span><span class="tok-punctuation">:</span> <span class="tok-string">&quot;send&quot;</span><span class="tok-operator">|</span><span class="tok-string">&quot;publish&quot;</span><span class="tok-operator">|</span><span class="tok-string">&quot;receive&quot;</span><span class="tok-operator">|</span><span class="tok-string">&quot;register&quot;</span><span class="tok-operator">|</span><span class="tok-string">&quot;unregister&quot;</span><span class="tok-punctuation">,</span></div><div class="cm-line"><span class="tok-string">&quot;address&quot;</span><span class="tok-punctuation">:</span> <span class="tok-string">&quot;mailbox123&quot;</span></div><div class="cm-line"><span class="tok-string">&quot;body&quot;</span><span class="tok-punctuation">:</span> <span class="tok-string">&quot;the body of the message&quot;</span></div><div class="cm-line"><span class="tok-punctuation">}</span></div><div class="cm-line"></div></code></pre>
		</div>
	</div>
</div>


<p class="wp-block-paragraph">You can see in the client implementation above we performed a &#8220;send&#8221; by specifying it in the JsonObject envelope.</p>



<p class="wp-block-paragraph">The operations specified by the protocol are these:</p>



<p class="wp-block-paragraph"><strong>SOCKET_CREATED</strong><br>
This event will occur when a new SockJS socket is created.</p>



<p class="wp-block-paragraph"><strong>SOCKET_CLOSED</strong><br>
This event will occur when a SockJS socket is closed.</p>



<p class="wp-block-paragraph"><strong>SEND</strong><br>
This event will occur when a message is attempted to be sent from the client to the server.</p>



<p class="wp-block-paragraph"><strong>PUBLISH</strong><br>
This event will occur when a message is attempted to be published from the client to the server.</p>



<p class="wp-block-paragraph"><strong>RECEIVE</strong><br>
This event will occur when a message is attempted to be delivered from the server to the client.</p>



<p class="wp-block-paragraph"><strong>REGISTER</strong><br>
This event will occur when a client attempts to register a handler.</p>



<p class="wp-block-paragraph"><strong>UNREGISTER</strong><br>
This event will occur when a client attempts to unregister a handler.</p>



<p class="wp-block-paragraph">You can see how trivial relaying to a proxied address or republishing on a local EventBus might be by simply switching over these operations. In the kinds of patterns this substrates enables, you can see in things like <a href="http://www.enterpriseintegrationpatterns.com/patterns/messaging/PointToPointChannel.html">Point-to-Point Channel</a>, <a href="http://www.enterpriseintegrationpatterns.com/patterns/messaging/PublishSubscribeChannel.html">Publish-Subscribe Channel</a>, and <a href="http://www.enterpriseintegrationpatterns.com/patterns/messaging/BroadcastAggregate.html">Scatter-Gather</a> messaging.</p>



<p class="wp-block-paragraph">The Javascript sockjs-client can be found <a href="https://github.com/sockjs/sockjs-client">here</a>. Vertx includes an eventbus-client, <a href="https://github.com/vert-x3/vertx-examples/blob/master/web-examples/src/main/java/io/vertx/example/web/realtime/webroot/vertx-eventbus.js">vertx-eventbus.js</a>, that utilizes sockjs.js to provide a convenient extension of the EventBus into Javascript apps. This is ideal for running in the browser, bolting realtime messaging directly into your web apps. There is also an <a href="https://www.npmjs.com/package/vertx3-eventbus-client">npm module</a> that brings allows you to easily snap node apps into your eventing framework. Someone has even recently created a <a href="https://github.com/julien3/vertxbuspp">C++ implementation</a> that provides an onramp to your native runtime applications.</p>



<p class="wp-block-paragraph">This is a fantastically powerful composition medium. I highly recommend it as the foundation for modern, high-speed, real-time software that needs to start small but scale to immense sizes. Thanks to Vertx, its just cake.</p>



<p class="wp-block-paragraph">Enjoy the cake&#8230;</p>
