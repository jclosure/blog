---
layout: post
title: "Grokking JBoss Fuse Logs with Logstash"
date: 2014-05-25 20:38:13 -0500
categories: []
tags: []
wordpress_id: 616
original_url: "https://joelholder.com/2014/05/25/grokking-jboss-fuse-logs-with-logstash/"
---
<p><a href="http://www.jboss.org/products/fuse.html" target="_blank">JBoss Fuse</a> or more generally <a href="http://servicemix.apache.org/" target="_blank">Apache ServiceMix</a> ship with a default log4j layout ConversionPattern. In this article I will show you how to parse your $FUSE_HOME/data/log/fuse.log file, collect its log entries into Elasticsearch, and understand whats going on in the Kibana UI.</p>
<p>First a few pieces of context.</p>
<p>If you are not familiar with the ELK Stack, please read up on it <a href="http://www.elasticsearch.org/overview/">here</a>.</p>
<p>In this scenario, we are going to use Logstash as our log parser and collector agent. Elasticsearch (ES) will provide the storage and RESTful search interface. And, Kibana will be our UI over the data in ES.</p>
<p>First we need to get the data. In our case the target we want to analyze in the JBoss Fuse log file. Since, my $FUSE_HOME is /opt/jboss-fuse, my log file will be at /opt/jboss-fuse/data/log/fuse.log.</p>
<pre class="brush: plain; title: ; notranslate" title="">
2014-05-25 21:11:48,677 | INFO  | .167:49697@61616 | LoggingBrokerPlugin              | 132 - org.apache.activemq.activemq-osgi - 5.9.0.redhat-610379 | Adding destination: Topic:ActiveMQ.Advisory.Connection
2014-05-25 21:11:48,743 | INFO  | .167:49697@61616 | LoggingBrokerPlugin              | 132 - org.apache.activemq.activemq-osgi - 5.9.0.redhat-610379 | Adding Consumer: ConsumerInfo {commandId = 2, responseRequired = true, consumerId = ID:ESBHOST-50593-635366336896487074-1:56:-1:1, destination = ActiveMQ.Advisory.TempQueue,ActiveMQ.Advisory.TempTopic, prefetchSize = 1000, maximumPendingMessageLimit = 0, browser = false, dispatchAsync = false, selector = null, clientId = null, subscriptionName = null, noLocal = true, exclusive = false, retroactive = false, priority = 0, brokerPath = null, optimizedAcknowledge = false, noRangeAcks = false, additionalPredicate = null}
2014-05-25 21:11:48,804 | INFO  | .167:49697@61616 | LoggingBrokerPlugin              | 132 - org.apache.activemq.activemq-osgi - 5.9.0.redhat-610379 | Adding Session: SessionInfo {commandId = 3, responseRequired = false, sessionId = ID:ESBHOST-50593-635366336896487074-1:56:1}
2014-05-25 21:11:48,806 | INFO  | .167:49697@61616 | LoggingBrokerPlugin              | 132 - org.apache.activemq.activemq-osgi - 5.9.0.redhat-610379 | Adding Producer: ProducerInfo {commandId = 4, responseRequired = false, producerId = ID:ESBHOST-50593-635366336896487074-1:56:1:2, destination = null, brokerPath = null, dispatchAsync = false, windowSize = 0, sentCount = 0}
2014-05-25 21:11:48,816 | INFO  | .167:49697@61616 | LoggingBrokerPlugin              | 132 - org.apache.activemq.activemq-osgi - 5.9.0.redhat-610379 | Sending message: ActiveMQTextMessage {commandId = 5, responseRequired = true, messageId = ID:ESBHOST-50593-635366336896487074-1:56:1:2:1, originalDestination = null, originalTransactionId = null, producerId = ID:ESBHOST-50593-635366336896487074-1:56:1:2, destination = queue://test.dotnet.testharness, transactionId = null, expiration = 0, timestamp = 1401066708752, arrival = 0, brokerInTime = 0, brokerOutTime = 0, correlationId = e3fbd106-0acd-45e7-9045-5710484cf29e, replyTo = null, persistent = true, type = null, priority = 4, groupID = null, groupSequence = 0, targetConsumerId = null, compressed = false, userID = null, content = org.apache.activemq.util.ByteSequence@593233cd, marshalledProperties = null, dataStructure = null, redeliveryCounter = 0, size = 0, properties = null, readOnlyProperties = false, readOnlyBody = false, droppable = false, jmsXGroupFirstForConsumer = false, text = Hello World I am an ActiveMQ Message...}
2014-05-25 21:11:48,816 | INFO  | .167:49697@61616 | LoggingBrokerPlugin              | 132 - org.apache.activemq.activemq-osgi - 5.9.0.redhat-610379 | Adding destination: Queue:test.dotnet.testharness
2014-05-25 21:11:48,882 | INFO  | .167:49697@61616 | LoggingBrokerPlugin              | 132 - org.apache.activemq.activemq-osgi - 5.9.0.redhat-610379 | Removing Producer: ProducerInfo {commandId = 4, responseRequired = false, producerId = ID:ESBHOST-50593-635366336896487074-1:56:1:2, destination = null, brokerPath = null, dispatchAsync = false, windowSize = 0, sentCount = 1}
2014-05-25 21:11:48,883 | INFO  | .167:49697@61616 | LoggingBrokerPlugin              | 132 - org.apache.activemq.activemq-osgi - 5.9.0.redhat-610379 | Removing Session: SessionInfo {commandId = 3, responseRequired = false, sessionId = ID:ESBHOST-50593-635366336896487074-1:56:1}
2014-05-25 21:11:48,884 | INFO  | .167:49697@61616 | LoggingBrokerPlugin              | 132 - org.apache.activemq.activemq-osgi - 5.9.0.redhat-610379 | Removing Consumer: ConsumerInfo {commandId = 2, responseRequired = true, consumerId = ID:ESBHOST-50593-635366336896487074-1:56:-1:1, destination = ActiveMQ.Advisory.TempQueue,ActiveMQ.Advisory.TempTopic, prefetchSize = 1000, maximumPendingMessageLimit = 0, browser = false, dispatchAsync = false, selector = null, clientId = null, subscriptionName = null, noLocal = true, exclusive = false, retroactive = false, priority = 0, brokerPath = null, optimizedAcknowledge = false, noRangeAcks = false, additionalPredicate = null}
2014-05-25 21:11:48,885 | INFO  | .167:49697@61616 | LoggingBrokerPlugin              | 132 - org.apache.activemq.activemq-osgi - 5.9.0.redhat-610379 | Removing Session: SessionInfo {commandId = 0, responseRequired = false, sessionId = ID:ESBHOST-50593-635366336896487074-1:56:-1}
2014-05-25 21:11:48,885 | INFO  | .167:49697@61616 | LoggingBrokerPlugin              | 132 - org.apache.activemq.activemq-osgi - 5.9.0.redhat-610379 | Removing Connection: ConnectionInfo {commandId = 1, responseRequired = true, connectionId = ID:ESBHOST-50593-635366336896487074-1:56, clientId = ID:ESBHOST-50593-635366336896487074-55:0, clientIp = tcp://10.224.14.167:49697, userName = testuser, password = *****, brokerPath = null, brokerMasterConnector = false, manageable = false, clientMaster = false, faultTolerant = false, failoverReconnect = false}
</pre>
<p>Note that the format is pipe delimited.</p>
<p>This comes from the log4j layout ConversionPattern setup in $FUSE_HOME/etc/org.ops4j.pax.logging.cfg.</p>
<p>Here is mine:</p>
<pre class="brush: plain; title: ; notranslate" title="">
log4j.appender.out.layout.ConversionPattern=%d{ISO8601} | %-5.5p | %-16.16t | %-32.32c{1} | %X{bundle.id} - %X{bundle.name} - %X{bundle.version} | %m%n
</pre>
<p>Note that it creates 6 fields, delimited by pipes.</p>
<p>To parse this file we&#8217;ll need to configure Logstash and tell it how to interpret it.</p>
<p>Logstash is configured with a config file. It can be started on the command line from the logstash directory with the config file like this:</p>
<p>bin/logstash agent -f logstash.config</p>
<p>I have set my logstash.config up to parse this format with a grok section in the filter definition. <a href="https://github.com/elasticsearch/logstash/blob/master/patterns/grok-patterns">Grok</a> is a high-level expression syntax for matching and tokenizing text. It extends from regular expressions, so it inherits the power of regex with the convenience of having higher-level semantic constructs like %{LOGLEVEL:****} and %{GREEDYDATA:****}, etc.</p>
<p>Here is my logstash.config:</p>
<pre class="brush: ruby; title: ; notranslate" title="">
input {
  file {
    type =&gt; &quot;esb&quot;
    path =&gt; &#x5B;&quot;/opt/jboss-fuse/data/log/fuse.log&quot;]
    sincedb_path =&gt; &quot;/opt/elk/logstash/sync_db/jboss-fuse&quot;
  }
}

filter {
  if &#x5B;type] == &quot;esb&quot; {
    grok {      
      match =&gt; { 
        message =&gt; &quot;%{TIMESTAMP_ISO8601:logdate}%{SPACE}\|%{SPACE}%{LOGLEVEL:level}%{SPACE}\|%{SPACE}%{DATA:thread}%{SPACE}\|%{SPACE}%{DATA:category}%{SPACE}\|%{SPACE}%{DATA:bundle}%{SPACE}\|%{SPACE}%{GREEDYDATA:messagetext}&quot;
      }
      add_tag =&gt; &#x5B;&quot;env_dev&quot;] 
    }
    if &quot;_grokparsefailure&quot; in &#x5B;tags] {
      multiline {
        pattern =&gt; &quot;.*&quot;
        what =&gt; &quot;previous&quot;
        add_tag =&gt; &quot;notgrok&quot;
      }
    }  
    date {
       match =&gt; &#x5B;&quot;logdate&quot;, &quot;yyyy-MM-dd HH:mm:ss,SSS&quot;]
    }
  }
}

