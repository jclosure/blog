---
layout: post
title: "EventBusBridges for Great Good"
date: 2016-06-19 02:09:22 -0500
categories: []
tags: []
wordpress_id: 1100
original_url: "https://joelholder.com/2016/06/19/eventbusbridges-for-great-good/"
---

<p class="wp-block-paragraph">The <a href="http://sockjs.org">SockJS protocol</a> provides a fast and reliable mechanism for providing duplex communication via Websockets.  Vertx has a particularly nice implementation of this in the form of <a href="http://vertx.io/docs/vertx-web/java/#_handling_event_bus_bridge_events">EventBusBridges</a>, which make it easy to create secure communication pipelines between an HttpServer Verticle and a variety of polyglot SockJS clients via Websockets or fallback transports.  Surprisingly, a Java-based EventBusBridgeClient is not among the ootb facilities, even though Java is the main story on the server.  Here I will show you how easy to create your own and a few of the awesome things you can do with it.</p>



<h4 class="wp-block-heading">The EventBusBridge Server</h4>


<div class="wp-block-code">
    <div class="cm-editor">
        <div class="cm-scroller">


~~~ java
Router router = Router.router(vertx);

// Allow all addresses to flow in and out on the bridge

BridgeOptions options = new BridgeOptions()
  .addInboundPermitted(new PermittedOptions().setAddressRegex(".+"))
  .addOutboundPermitted(new PermittedOptions().setAddressRegex(".+"));

router.route("/eventbus/*").handler(
  SockJSHandler.create(vertx).bridge(options)
);

// Setup a body handler
router.route().handler(BodyHandler.create());

HttpServer httpServer = vertx.createHttpServer();
httpServer.requestHandler(router::accept).listen(8080);

// do server wiring

// Publish a message to "someaddress" on interval
vertx.setPeriodic(5000, t -> {
  JsonObject msg = new JsonObject().put("packet", "stuff");
  vertx.eventBus().publish("someaddress", msg);
});

// Consume messages the "importantstuff" address
vertx.eventBus().consumer("importantstuff", msg -> {
  logger.warn(msg.body());
});
~~~

    </div>
</div>


<p class="wp-block-paragraph">With this server code we are extending the EventBus via a Websocket. It&#8217;s available to <a href="https://github.com/sockjs/sockjs-client">any client</a> that can speak the SockJS protocol. We can also easily write a Java client that will speak the SockJS-protocol to our server.</p>



<h4 class="wp-block-heading">The Java SockJS Client</h4>


<div class="wp-block-code">
    <div class="cm-editor">
        <div class="cm-scroller">


~~~ java
private static final String pingMessage;

static {
  JsonObject json = new JsonObject();
  json.put("type", "ping");
  pingMessage = json.encode();
}

HttpClient client = vertx.createHttpClient();

// We use raw websocket transport
client.websocket(port, host, "/eventbus/websocket", websocket -> {

// Register
JsonObject msg = new JsonObject().put("type", "register").put(
  "address", "someaddress"
);
websocket.writeFinalTextFrame(msg.encode());

// Setup pinging for keepalive
pingTimerId = Vertx.currentContext().owner().setPeriodic(
  5000, event -> {
    websocket.writeFinalTextFrame(pingMessage);
  }
);

// Send to the server
msg = new JsonObject().put("type", "send")
.put("address", "importantstuff")
.put("body", new JsonObject().put("foo", "bar"));
websocket.writeFinalTextFrame(msg.encode());

// Receive from the server
websocket.handler(buffer -> {
  JsonObject received = new JsonObject(buffer.toString());

  logger.info(
    "received message on address: " + received.getString("address")
  );
  logger.info("message body: " + received.getString("body"));
  });
});
~~~

    </div>
</div>


<p class="wp-block-paragraph">Note that first we must &#8220;register&#8221; the client with the server. This is accomplished by sending a properly crafted register message, which is just a json packet with the type set to &#8220;register&#8221; along with the address the client wants to subscribe to. Additionally, the SockJS protocol specifies a &#8220;ping&#8221; message for keep alive on the socket. We provide a properly crafted pingMessage to enable this at the top of this code.</p>



<p class="wp-block-paragraph">The envelope for SockJS messages is specified in the protocol to look like this:</p>


<div class="wp-block-code">
    <div class="cm-editor">
        <div class="cm-scroller">


~~~ javascript
{
"type": "send"|"publish"|"receive"|"register"|"unregister",
"address": "mailbox123"
"body": "the body of the message"
}
~~~

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
