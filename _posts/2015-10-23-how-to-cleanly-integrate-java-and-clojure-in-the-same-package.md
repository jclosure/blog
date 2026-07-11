---
layout: post
title: "How To Cleanly Integrate Java and Clojure In The Same Package"
date: 2015-10-23 23:52:09 -0500
categories: []
tags: ["clojure", "emacs", "java", "org-mode"]
wordpress_id: 1004
original_url: "https://joelholder.com/2015/10/23/how-to-cleanly-integrate-java-and-clojure-in-the-same-package/"
---
<figure class="wp-block-image size-full"><a href="/assets/wp/how-to-cleanly-integrate-java-and-clojure-in-the-same-package/wpid-emacs-my-app.png"><img data-recalc-dims="1" loading="lazy" decoding="async" width="1920" height="1040" data-attachment-id="1016" data-permalink="https://joelholder.com/2015/10/23/how-to-cleanly-integrate-java-and-clojure-in-the-same-package/wpid-emacs-my-app-png/" data-orig-file="https://i0.wp.com/joelholder.com/wp-content/uploads/2015/10/wpid-emacs-my-app.png?fit=1920%2C1040&amp;ssl=1" data-orig-size="1920,1040" data-comments-opened="1" data-image-meta="{&quot;aperture&quot;:&quot;0&quot;,&quot;credit&quot;:&quot;&quot;,&quot;camera&quot;:&quot;&quot;,&quot;caption&quot;:&quot;&quot;,&quot;created_timestamp&quot;:&quot;0&quot;,&quot;copyright&quot;:&quot;&quot;,&quot;focal_length&quot;:&quot;0&quot;,&quot;iso&quot;:&quot;0&quot;,&quot;shutter_speed&quot;:&quot;0&quot;,&quot;title&quot;:&quot;&quot;,&quot;orientation&quot;:&quot;0&quot;}" data-image-title="wpid-emacs-my-app.png" data-image-description="" data-image-caption="" data-large-file="https://i0.wp.com/joelholder.com/wp-content/uploads/2015/10/wpid-emacs-my-app.png?fit=1024%2C555&amp;ssl=1" src="/assets/wp/how-to-cleanly-integrate-java-and-clojure-in-the-same-package/wpid-emacs-my-app-2.png" alt="" class="wp-image-1016"/></a></figure>



<p class="wp-block-paragraph"></p>



<h2 class="wp-block-heading">A hybrid Java/Clojure library designed to demonstrate how to setup Java interop using Maven</h2>



<div id="outline-container-orgheadline1" class="outline-2">
<div id="text-orgheadline1" class="outline-text-2">
<p>This is a complete Maven-first Clojure/Java interop application. It details how to create a Maven application, enrich it with clojure code, call into clojure from Java, and hook up the entry points for both Java and Clojure within the same project.</p>
<p>Further, it contains my starter examples of using the fantastic <a href="http://incanter.org/">Incanter Statistical and Graphics Computing Library</a> in clojure. I include both a pom.xml and a project.clj showing how to pull in the dependencies.</p>
<p>The outcome is a consistent maven-archetyped project, wherein maven and leiningen play nicely together. This allows the best of both ways to be applied together. For the emacs user, I include support for cider and swank. NRepl by itself is present for general purpose use as well.</p>
</div>
</div>



<div id="outline-container-orgheadline35" class="outline-2">
<h2 id="orgheadline35">Starting a project</h2>
<div id="text-orgheadline35" class="outline-text-2"></div>
<div id="outline-container-orgheadline34" class="outline-3">
<h3 id="orgheadline34">Maven first</h3>
<div id="text-orgheadline34" class="outline-text-3"></div>
<div id="outline-container-orgheadline2" class="outline-4">
<h4 id="orgheadline2">Create Maven project</h4>
<div id="text-orgheadline2" class="outline-text-4">
<p>follow these steps</p>
</div></div></div></div>



~~~ bash
mvn archetype:generate -DgroupId=com.mycompany.app -DartifactId=my-app -DarchetypeArtifactId=maven-archetype-quickstart -DinteractiveMode=false

cd my-app

mvn package

java -cp target/my-app-1.0-SNAPSHOT.jar com.mycompany.app.App
~~~





~~~ java
Hello World
~~~