output {
  elasticsearch {
    host =&gt; &quot;elasticsearch.mydomain.com&quot;
  }
  stdout {
    codec =&gt; rubydebug
  }
}
</pre>
<p>This configuration will cause logstash to read in the file. Logstash tails the file while running and tokenizes each new log entry into the fields specified in the match => string, as shown. The fields then are:</p>
<ul>
<li>logdate</li>
<li>level</li>
<li>thread</li>
<li>category</li>
<li>bundle</li>
<li>messagetext</li>
</ul>
<p>Logstash creates a data structure for each log entry, with the populated fields specified in the grok filter&#8217;s match pattern.</p>
<pre class="brush: jscript; title: ; notranslate" title="">
{
        &quot;message&quot; =&gt; &quot;2014-05-25 22:08:04,950 | INFO  | 4.167:8174@61616 | LoggingBrokerPlugin              | 132 - org.apache.activemq.activemq-osgi - 5.9.0.redhat-610379 | Sending message: ActiveMQTextMessage {commandId = 5, responseRequired = true, messageId = ID:MYCONSUMERHOST-50593-635366336896487074-1:57:1:2:1, originalDestination = null, originalTransactionId = null, producerId = ID:MYCONSUMERHOST-50593-635366336896487074-1:57:1:2, destination = queue://test.dotnet.testharness, transactionId = null, expiration = 0, timestamp = 1401070084863, arrival = 0, brokerInTime = 0, brokerOutTime = 0, correlationId = 0defa0b0-75de-4d51-a127-9aa1e55fa9fc, replyTo = null, persistent = true, type = null, priority = 4, groupID = null, groupSequence = 0, targetConsumerId = null, compressed = false, userID = null, content = org.apache.activemq.util.ByteSequence@751107eb, marshalledProperties = null, dataStructure = null, redeliveryCounter = 0, size = 0, properties = null, readOnlyProperties = false, readOnlyBody = false, droppable = false, jmsXGroupFirstForConsumer = false, text = Hello World I am an ActiveMQ Message...}&quot;,
       &quot;@version&quot; =&gt; &quot;1&quot;,
     &quot;@timestamp&quot; =&gt; &quot;2014-05-26T02:08:04.950Z&quot;,
           &quot;type&quot; =&gt; &quot;esb&quot;,
           &quot;host&quot; =&gt; &quot;esbhost.domain.com&quot;,
           &quot;path&quot; =&gt; &quot;/opt/jboss-fuse/data/log/fuse.log&quot;,
        &quot;logdate&quot; =&gt; &quot;2014-05-25 22:08:04,950&quot;,
          &quot;level&quot; =&gt; &quot;INFO&quot;,
         &quot;thread&quot; =&gt; &quot;4.167:8174@61616&quot;,
       &quot;category&quot; =&gt; &quot;LoggingBrokerPlugin&quot;,
         &quot;bundle&quot; =&gt; &quot;132 - org.apache.activemq.activemq-osgi - 5.9.0.redhat-610379&quot;,
    &quot;messagetext&quot; =&gt; &quot;Sending message: ActiveMQTextMessage {commandId = 5, responseRequired = true, messageId = ID:MYCONSUMERHOST-50593-635366336896487074-1:57:1:2:1, originalDestination = null, originalTransactionId = null, producerId = ID:MYCONSUMERHOST-50593-635366336896487074-1:57:1:2, destination = queue://test.dotnet.testharness, transactionId = null, expiration = 0, timestamp = 1401070084863, arrival = 0, brokerInTime = 0, brokerOutTime = 0, correlationId = 0defa0b0-75de-4d51-a127-9aa1e55fa9fc, replyTo = null, persistent = true, type = null, priority = 4, groupID = null, groupSequence = 0, targetConsumerId = null, compressed = false, userID = null, content = org.apache.activemq.util.ByteSequence@751107eb, marshalledProperties = null, dataStructure = null, redeliveryCounter = 0, size = 0, properties = null, readOnlyProperties = false, readOnlyBody = false, droppable = false, jmsXGroupFirstForConsumer = false, text = Hello World I am an ActiveMQ Message...}&quot;,
           &quot;tags&quot; =&gt; &#x5B;
        &#x5B;0] &quot;env_dev&quot;
    ]
}
</pre>
<p>These are automatically sent to Elasticsearch, which will be listening on a different host usually. You&#8217;ll set it up as the Aggregation hub for all your logstash agents. It exposes its api on tcp port 9292 and will accept input from the logstash agents via http requests to its port. Going into how to query Elasticsearch is beyond the scope of this post, but I will cover it in a subsequent article.</p>
<p>Kibana is a JavaScript and HTML app only, it interfaces with Elasticsearch and provides a powerful analytics interface over the data in ES.</p>
<p>Here is an example of mine watching sending message levels in JBoss Fuse&#8217;s ActiveMQ Broker.</p>
<p><a href="/blog/assets/wp/grokking-jboss-fuse-logs-with-logstash/data_transfers_dashboard.png"><img data-recalc-dims="1" loading="lazy" decoding="async" data-attachment-id="993" data-permalink="https://joelholder.com/2014/05/25/grokking-jboss-fuse-logs-with-logstash/data_transfers_dashboard/" data-orig-file="https://i0.wp.com/joelholder.com/wp-content/uploads/2014/05/data_transfers_dashboard.png?fit=1613%2C1148&amp;ssl=1" data-orig-size="1613,1148" data-comments-opened="1" data-image-meta="{&quot;aperture&quot;:&quot;0&quot;,&quot;credit&quot;:&quot;&quot;,&quot;camera&quot;:&quot;&quot;,&quot;caption&quot;:&quot;&quot;,&quot;created_timestamp&quot;:&quot;0&quot;,&quot;copyright&quot;:&quot;&quot;,&quot;focal_length&quot;:&quot;0&quot;,&quot;iso&quot;:&quot;0&quot;,&quot;shutter_speed&quot;:&quot;0&quot;,&quot;title&quot;:&quot;&quot;,&quot;orientation&quot;:&quot;0&quot;}" data-image-title="data_transfers_dashboard" data-image-description="" data-image-caption="" data-large-file="https://i0.wp.com/joelholder.com/wp-content/uploads/2014/05/data_transfers_dashboard.png?fit=1024%2C729&amp;ssl=1" class="aligncenter wp-image-993 size-large" src="/blog/assets/wp/grokking-jboss-fuse-logs-with-logstash/data_transfers_dashboard-2.png" alt="data_transfers_dashboard" width="660" height="470" /></a></p>
<p>Namaste&#8230;</p>
