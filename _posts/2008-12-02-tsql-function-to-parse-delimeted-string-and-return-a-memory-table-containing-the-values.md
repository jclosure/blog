---
layout: post
title: "TSQL function to parse delimeted string and return a memory table containing the values"
date: 2008-12-02 13:12:55 -0600
categories: []
tags: []
wordpress_id: 17
original_url: "https://joelholder.com/2008/12/02/tsql-function-to-parse-delimeted-string-and-return-a-memory-table-containing-the-values/"
---
<div id="msgcns!3FC3980D58CF7EFB!237" class="bvMsg">
<div>This script is useful when you need to generate a rowset from a delimeted string.  It allows the &#8220;WHERE IN&#8221; clause to be used against the values in the string, because they are converted into table rows.  This UDF is designed to be plugged into other queries where this need is present.  Here&#8217;s an example of how to use it:</div>
<div> </div>
<div>Basic Usage:</div>
<div><font color="#0000ff" size="2"></p>
<p>select</font><font color="#000000" size="2"> VALUE</font><font color="#000000" size="2"> </font><font color="#0000ff" size="2">from</font><font color="#000000" size="2"> PARSE_STRING</font><font color="#808080" size="2">(</font><font color="#ff0000" size="2">&#8216;a,b,c,d,e&#8217;</font><font color="#808080" size="2">,</font><font color="#000000" size="2"> </font><font color="#ff0000" size="2">&#8216;,&#8217;</font><font color="#808080" size="2">)</font><font size="2"> </font></p>
<p><font size="2">GO</font> </p>
<div>Real World Usage:</div>
<p><font color="#0000ff"></p>
<p><font size="2">select</font></p>
<p></font><font size="2"><font color="#000000"> </font><font color="#808080">*</font><font color="#000000"> </font><font color="#0000ff">from</font><font color="#000000"> customers </font><font color="#0000ff">where</font><font color="#000000"> last_name </font><font color="#808080">in</font><font color="#000000"> </font><font color="#808080">(</font><font color="#0000ff">select</font><font color="#000000"> </font><font color="#808080">VALUE</font><font color="#000000"> </font><font color="#0000ff">from</font><font color="#000000"> PARSE_STRING</font><font color="#808080">(</font><font color="#ff0000">&#8216;obama,biden,clinton,holder&#8217;</font><font color="#808080">,</font><font color="#000000"> </font><font color="#ff0000">&#8216;,&#8217;</font><font color="#808080">))</font></font> </p>
<p><font color="#808080"><font color="#444444" size="2">GO</font></font></p>
</p>
</div>
<div> </div>
<div>The Function:</div>
<div> </div>
<div><font color="#0000ff" size="2"></p>
<p>SET</p>
<p></font><font color="#000000" size="2"> </font><font color="#0000ff" size="2">ANSI_NULLS</font><font color="#000000" size="2"> </font><font color="#0000ff" size="2">ON</font><font size="2"> </p>
<p>GO</p>
<p></font><font color="#0000ff" size="2"> </p>
<p>SET</p>
<p></font><font color="#000000" size="2"> </font><font color="#0000ff" size="2">QUOTED_IDENTIFIER</font><font color="#000000" size="2"> </font><font color="#0000ff" size="2">ON</font><font size="2"> </p>
<p>GO</p>
<p></font><font color="#008000" size="2"> </p>
<p>&#8212; ============================================= </p>
<p>&#8212; Author: Joel Holder </p>
<p>&#8212; Description: parses a delimeted string and returns a table </p>
<p>&#8212; ============================================= </p>
<p>  </p>
<p>/****** Object: UserDefinedFunction [dbo].[PARSE_STRING] ******/</p>
</p>
</p>
<p></font><font color="#0000ff" size="2"> </p>
<p>IF</p>
<p></font><font color="#000000" size="2"> </font><font color="#808080" size="2">EXISTS</font><font color="#000000" size="2"> </font><font color="#808080" size="2">(</font><font color="#0000ff" size="2">SELECT</font><font color="#000000" size="2"> </font><font color="#808080" size="2">*</font><font color="#000000" size="2"> </font><font color="#0000ff" size="2">FROM</font><font color="#000000" size="2"> </font><font color="#008000" size="2">sys.objects</font><font color="#000000" size="2"> </font><font color="#0000ff" size="2">WHERE</font><font color="#000000" size="2"> </font><font color="#ff00ff" size="2">object_id</font><font color="#000000" size="2"> </font><font color="#808080" size="2">=</font><font color="#000000" size="2"> </font><font color="#ff00ff" size="2">OBJECT_ID</font><font color="#808080" size="2">(</font><font color="#000000" size="2">N</font><font color="#ff0000" size="2">&#8216;[dbo].[PARSE_STRING]&#8217;</font><font color="#808080" size="2">)</font><font color="#000000" size="2"> </font><font color="#808080" size="2">AND</font><font color="#000000" size="2"> </font><font color="#0000ff" size="2">type</font><font color="#000000" size="2"> </font><font color="#808080" size="2">in</font><font color="#000000" size="2"> </font><font color="#808080" size="2">(</font><font color="#000000" size="2">N</font><font color="#ff0000" size="2">&#8216;FN&#8217;</font><font color="#808080" size="2">,</font><font color="#000000" size="2"> N</font><font color="#ff0000" size="2">&#8216;IF&#8217;</font><font color="#808080" size="2">,</font><font color="#000000" size="2"> N</font><font color="#ff0000" size="2">&#8216;TF&#8217;</font><font color="#808080" size="2">,</font><font color="#000000" size="2"> N</font><font color="#ff0000" size="2">&#8216;FS&#8217;</font><font color="#808080" size="2">,</font><font color="#000000" size="2"> N</font><font color="#ff0000" size="2">&#8216;FT&#8217;</font><font color="#808080" size="2">))</font><font color="#0000ff" size="2"> </p>
<p>    DROP</p>
<p></font><font color="#000000" size="2"> </font><font color="#0000ff" size="2">FUNCTION</font><font color="#000000" size="2"> [dbo]</font><font color="#808080" size="2">.</font><font size="2"><font color="#000000">[PARSE_STRING]</font> </p>
<p>go</p>
<p></font><font color="#0000ff" size="2"> </p>
<p>CREATE</p>
<p></font><font color="#000000" size="2"> </font><font color="#0000ff" size="2">FUNCTION</font><font size="2"><font color="#000000"> PARSE_STRING  </font></font><font color="#808080" size="2">(</font><font size="2">@string </font><font color="#0000ff" size="2">nvarchar</font><font color="#808080" size="2">(</font><font color="#ff00ff" size="2">max</font><font color="#808080" size="2">),</font><font size="2">  @delimeter </font><font color="#0000ff" size="2">char</font><font color="#808080" size="2">(</font><font size="2">1</font><font color="#808080" size="2">))</font><font color="#0000ff" size="2"> </p>
<p>RETURNS</p>
<p></font><font size="2"><font color="#000000"> </font>@result_table </font><font color="#0000ff" size="2">TABLE</font><font size="2"> </font><font color="#808080" size="2">(</font><font size="2">POSITION </font><font color="#0000ff" size="2">int</font><font color="#808080" size="2">,</font><font size="2"> </font><font color="#0000ff" size="2">VALUE</font><font size="2"> </font><font color="#0000ff" size="2">nvarchar</font><font color="#808080" size="2">(</font><font color="#ff00ff" size="2">max</font><font color="#808080" size="2">))</font><font color="#0000ff" size="2"> </p>
<p>AS </p>
<p>BEGIN</p>
</p>
<p></font><font size="2"> </p>
<p></font><font color="#008000" size="2">&#8212; Fill the table variable with the rows for your result set</font><font size="2"> </p>
<p></font><font color="#0000ff" size="2">declare</font><font size="2"> @pos </font><font color="#0000ff" size="2">int</font><font size="2"> </p>
<p></font><font color="#0000ff" size="2">declare</font><font size="2"> @piece </font><font color="#0000ff" size="2">varchar</font><font color="#808080" size="2">(</font><font size="2">500</font><font color="#808080" size="2">)</font><font size="2"> </p>
<p></font><font color="#0000ff" size="2">declare</font><font size="2"> @id </font><font color="#0000ff" size="2">int</font><font size="2"> </p>
<p></font><font color="#0000ff" size="2">set</font><font size="2"> @id </font><font color="#808080" size="2">=</font><font size="2"> 0 </p>
<p></font><font color="#008000" size="2">&#8212; Need to tack a delimiter onto the end of the input string if one doesn&#8217;t exist</font><font size="2"> </p>
<p></font><font color="#0000ff" size="2">    if</font><font size="2"> </font><font color="#808080" size="2">right(</font><font color="#ff00ff" size="2">rtrim</font><font color="#808080" size="2">(</font><font size="2">@string</font><font color="#808080" size="2">),</font><font size="2">1</font><font color="#808080" size="2">)</font><font size="2"> </font><font color="#808080" size="2"><></font><font size="2"> @delimeter </p>
<p></font><font color="#0000ff" size="2">    set</font><font size="2"> @string </font><font color="#808080" size="2">=</font><font size="2"> @string </font><font color="#808080" size="2">+</font><font size="2"> @delimeter </p>
<p></font><font color="#0000ff" size="2">    set</font><font size="2"> @pos </font><font color="#808080" size="2">=</font><font size="2"> </font><font color="#ff00ff" size="2">patindex</font><font color="#808080" size="2">(</font><font color="#ff0000" size="2">&#8216;%&#8217;</font><font size="2"> </font><font color="#808080" size="2">+</font><font size="2"> @delimeter </font><font color="#808080" size="2">+</font><font size="2"> </font><font color="#ff0000" size="2">&#8216;%&#8217;</font><font size="2"> </font><font color="#808080" size="2">,</font><font size="2"> @string</font><font color="#808080" size="2">)</font><font size="2"> </p>
<p></font><font color="#0000ff" size="2">    while</font><font size="2"> </font><font color="#808080" size="2">(</font><font size="2">@pos </font><font color="#808080" size="2"><></font><font size="2"> 0</font><font color="#808080" size="2">)</font><font size="2"> </p>
<p></font><font color="#0000ff" size="2">        begin</font><font size="2"> </p>
<p></font><font color="#0000ff" size="2">            set</font><font size="2"> @id </font><font color="#808080" size="2">=</font><font size="2"> @id </font><font color="#808080" size="2">+</font><font size="2"> 1 </p>
<p></font><font color="#0000ff" size="2">            set</font><font size="2"> @piece </font><font color="#808080" size="2">=</font><font size="2"> </font><font color="#808080" size="2">left(</font><font size="2">@string</font><font color="#808080" size="2">,</font><font size="2"> @pos </font><font color="#808080" size="2">&#8211;</font><font size="2"> 1</font><font color="#808080" size="2">)</font><font size="2"> </p>
<p></font><font color="#008000" size="2">            &#8212; You have a piece of data, so insert it, print it, do whatever you want to with it.</font><font size="2"> </p>
<p></font><font color="#0000ff" size="2">            insert</font><font size="2"> </font><font color="#0000ff" size="2">into</font><font size="2"> @result_table </font><font color="#0000ff" size="2">values</font><font size="2"> </font><font color="#808080" size="2">(</font><font size="2">@id</font><font color="#808080" size="2">,</font><font size="2"> @piece</font><font color="#808080" size="2">)</font><font size="2"> </p>
<p></font><font color="#0000ff" size="2">            set</font><font size="2"> @string </font><font color="#808080" size="2">=</font><font size="2"> </font><font color="#ff00ff" size="2">stuff</font><font color="#808080" size="2">(</font><font size="2">@string</font><font color="#808080" size="2">,</font><font size="2"> 1</font><font color="#808080" size="2">,</font><font size="2"> @pos</font><font color="#808080" size="2">,</font><font size="2"> </font><font color="#ff0000" size="2">&#8221;</font><font color="#808080" size="2">)</font><font size="2"> </p>
<p></font><font color="#0000ff" size="2">            set</font><font size="2"> @pos </font><font color="#808080" size="2">=</font><font size="2"> </font><font color="#ff00ff" size="2">patindex</font><font color="#808080" size="2">(</font><font color="#ff0000" size="2">&#8216;%&#8217;</font><font size="2"> </font><font color="#808080" size="2">+</font><font size="2"> @delimeter </font><font color="#808080" size="2">+</font><font size="2"> </font><font color="#ff0000" size="2">&#8216;%&#8217;</font><font size="2"> </font><font color="#808080" size="2">,</font><font size="2"> @string</font><font color="#808080" size="2">)</font><font size="2"> </p>
<p></font><font color="#0000ff" size="2">        end </p>
<p>  </p>
<p></font><font color="#0000ff" size="2">return</font><font size="2"> </font><font color="#0000ff" size="2"></p>
<p>END</font><font size="2"> </p>
<p>GO</p>
<p></font></div>
</div>