<div id="outline-container-orgheadline3" class="outline-4">
<h4 id="orgheadline3">Add Clojure code</h4>
<div id="text-orgheadline3" class="outline-text-4">
<p>Create a clojure core file</p>
</div></div>



~~~ bash
mkdir -p src/main/clojure/com/mycompany/app

touch src/main/clojure/com/mycompany/app/core.clj
~~~




<p class="wp-block-paragraph">Give it some goodness…</p>



~~~ clojure
(ns com.mycompany.app.core
(:gen-class)
(:use (incanter core stats charts)))

(defn -main [& args]
(println "Hello Clojure!")
(println "Java main called clojure function with args: "
(apply str (interpose " " args))))

(defn run []
(view (histogram (sample-normal 1000))))
~~~




<p class="wp-block-paragraph">Notice that we&#8217;ve added in the <a href="http://incanter.org/">Incanter Library</a> and made a run function to pop up a histogram of sample data</p>



<div id="outline-container-orgheadline4" class="outline-4">
<h4 id="orgheadline4">Add dependencies to your pom.xml</h4>
<div id="text-orgheadline4" class="outline-text-4">
</div></div>



~~~ xml
<dependencies>
<dependency>
<groupId>org.clojure</groupId>
<artifactId>clojure</artifactId>
<version>1.7.0</version>
</dependency>
<dependency>
<groupId>org.clojure</groupId>
<artifactId>clojure-contrib</artifactId>
<version>1.2.0</version>
</dependency>
<dependency>
<groupId>incanter</groupId>
<artifactId>incanter</artifactId>
<version>1.9.0</version>
</dependency>
<dependency>
<groupId>org.clojure</groupId>
<artifactId>tools.nrepl</artifactId>
<version>0.2.10</version>
</dependency>
<!-- pick your poison swank or cider. just make sure the version of nRepl matches. -->
<dependency>
<groupId>cider</groupId>
<artifactId>cider-nrepl</artifactId>
<version>0.10.0-SNAPSHOT</version>
</dependency>
<dependency>
<groupId>swank-clojure</groupId>
<artifactId>swank-clojure</artifactId>
<version>1.4.3</version>
</dependency>
</dependencies>
~~~




<div id="outline-container-orgheadline5" class="outline-4">
<h4 id="orgheadline5">Java main class</h4>
<div id="text-orgheadline5" class="outline-text-4">
<p>Modify your java main to call your clojure main like in the following:</p>
</div></div>



~~~ java
package com.mycompany.app;

// for clojure's api
import clojure.lang.IFn;
import clojure.java.api.Clojure;

// for my api
import clojure.lang.RT;

public class App
{
public static void main( String[] args )
{

System.out.println("Hello Java!" );

try {

// running my clojure code
RT.loadResourceScript("com/mycompany/app/core.clj");
IFn main = RT.var("com.mycompany.app.core", "main");
main.invoke(args);

// running the clojure api
IFn plus = Clojure.var("clojure.core", "+");
System.out.println(plus.invoke(1, 2).toString());

} catch(Exception e) {
e.printStackTrace();
}

}
}
~~~




<div id="outline-container-orgheadline6" class="outline-4">
<h4 id="orgheadline6">Maven plugins for building</h4>
<div id="text-orgheadline6" class="outline-text-4">
<p>You should add in these plugins to your pom.xml</p>
</div>
<ul class="org-ul">
<li><a id="orgheadline7"></a>Add the maven-assembly-plugin
<div id="text-orgheadline7" class="outline-text-5">
<p>Create an Ubarjar</p>
<p>Bind the maven-assembly-plugin to the package phase this will create a jar file without the dependencies suitable for deployment to a container with deps present.</p>
</div></li></ul></div>



~~~ xml
  <plugin>
    <artifactId>maven-assembly-plugin</artifactId>
<configuration>
<descriptorRefs>
<descriptorRef>jar-with-dependencies</descriptorRef>
</descriptorRefs>
<archive>
<manifest>

<!-- use clojure main -->
<!-- <mainClass>com.mycompany.app.core</mainClass> -->

<!-- use java main -->
<mainClass>com.mycompany.app.App</mainClass>

</manifest>
</archive>
</configuration>
<executions>
<execution>
<id>make-assembly</id>
        <phase>package</phase>
        <goals>
