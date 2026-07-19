---
layout: post
title: "EventBusBridges for Great Good"
date: 2016-06-19 02:09:22 -0500
categories: []
tags: []
wordpress_id: 1100
original_url: "https://joelholder.com/2016/06/19/eventbusbridges-for-great-good/"
---

The [SockJS protocol](http://sockjs.org) provides a fast and reliable mechanism for providing duplex communication via Websockets. Vertx has a particularly nice implementation of this in the form of [EventBusBridges](http://vertx.io/docs/vertx-web/java/#_handling_event_bus_bridge_events), which make it easy to create secure communication pipelines between an HttpServer Verticle and a variety of polyglot SockJS clients via Websockets or fallback transports. Surprisingly, a Java-based EventBusBridgeClient is not among the ootb facilities, even though Java is the main story on the server. Here I will show you how easy to create your own and a few of the awesome things you can do with it.

#### The EventBusBridge Server

```java
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
```

With this server code we are extending the EventBus via a Websocket. It's available to [any client](https://github.com/sockjs/sockjs-client) that can speak the SockJS protocol. We can also easily write a Java client that will speak the SockJS-protocol to our server.

#### The Java SockJS Client

```java
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
```

Note that first we must "register" the client with the server. This is accomplished by sending a properly crafted register message, which is just a json packet with the type set to "register" along with the address the client wants to subscribe to. Additionally, the SockJS protocol specifies a "ping" message for keep alive on the socket. We provide a properly crafted pingMessage to enable this at the top of this code.

The envelope for SockJS messages is specified in the protocol to look like this:

```javascript
{
"type": "send"|"publish"|"receive"|"register"|"unregister",
"address": "mailbox123"
"body": "the body of the message"
}
```

You can see in the client implementation above we performed a "send" by specifying it in the JsonObject envelope.

The operations specified by the protocol are these:

**SOCKET_CREATED**
This event will occur when a new SockJS socket is created.

**SOCKET_CLOSED**
This event will occur when a SockJS socket is closed.

**SEND**
This event will occur when a message is attempted to be sent from the client to the server.

**PUBLISH**
This event will occur when a message is attempted to be published from the client to the server.

**RECEIVE**
This event will occur when a message is attempted to be delivered from the server to the client.

**REGISTER**
This event will occur when a client attempts to register a handler.

**UNREGISTER**
This event will occur when a client attempts to unregister a handler.

You can see how trivial relaying to a proxied address or republishing on a local EventBus might be by simply switching over these operations. In the kinds of patterns this substrates enables, you can see in things like [Point-to-Point Channel](http://www.enterpriseintegrationpatterns.com/patterns/messaging/PointToPointChannel.html), [Publish-Subscribe Channel](http://www.enterpriseintegrationpatterns.com/patterns/messaging/PublishSubscribeChannel.html), and [Scatter-Gather](http://www.enterpriseintegrationpatterns.com/patterns/messaging/BroadcastAggregate.html) messaging.

The Javascript sockjs-client can be found [here](https://github.com/sockjs/sockjs-client). Vertx includes an eventbus-client, [vertx-eventbus.js](https://github.com/vert-x3/vertx-examples/blob/master/web-examples/src/main/java/io/vertx/example/web/realtime/webroot/vertx-eventbus.js), that utilizes sockjs.js to provide a convenient extension of the EventBus into Javascript apps. This is ideal for running in the browser, bolting realtime messaging directly into your web apps. There is also an [npm module](https://www.npmjs.com/package/vertx3-eventbus-client) that brings allows you to easily snap node apps into your eventing framework. Someone has even recently created a [C++ implementation](https://github.com/julien3/vertxbuspp) that provides an onramp to your native runtime applications.

This is a fantastically powerful composition medium. I highly recommend it as the foundation for modern, high-speed, real-time software that needs to start small but scale to immense sizes. Thanks to Vertx, its just cake.

Enjoy the cake...
