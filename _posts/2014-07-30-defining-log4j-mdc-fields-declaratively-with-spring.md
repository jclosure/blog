---
layout: post
title: "Defining Log4j MDC Fields Declaratively With Spring"
date: 2014-07-30 13:59:28 -0500
categories: []
tags: []
wordpress_id: 811
original_url: "https://joelholder.com/2014/07/30/defining-log4j-mdc-fields-declaratively-with-spring/"
---
<p class="wp-block-paragraph">In this post, I&#8217;m going to show you how to extend the fields <a href="http://logging.apache.org/log4j/2.x/" title="Log4j">Log4j</a> captures via <a href="http://veerasundar.com/blog/2009/10/log4j-mdc-mapped-diagnostic-context-what-and-why/" title="MDC">MDC (Mapped Diagnostic Contexts)</a>.  Specifically, we will add an additional field called &#8220;ApplicationId&#8221; that will identify the application that a given log entry came from.  This is useful when you have many applications logging to a single persistence mechanism.  It enables you to filter/query the logs to include/exclude entries based on this value.  For enterprises, who require both wide and deep insight into their instrumentation feeds, the ability to cross-refer and cross-correlate this data across systems and applications is essential.  The means to seperate out a particular log stream from the noise of the others can easily be achieved with the recipe that we&#8217;ll look at next.</p>



<p class="wp-block-paragraph">First in your Log4j configuration file, you need setup your ConversionPattern value to include a new ApplicationId field:</p>



~~~ text
log4j.appender.out.layout.ConversionPattern=
 %X{ApplicationId} | %d{ISO8601} | %-5.5p | %-16.16t | %-32.32c{1} | %m%n
~~~




<p class="wp-block-paragraph">Once this is in place, you can now begin capturing it by instructing Log4j to add a new Key:Value into its awareness of fields to be tracked.</p>



<p class="wp-block-paragraph">You can set this value in your java code like this:</p>



~~~ java
private void setupLogging() {
org.apache.log4j.MDC.put("ApplicationId", "XZY321");
}
~~~




<p class="wp-block-paragraph">That is how you can do it programmatically.  Code like the setupLogging() function should be run only once in an initialization routine, such as a bootstrapping function.  After that it will automatically place the ApplicationId field into every log entry it generates.  This is nice, as it will now identify the application that made each log entry.</p>



<p class="wp-block-paragraph">If, however, you do not want to write java code to achieve this, you can still do this with Spring Xml Config.  In this way, you can get the same result with more of a configuration idiom, rather than a coding approach.</p>



<p class="wp-block-paragraph">Here&#8217;s how to run a static method using <a href="http://www.captaindebug.com/2011/03/using-methodinvokingfactorybean-to-call.html#.U9lJIPldX4E" title="spring methodinvokingfactory">Spring&#8217;s MethodInvokingFactoryBean</a> to add a MDC Property to log4j&#8217;s tracked fields:</p>



~~~ xml
<beans
  xmlns="http://www.springframework.org/schema/beans"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://www.springframework.org/schema/beans
  http://www.springframework.org/schema/beans/spring-beans.xsd">

  <bean
    class=
    "org.springframework.beans.factory.config.MethodInvokingFactoryBean"
    >
    <property name="targetClass">
      <value>org.apache.log4j.MDC</value>
    </property>
    <property name="targetMethod">
      <value>put</value>
    </property>
    <property name="arguments">
      <list>
        <value>ApplicationId</value>
        <value>ABC123</value>
      </list>
    </property>
  </bean>

</beans>
~~~




<p class="wp-block-paragraph">When your Spring ApplicationContext loads, it will run the static <a href="https://logging.apache.org/log4j/1.2/apidocs/org/apache/log4j/MDC.html">org.apache.log4j.MDC.put()</a> method.  In effect, this is similar to running the code programmatically, but in practice it can be considered an application configuration-level feature.  I tend to like this approach better, because it does not require a compile and redeploy, which makes it manageable by general tech ops people.  Which ever approach taken, extending Log4j to capture the additional relevant data points for your needs can be a very powerful compliment.</p>