<goal>single</goal>
</goals>
</execution>
</executions>
  </plugin>
~~~




<li><a id="orgheadline8"></a>Add the clojure-maven-plugin
<div id="text-orgheadline8" class="outline-text-5">
<p>Add this plugin to give your project the mvn: clojure:… commands</p>
<p>A full list of these is posted later in this article.</p>
</div></li>



~~~ xml
  <plugin>
    <groupId>com.theoryinpractise</groupId>
<artifactId>clojure-maven-plugin</artifactId>
<version>1.7.1</version>
<configuration>
<mainClass>com.mycompany.app.core</mainClass>
</configuration>
<executions>
<execution>
<id>compile-clojure</id>
        <phase>compile</phase>
        <goals>
<goal>compile</goal>
</goals>
</execution>
<execution>
<id>test-clojure</id>
        <phase>test</phase>
        <goals>
<goal>test</goal>
</goals>
</execution>
</executions>
  </plugin>
~~~




<li><a id="orgheadline9"></a>Add the maven-compiler-plugin
<div id="text-orgheadline9" class="outline-text-5">
<p>Add Java version targeting</p>
<p>This is always good to have if you are working against multiple versions of Java.</p>
</div></li>



~~~ xml
  <plugin>
    <groupId>org.apache.maven.plugins</groupId>
<artifactId>maven-compiler-plugin</artifactId>
<version>3.3</version>
<configuration><source>1.8</source>
<target>1.8</target>
</configuration>
  </plugin>
~~~




<li><a id="orgheadline10"></a>Add the maven-exec-plugin
<div id="text-orgheadline10" class="outline-text-5">
<p>Add this plugin to give your project the mvn exec:… commands</p>
<p>The maven-exec-plugin is nice for running your project from the commandline, build scripts, or from inside an IDE.</p>
</div></li>



~~~ xml
  <plugin>
    <groupId>org.codehaus.mojo</groupId>
<artifactId>exec-maven-plugin</artifactId>
<version>1.4.0</version>
<executions>
<execution>
<goals>
<goal>exec</goal>
</goals>
</execution>
</executions>
<configuration>
<mainClass>com.mycompany.app.App</mainClass>
</configuration>
  </plugin>
~~~




<li><a id="orgheadline11"></a>Add the maven-jar-plugin
<div id="text-orgheadline11" class="outline-text-5">
<p>With this plugin you can manipulate the manifest of your default package. In this case, I&#8217;m not adding a main, because I&#8217;m using the uberjar above with all the dependencies for that. However, I included this section for cases, where the use case is for a non-stand-alone assembly.</p>
</div></li>



~~~ xml
  <plugin>
    <groupId>org.apache.maven.plugins</groupId>
<artifactId>maven-jar-plugin</artifactId>
<version>2.6</version>
<configuration>
<archive>
<manifest>

<!-- use clojure main -->
<!-- <mainClass>com.mycompany.app.core</mainClass> -->

<!-- use java main -->
<!-- <mainClass>com.mycompany.app.App</mainClass> -->

</manifest>
</archive>
</configuration>
  </plugin>
~~~




<div id="outline-container-orgheadline29" class="outline-4">
<h4 id="orgheadline29">Using Maven</h4>
<div id="text-orgheadline29" class="outline-text-4"></div>
<ul class="org-ul">
<li><a id="orgheadline12"></a>building
<div id="text-orgheadline12" class="outline-text-5">
</div></li></ul></div>



~~~ bash
mvn package
~~~




<ul class="wp-block-list org-ul">
<li><a id="orgheadline16"></a>Run from cli with
<ul class="wp-block-list">
<li><a id="orgheadline13"></a>run from java entry point:<br><div id="text-orgheadline13" class="outline-text-7"><br></div></li>
</ul>
</li>
</ul>



~~~ bash
java -cp target/my-app-1.0-SNAPSHOT-jar-with-dependencies.jar com.mycompany.app.App
~~~




<li><a id="orgheadline14"></a>Run from Clojure entry point:
<div id="text-orgheadline14" class="outline-text-7">
</div></li>



~~~ bash
java -cp target/my-app-1.0-SNAPSHOT-jar-with-dependencies.jar com.mycompany.app.core
~~~




