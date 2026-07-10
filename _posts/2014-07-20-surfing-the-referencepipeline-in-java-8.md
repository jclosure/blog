---
layout: post
title: "Surfing the ReferencePipeline in Java 8"
date: 2014-07-20 18:29:02 -0500
categories: []
tags: ["functional_programming", "java", "java8", "lambda_expressions"]
wordpress_id: 665
original_url: "https://joelholder.com/2014/07/20/surfing-the-referencepipeline-in-java-8/"
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


Java 8 includes new a <a href="http://docs.oracle.com/javase/8/docs/api/java/util/stream/package-summary.html">Stream Processing API</a>. At its core is the <a href="http://grepcode.com/file/repository.grepcode.com/java/root/jdk/openjdk/8-b132/java/util/stream/ReferencePipeline.java">ReferencePipeline</a> class which gives us a DSL for working with Streams in a functional style. You can get an instance of a ReferencePipeline flowing with a single expression.

<pre class="brush: java; title: ; notranslate" title="">

IntStream.range(1, 50)
         .mapToObj(i -&gt; new Thread(() -&gt; System.out.println(i)))
         .forEach(thread -&gt; thread.start());

</pre>

The MapReduce DSL has the essential set of list processing operations such as querying, mapping, and iterating. The operations can be chained to provide the notion of linked inline strategies.   When the stream of data is pulled through this pipeline, each data element passes through the operation chain.

Streams of data can be folded or <a href="http://docs.oracle.com/javase/tutorial/collections/streams/reduction.html">reduced</a> to a single value.

For example, here is how you can query a stream and accumulate the matches into a single value:

<pre class="brush: java; title: ; notranslate" title="">

String value = Stream.of(&quot;foo&quot;, &quot;bar&quot;, &quot;baz&quot;, &quot;quux&quot;)
		             .filter(s -&gt; s.contains(&quot;a&quot;) || s.endsWith(&quot;x&quot;))
		             .map(s -&gt; s.toUpperCase())
		             .reduce((acc, s) -&gt; acc + s);

</pre>

<figure id="attachment_762" aria-describedby="caption-attachment-762" style="width: 800px" class="wp-caption aligncenter"><a href="/blog/assets/wp/surfing-the-referencepipeline-in-java-8/pipeline1-new-page-1.png"><img data-recalc-dims="1" loading="lazy" decoding="async" data-attachment-id="762" data-permalink="https://joelholder.com/2014/07/20/surfing-the-referencepipeline-in-java-8/pipeline1-new-page-1/" data-orig-file="https://i0.wp.com/joelholder.com/wp-content/uploads/2014/07/pipeline1-new-page-1.png?fit=2138%2C375&amp;ssl=1" data-orig-size="2138,375" data-comments-opened="1" data-image-meta="{&quot;aperture&quot;:&quot;0&quot;,&quot;credit&quot;:&quot;&quot;,&quot;camera&quot;:&quot;&quot;,&quot;caption&quot;:&quot;&quot;,&quot;created_timestamp&quot;:&quot;0&quot;,&quot;copyright&quot;:&quot;&quot;,&quot;focal_length&quot;:&quot;0&quot;,&quot;iso&quot;:&quot;0&quot;,&quot;shutter_speed&quot;:&quot;0&quot;,&quot;title&quot;:&quot;&quot;}" data-image-title="pipeline1 &amp;#8211; New Page (1)" data-image-description="" data-image-caption="&lt;p&gt;Pipeline Flow For Code Sample &lt;/p&gt;
" data-large-file="https://i0.wp.com/joelholder.com/wp-content/uploads/2014/07/pipeline1-new-page-1.png?fit=1024%2C180&amp;ssl=1" class="wp-image-762 size-large" src="/blog/assets/wp/surfing-the-referencepipeline-in-java-8/pipeline1-new-page-1-2.png" alt="Pipeline Flow For Code Sample " width="800" height="140" /></a><figcaption id="caption-attachment-762" class="wp-caption-text">Pipeline Anatomy of Code Sample</figcaption></figure>