<li><a id="orgheadline15"></a>Run with entry point specified in uberjar MANIFEST.MF:
<div id="text-orgheadline15" class="outline-text-7">
</div></li>



~~~ bash
java -jar target/my-app-1.0-SNAPSHOT-jar-with-dependencies.jar
~~~




<li><a id="orgheadline22"></a>Run from maven-exec-plugin
<ul class="org-ul">
<li><a id="orgheadline17"></a>With plugin specified entry point:
<div id="text-orgheadline17" class="outline-text-7">
</div></li></ul></li>



~~~ bash
mvn exec:java
~~~




<li><a id="orgheadline20"></a>Specify your own entry point:
<ul class="org-ul">
<li><a id="orgheadline18"></a>Java main
<div id="text-orgheadline18" class="outline-text-8">
</div></li></ul></li>



~~~ bash
mvn exec:java -Dexec.mainClass="com.mycompany.app.App"
~~~




<li><a id="orgheadline19"></a>Clojure main
<div id="text-orgheadline19" class="outline-text-8">
</div></li>



~~~ bash
mvn exec:java -Dexec.mainClass="com.mycompany.app.core"
~~~




<li><a id="orgheadline21"></a>Feed args with this directive
<div id="text-orgheadline21" class="outline-text-7">
</div></li>



~~~ text
-Dexec.args="foo"
~~~




<li><a id="orgheadline28"></a>Run with maven-clojure-plugin
<ul class="org-ul">
<li><a id="orgheadline23"></a>Clojure main
<div id="text-orgheadline23" class="outline-text-7">
</div></li></ul></li>



~~~ bash
mvn clojure:run
~~~




<li><a id="orgheadline25"></a>Clojure test
<ul class="org-ul">
<li><a id="orgheadline24"></a>Add a test
<div id="text-orgheadline24" class="outline-text-8">
<p>In order to be consistent with the test location convention in maven, create a path and clojure test file like this:</p>
</div></li></ul></li>



~~~ bash
mkdir src/test/clojure/com/mycompany/app

touch src/test/clojure/com/mycompany/app/core_test.clj
~~~




<p class="wp-block-paragraph">Add the following content:</p>



~~~ clojure
(ns com.mycompany.app.core-test
(:require [clojure.test :refer :all]
[com.mycompany.app.core :refer :all]))

(deftest a-test
(testing "Rigourous Test :-)"
(is (= 0 0))))
~~~




<li><a id="orgheadline26"></a>Testing
<div id="text-orgheadline26" class="outline-text-7">
</div></li>



~~~ bash
mvn clojure:test
~~~




<p class="wp-block-paragraph">Or</p>



~~~ bash
mvn clojure:test-with-junit
~~~




<li><a id="orgheadline27"></a>Available Maven clojure:&#8230; commands
<div id="text-orgheadline27" class="outline-text-7">
<p>Here is the full set of options available from the clojure-maven-plugin:</p>
</div></li>



~~~ text
mvn ...

clojure:add-source
clojure:add-test-source
clojure:compile
clojure:test
clojure:test-with-junit
clojure:run
clojure:repl
clojure:nrepl
clojure:swank
clojure:nailgun
clojure:gendoc
clojure:autodoc
clojure:marginalia
~~~




<p class="wp-block-paragraph">See documentation:</p>



<figure class="wp-block-embed"><div class="wp-block-embed__wrapper">
<a href="https://github.com/talios/clojure-maven-plugin" rel="nofollow">https://github.com/talios/clojure-maven-plugin</a>
</div></figure>



<div id="outline-container-orgheadline33" class="outline-4">
<h4 id="orgheadline33">Add Leiningen support</h4>
<div id="text-orgheadline33" class="outline-text-4"></div>
<ul class="org-ul">
<li><a id="orgheadline30"></a>Create project.clj
<div id="text-orgheadline30" class="outline-text-5">
<p>Next to your pom.xml, create the Clojure project file</p>
</div></li></ul></div>



~~~ bash
touch project.clj
~~~




<p class="wp-block-paragraph">Add this content</p>



~~~ clojure
(defproject my-sandbox "1.0-SNAPSHOT"
:description "My Encanter Project"
:url "http://joelholder.com"
:license {:name "Eclipse Public License"
:url "http://www.eclipse.org/legal/epl-v10.html"}
:dependencies [[org.clojure/clojure "1.7.0"]
[incanter "1.9.0"]]
:main com.mycompany.app.core
:source-paths ["src/main/clojure"]
:java-source-paths ["src/main/java"]
:test-paths ["src/test/clojure"]
:resource-paths ["resources"]
:aot :all)
~~~




<p class="wp-block-paragraph">Note that we&#8217;ve set the source code and test paths for both java and clojure to match the maven-way of doing this.</p>



<p class="wp-block-paragraph">This gives us a consistent way of hooking the code from both <code>lein</code> and <code>mvn</code>. Additionally, I&#8217;ve added the incanter library here. The dependency should be expressed in the project file, because when we run nRepl from this directory, we want it to be available in our namespace, i.e. <code>com.mycompany.app.core</code></p>



<li><a id="orgheadline31"></a>Run with Leiningen
<div id="text-orgheadline31" class="outline-text-5">
</div></li>



~~~ bash
lein run
~~~




<li><a id="orgheadline32"></a>Test with Leiningen
<div id="text-orgheadline32" class="outline-text-5">
</div></li>



~~~ bash
lein test
~~~




<div id="outline-container-orgheadline36" class="outline-2">
<h2 id="orgheadline36">Running with org-babel</h2>
<div id="text-orgheadline36" class="outline-text-2">
<p>This blog entry was exported to html from the README.org of this project.  It sits in the base directory of the project.  By using it to describe the project and include executable blocks of code from the project itself, we&#8217;re able to provide working examples of how to use the library in it&#8217;s documentation.  People can simply clone our project and try out the library by executing it&#8217;s documentation.  Very nice..</p>
<p>Make sure you jack-in to cider first:</p>
<p>M-x cider-jack-in (Have it mapped to F9 in my emacs)</p>
</div>
<div id="outline-container-orgheadline37" class="outline-3">
<h3 id="orgheadline37">Clojure code</h3>
<div id="text-orgheadline37" class="outline-text-3">
<p>The Clojure code block</p>

~~~ java
#+begin_src clojure :tangle ./src/main/clojure/com/mycompany/app/core.clj :results output
  (-main)
  (run)
#+end_src
~~~

<p>Blocks are run in org-mode with C-c C-c </p>
</div></div></div>



~~~ clojure
(-main)
(run)
~~~





~~~ java
Hello Clojure!
Java main called clojure function with args:
~~~




<p class="wp-block-paragraph">Note that we ran both our main and run functions here. -main prints out the text shown above. The run function actually opens the incanter java image viewer and shows us a picture of our graph.</p>



<div class="figure">
<figure><img data-recalc-dims="1" decoding="async" src="/assets/wp/how-to-cleanly-integrate-java-and-clojure-in-the-same-package/wpid-run.png" alt="run.png"></figure><p></p>
</div>



<p class="wp-block-paragraph">I have purposefully not invested in styling these graphs in order to keep the code examples simple and focussed, however incanter makes really beautiful output. Here&#8217;s a link to get you started:</p>



<p class="wp-block-paragraph"><a href="http://incanter.org/">http://incanter.org/</a></p>



<div id="outline-container-orgheadline38" class="outline-3">
<h3 id="orgheadline38">Playing with Incanter</h3>
<div id="text-orgheadline38" class="outline-text-3">
</div></div>