These functions are <a href="http://en.wikipedia.org/wiki/Monad_(functional_programming)">monadic operations</a> that enable us to query, transform, and project objects down the pipeline. The ReferencePipeline contains these functions. It is constructed to return copies of itself after each method invokation, giving us a chainable API. This API can be considered to be an architectural scaffolding for describing how to process Streams of data. 

See here how a pipeline can take in lines of CSV and emit structured row objects in the form of Arrays:

<pre class="brush: java; title: ; notranslate" title="">

//start with a stream

String csv = &quot;a,b,c\n&quot;
		   + &quot;d,e,f\n&quot;
		   + &quot;g,h,i\n&quot;;

//process the stream

Stream&lt;String&amp;#91;&amp;#93;&gt; rows = new BufferedReader(
		new InputStreamReader(new ByteArrayInputStream(
				csv.getBytes(&quot;UTF-8&quot;))))
		.lines()
		.skip(1)
		.map(line -&gt; line.split(&quot;,&quot;));

//print it out

rows.forEach(row -&gt; System.out.println(row&#x5B;0]
									 + row&#x5B;1]
									 + row&#x5B;2]));

</pre>

Notice that the stream processing routine is designed as a single expression.  The .lines() method initiates the pipeline.  Then we skip the headers (they are not data), and project out an array of fields with the .map().  This is nice.  We&#8217;re able to use a higher-order thought process when describing the algorithm to the JVM. Instead of diving into procedural control-flow, we simply tell the system what we want it to do by using a step-wise functional prescription. This style of programming leads to more readable and comprehensible code, and as you would expect, behind the scenes, the compiler converts the lambda syntax into Java classes, aka it gets &#8220;de-sugared&#8221; into Predicates (filters), Comparitors (sorters), BiFunctions (mappers), and Functions (accumulators). The lambda expressions make it so we do not to have to get our hands dirty with the details of Java&#8217;s functional programming object model.  

Consider the following example. 

I want to download historical stock pricing data from Yahoo and turn it into PricingRecord objects in my system.
<blockquote>
<h2>Yahoo Finance API</h2>
It&#8217;s data can be acquired with a simple HTTP Get call:

<a href="http://real-chart.finance.yahoo.com/table.csv?s=AMD&amp;d=6&amp;e=18&amp;f=2014&amp;g=d&amp;a=7&amp;b=9&amp;c=1996&amp;ignore=.csv">
http://real-chart.finance.yahoo.com/table.csv?s=AMD&#038;d=6&#038;e=18&#038;f=2014&#038;g=d&#038;a=7&#038;b=9&#038;c=1996&#038;ignore=.csv
</a></blockquote>
First note the shape of the CSV that Yahoo&#8217;s API returns:

<table>
<tbody>
<tr>
<th class="yfnc_tablehead1" scope="col" align="right" width="16%">Date</th>
<th class="yfnc_tablehead1" scope="col" align="right" width="12%">Open</th>
<th class="yfnc_tablehead1" scope="col" align="right" width="12%">High</th>
<th class="yfnc_tablehead1" scope="col" align="right" width="12%">Low</th>
<th class="yfnc_tablehead1" scope="col" align="right" width="12%">Close</th>
<th class="yfnc_tablehead1" scope="col" align="right" width="16%">Volume</th>
<th class="yfnc_tablehead1" scope="col" align="right" width="15%">Adj Close*</th>
</tr>
<tr>
<td class="yfnc_tabledata1" align="right" nowrap="nowrap">2008-12-29</td>
<td class="yfnc_tabledata1" align="right">15.98</td>
<td class="yfnc_tabledata1" align="right">16.16</td>
<td class="yfnc_tabledata1" align="right">15.98</td>
<td class="yfnc_tabledata1" align="right">16.08</td>
<td class="yfnc_tabledata1" align="right">158600</td>
<td class="yfnc_tabledata1" align="right">16.08</td>
</tr>
</tbody>
</table>

Our CSV looks like this:
<pre>2008-12-29,15.98,16.16,15.98,16.08,158600,16.08
</pre>
Let&#8217;s compose a simple recipe that uses the Stream API to pull this data from the web and turn it into objects that we can work with in our system.

Our program should do these things:
<ol>
	<li>Take in a set of stock symbols in the form of a Stream strings.</li>
	<li>
<div>Transform the Stream of symbols into a new Stream containing Streams of PricingRecords.</div>
<ul>
	<li>This will be done by Making a remote call to Yahoo&#8217;s API.</li>
	<li>The CSV returned should be mapped directly into PricingRecords objects.</li>
</ul>
</li>
	<li>Since we&#8217;re pulling the data for multiple symbols, we should do the API calls for each concurrently.  We can achieve this by parallelizing the flow of stream elements through the operation chain.</li>
</ol>

Here is the solution implemented as single composite expression. Note how we aquire a Stream<String>, process it, and emit a Map<String,List<PricingRecord>>.

<a name="code_example"></a>Using a ReferencePipeline as a builder:

<pre class="brush: java; title: ; notranslate" title="">

//start with a stream

Stream&lt;String&gt; stockStream = Stream.of(&quot;AMD&quot;, &quot;APL&quot;, &quot;IBM&quot;, &quot;GOOG&quot;);

//generate data with a stream processing algorithm

Map&lt;String, List&lt;PricingRecord&gt;&gt; pricingRecords = stockStream
		.parallel()
		.map(symbol -&gt; {

			try {
				String csv = new JdkRequest(String.format(&quot;http://real-chart.finance.yahoo.com/table.csv?s=%s&amp;d=6&amp;e=18&amp;f=2014&amp;g=d&amp;a=7&amp;b=9&amp;c=1996&amp;ignore=.csv&quot;, symbol))
							 .header(&quot;Accept&quot;, &quot;text/xml&quot;)
						     .fetch()
						     .body();

				return new BufferedReader(new InputStreamReader(new ByteArrayInputStream(csv.getBytes(&quot;UTF-8&quot;))))
					   .lines()
					   .skip(1)
					   .map(line -&gt; line.split(&quot;,&quot;))
					   .map(arr -&gt; new PricingRecord(symbol, arr&#x5B;0],arr&#x5B;1], arr&#x5B;2], arr&#x5B;3], arr&#x5B;4], arr&#x5B;5], arr&#x5B;6]));

			} catch (Exception e) {
				e.printStackTrace();
			}

			return symbol;
		})
		.flatMap(records -&gt; (Stream&lt;PricingRecord&gt;) records)
		.collect(Collectors.groupingBy(PricingRecord::getSymbol));


//print it out..

pricingRecords.forEach((symbol, records) -&gt; System.out.println(String
		.format(&quot;Symbol: %s\n%s&quot;,
				symbol,
				records.stream()
					   .parallel()
					   .map(record -&gt; record.toString())
					   .reduce((x, y) -&gt; x + y))));

</pre>

The elegance of this solution may not at first be apparent, but note a few key characteristics that emerge from a closer look. Notice that we get concurrency for free with the .parallel(). We do this near the beginning of the pipeline, in order to feed the downstream .map() function in a multithreaded manner.

Notice also that we&#8217;re projecting a 2-dimensional Stream out of the .map() function. The top-level stream contains a substream of Stream objects. The composite type it returns is actually a Stream<Stream<PricingRecord>>. This is a common scenario in stream-based programming and the solution to unpack and harvest the substream is to use the .flatMap() function. It provides the affordance we need for working with structure in a 2-dimensional stream. Note that the <a href="http://grepcode.com/file/repository.grepcode.com/java/root/jdk/openjdk/8-b132/java/util/stream/ReferencePipeline.java">ReferencePipeline</a> also provides us with a .substream(n) function for working with n-dimensional streams. In my example, we use .flatMap() to unpack and return a cast over the elements to coerce them into PricingRecord objects.

Finally, look at the last expression in the chain the .collect(). To collect the stream is to terminate it, which means to enumerate its full contents. Basically this means to load them into memory, however there are many ways in which you might want to do this. For this we have what are called Collectors; they allow us to describe how we want the contents of the stream organized when they are pulled out.
<blockquote>
<h2>Usage Tip:</h2>
If you want a flat list use:
Collectors.toList // ArrayList

If you want a map or dictionary-like structure, use:
Collectors.groupingBy // Map</blockquote>
The .groupingBy() function that I use <a href="#code_example">above</a> allows us to aggregate our stream into groups based on a common characteristic. The Maps that .groupingBy() projects are very useful because you can represent both the input to the function and its output as a &#8220;pair&#8221;, e.g. Map.SimpleEntry (key value pair).

For completeness I should provide the PricingRecord class:

<pre class="brush: java; title: ; notranslate" title="">
public class PricingRecord {
	private String symbol;
	private String date;
	private double open;
	private double high;
	private double low;
	private double close;
	private int volume;
	private double adjustedClose;

	public PricingRecord (String symbol, String date, String open, String high, String low, String close, String volume, String adjustedClose){
		this.setSymbol(symbol);
		this.date = date;
		this.open = Double.parseDouble(open);
		this.high = Double.parseDouble(high);
		this.low = Double.parseDouble(low);
		this.close = Double.parseDouble(close);
		this.volume = Integer.parseInt(volume);
		this.adjustedClose = Double.parseDouble(adjustedClose);
	}

	public String toString(){
		return String.format(&quot;symbol=%s,date=%s,open=%.2f,close=%.2f,high=%.2f,low=%.2f,volume=%s,adjustedClose=%.2f&quot;, this.symbol, this.date, this.open, this.close, this.high, this.low, this.volume, this.adjustedClose);

	}

	public String getDate() {
		return date;
	}
	public void setDate(String date) {
		this.date = date;
	}
	public double getOpen() {
		return open;
	}
	public void setOpen(double open) {
		this.open = open;
	}
	public double getHigh() {
		return high;
	}
	public void setHigh(double high) {
		this.high = high;
	}
	public double getLow() {
		return low;
	}
	public void setLow(double low) {
		this.low = low;
	}
	public double getClose() {
		return close;
	}
	public void setClose(double close) {
		this.close = close;
	}
	public int getVolume() {
		return volume;
	}
	public void setVolume(int volume) {
		this.volume = volume;
	}
	public double getAdjustedClose() {
		return adjustedClose;
	}
	public void setAdjustedClose(double adjustedClose) {
		this.adjustedClose = adjustedClose;
	}
	public String getSymbol() {
		return symbol;
	}
	public void setSymbol(String symbol) {
		this.symbol = symbol;
	}

}
</pre>

This is a simple entity class. It just serves to represent our logical notion of a PricingRecord, however I want you to notice the .toString(). It simply prints out the object, but notice in the last expression of the <a href="#code_example">code example</a> how we&#8217;re able to print a concatenation of these objects out to the console as a String. The .reduce() function allows us to accumulate the result of each symbol&#8217;s data and print it out in a logically separated and intelligible way. Reducers are what I like to think of as &#8220;distillers&#8221; of information in the streams we process. In this way, they can be made to aggregate and refine information from the stream as it passes through the pipeline.

Finally, in order to run the <a href="#code_example">code example</a> as is, you&#8217;ll need to pull in the <a href="https://github.com/jcabi/jcabi-http">jcabi-http </a>library to get the nice fluent web api that I&#8217;m using. Add this to your pom.xml and resolve the imports.

<pre class="brush: xml; title: ; notranslate" title="">
&lt;dependency&gt;
	&lt;groupId&gt;com.jcabi&lt;/groupId&gt;
	&lt;artifactId&gt;jcabi-http&lt;/artifactId&gt;
	&lt;version&gt;1.8&lt;/version&gt;
&lt;/dependency&gt;
</pre>

The introduction of this functional programming model into Java, is a leap forward for the platform. It signals a shift in not only the way we write the code in the language, but also how we think about solving problems with it. So called higher-order problem solving requires higher-order tools. This technology is compelling because it give us these high-level tools and a fun syntax that allows us to focus on problem to be solved, not on the cruft it takes to solve it. This makes life better for everyone..