~~~ clojure
(use '(incanter core charts pdf))
;;; Create the x and y data:
(def x-data [0.0 1.0 2.0 3.0 4.0 5.0])
(def y-data [2.3 9.0 2.6 3.1 8.1 4.5])
(def xy-line (xy-plot x-data y-data))
(view xy-line)
(save-pdf xy-line "img/incanter-xy-line.pdf")
(save xy-line "img/incanter-xy-line.png")
~~~




<div id="outline-container-orgheadline39" class="outline-3">
<h3 id="orgheadline39">PNG</h3>
<div id="text-orgheadline39" class="outline-text-3">
<div class="figure">
<figure><img data-recalc-dims="1" decoding="async" src="/assets/wp/how-to-cleanly-integrate-java-and-clojure-in-the-same-package/wpid-incanter-xy-line.png" alt="incanter-xy-line.png"></figure><p></p>
</div>
</div>
</div>



<div id="outline-container-orgheadline40" class="outline-3">
<h3 id="orgheadline40">PDF</h3>
<div id="text-orgheadline40" class="outline-text-3">
<p><a href="/assets/wp/how-to-cleanly-integrate-java-and-clojure-in-the-same-package/wpid-incanter-xy-line.pdf">img/incanter-xy-line.pdf</a></p>
</div>
</div>



<div id="outline-container-orgheadline41" class="outline-2">
<h2 id="orgheadline41">Resources</h2>
<div id="text-orgheadline41" class="outline-text-2">
<p>Finally here are some resources to move you along the journey. I drew on the links cited below along with a night of hacking to arrive a nice clean interop skeleton. Feel free to use my code available here:</p>
<p><a href="https://github.com/jclosure/my-app">https://github.com/jclosure/my-app</a></p>
<p>For the eager, here is a link to my full pom:</p>
<p><a href="https://github.com/jclosure/my-app/blob/master/pom.xml">https://github.com/jclosure/my-app/blob/master/pom.xml</a></p>
</div>
<div id="outline-container-orgheadline42" class="outline-3">
<h3 id="orgheadline42">Org-babel clojure</h3>
<div id="text-orgheadline42" class="outline-text-3">
<p><a href="http://orgmode.org/worg/org-contrib/babel/languages/ob-doc-clojure.html">http://orgmode.org/worg/org-contrib/babel/languages/ob-doc-clojure.html</a></p>
</div>
</div>
<div id="outline-container-orgheadline43" class="outline-3">
<h3 id="orgheadline43">Org-scraps</h3>
<div id="text-orgheadline43" class="outline-text-3">
<p><a href="https://eschulte.github.io/org-scraps/">https://eschulte.github.io/org-scraps/</a></p>
</div>
</div>
<div id="outline-container-orgheadline44" class="outline-3">
<h3 id="orgheadline44">Project setup</h3>
<div id="text-orgheadline44" class="outline-text-3">
<p><a href="http://data-sorcery.org/2009/11/20/leiningen-clojars/">http://data-sorcery.org/2009/11/20/leiningen-clojars/</a></p>
</div>
</div>
<div id="outline-container-orgheadline45" class="outline-3">
<h3 id="orgheadline45">Working with Apache Storm (multilang)</h3>
<div id="text-orgheadline45" class="outline-text-3">
<p>Starter project:</p>
<p>This incubator project from the Apache Foundation demos drinking from the twitter hose with twitter4j and fishing in the streams with Java, Clojure, Python, and Ruby. Very cool and very powerful..</p>
<p><a href="https://github.com/apache/storm/tree/master/examples/storm-starter">https://github.com/apache/storm/tree/master/examples/storm-starter</a></p>
<p>Testing Storm Topologies in Clojure:</p>
<p><a href="http://www.pixelmachine.org/2011/12/17/Testing-Storm-Topologies.html">http://www.pixelmachine.org/2011/12/17/Testing-Storm-Topologies.html</a></p>
</div>
</div>
<div id="outline-container-orgheadline46" class="outline-3">
<h3 id="orgheadline46">Vinyasa</h3>
<div id="text-orgheadline46" class="outline-text-3">
<p>READ this to give your clojure workflow more flow</p>
<p><a href="https://github.com/zcaudate/vinyasa">https://github.com/zcaudate/vinyasa</a></p>
</div>
</div>
</div>



<div id="outline-container-orgheadline47" class="outline-2">
<h2 id="orgheadline47">Wrapping up</h2>
<div id="text-orgheadline47" class="outline-text-2">
<p>Clojure and Java are siblings on the JVM; they should play nicely together. Maven enables them to be easily mixed together in the same project or between projects.  For a more indepth example of creating and consuming libraries written in Clojure, see Michael Richards&#8217; article detailing how to use Clojure to implement interfaces defined in Java. He uses a FactoryMethod to abstract the mechanics of getting the implementation back into Java, which make&#8217;s the Clojure code virtually invisible from an API perspective. Very nice. Here&#8217;s the link:</p>
<p><a href="http://michaelrkytch.github.io/programming/clojure/interop/2015/05/26/clj-interop-require.html">http://michaelrkytch.github.io/programming/clojure/interop/2015/05/26/clj-interop-require.html</a></p>
<p>Happy hacking!..</p>
</div>
</div>



<p class="wp-block-paragraph"></p>
