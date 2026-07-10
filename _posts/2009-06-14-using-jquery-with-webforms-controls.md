---
layout: post
title: "Using JQuery With WebForms Controls"
date: 2009-06-14 21:19:30 -0500
categories: []
tags: []
wordpress_id: 8
original_url: "https://joelholder.com/2009/06/14/using-jquery-with-webforms-controls/"
---
<div id="msgcns!3FC3980D58CF7EFB!506" class="bvMsg">The scenario:  We have an ASP.NET CheckListBox from which we want to ensure at least one option has been selected before allowing the user to click a button.  Sounds simple enough, but we&#8217;re going to use JQuery to do all of this work on the client.  </p>
<p> </p>
<p>ASP.NET MARKUP:</p>
<p><span><%</span><span>@</span><span> <span style="color:#a31515;">Control</span> <span style="color:red;">Language</span><span style="color:blue;">=&#8221;C#&#8221;</span> <span style="color:red;">AutoEventWireup</span><span style="color:blue;">=&#8221;true&#8221;</span> <span style="color:red;">CodeBehind</span><span style="color:blue;">=&#8221;FileDownloadUserControl.ascx.cs&#8221;</span> <span style="color:red;">Inherits</span><span style="color:blue;">=&#8221;FileDownloadUserControl&#8221;</span> <span style="background:yellow;">%>
</p>
<p></span></span></p>
<p><span><</span><span>asp</span><span>:</span><span>CheckBoxList</span><span> <span style="color:red;">ID</span><span style="color:blue;">=&#8221;chklstFilesAvailable&#8221;</span> <span style="color:red;">runat</span><span style="color:blue;">=&#8221;server&#8221;</span></span><span><span style="color:blue;">> </p>
<p></span></span></p>
<p><span><</span><span>asp</span><span>:</span><span>Button</span><span> <span style="color:red;">style</span><span style="color:blue;">=&#8221;</span><span style="color:red;">display</span>: <span style="color:blue;">none&#8221;</span> <span style="color:red;">ID</span><span style="color:blue;">=&#8221;btnDownload&#8221;</span> <span style="color:red;">runat</span><span style="color:blue;">=&#8221;server&#8221;</span> <span style="color:red;">Text</span><span style="color:blue;">=&#8221;Download&#8221;</span> <span style="color:red;">OnClick</span><span style="color:blue;">=&#8221;btnDownload_Click&#8221;</span> <span style="color:blue;">/></span></span></p>
<p><span><span style="color:blue;"></span></span> </p>
<p><span><span style="color:blue;"></p>
<p></span></span></p>
<p>Simple and straightforward..  Now lets have a look at the HTML that this code results in.  With three items bound to our CheckListBox, we get this:</p>
<p> </p>
<p>RENDERED HTML MARKUP:</p>
<p><font color="#0070c0"></p>
<p style="margin:0;"><span style="font-family:'Courier New';color:blue;font-size:10pt;"></p>
<table id="ctl0_FileDownloadUserControl1_chklstFilesAvailable" border="0"></span></p>
<p style="margin:0;"><span style="font-family:'Courier New';color:blue;font-size:10pt;"></p>
<tr>
<td></span></p>
<p style="margin:0 0 0 .5in;"><span style="font-family:'Courier New';color:blue;font-size:10pt;"><input id="ctl0_FileDownloadUserControl1_chklstFilesAvailable_0" type="checkbox" name="ctl0$FileDownloadUserControl1$chklstFilesAvailable$0" /></span></p>
<p style="margin:0 0 0 .5in;"><span style="font-family:'Courier New';color:blue;font-size:10pt;"><label for="ctl0_FileDownloadUserControl1_chklstFilesAvailable_0">BLAH1_20090608.csv</label></span></p>
<p style="margin:0;"><span style="font-family:'Courier New';color:blue;font-size:10pt;"></td>
</tr>
<p></span></p>
<p style="margin:0;"><span style="font-family:'Courier New';color:blue;font-size:10pt;"></p>
<tr>
<td></span></p>
<p style="margin:0 0 0 .5in;"><span style="font-family:'Courier New';color:blue;font-size:10pt;"><input id="ctl0_FileDownloadUserControl1_chklstFilesAvailable_1" type="checkbox" name="ctl0$FileDownloadUserControl1$chklstFilesAvailable$1" /></span></p>
<p style="margin:0 0 0 .5in;"><span style="font-family:'Courier New';color:blue;font-size:10pt;"><label for="ctl0_FileDownloadUserControl1_chklstFilesAvailable_1">BLAH2_20090608.csv</label></span></p>
<p style="margin:0;"><span style="font-family:'Courier New';color:blue;font-size:10pt;"></td>
</tr>
<p></span></p>
<p style="margin:0;"><span style="font-family:'Courier New';color:blue;font-size:10pt;"></p>
<tr>
<td></span></p>
<p style="margin:0 0 0 .5in;"><span style="font-family:'Courier New';color:blue;font-size:10pt;"><input id="ctl0_FileDownloadUserControl1_chklstFilesAvailable_2" type="checkbox" name="ctl0$FileDownloadUserControl1$chklstFilesAvailable$2" /></span></p>
<p style="margin:0 0 0 .5in;"><span style="font-family:'Courier New';color:blue;font-size:10pt;"><label for="ctl0_FileDownloadUserControl1_chklstFilesAvailable_2">BLAH1_20090608.csv</label></span></p>
<p style="margin:0;"><span style="font-family:'Courier New';color:blue;font-size:10pt;"></td>
</tr>
<p></span></p>
<p style="margin:0;"><span style="font-family:'Courier New';color:blue;font-size:10pt;"></table>
<p></span></p>
<p style="margin:0;"><span style="font-family:'Courier New';color:blue;font-size:10pt;"><input type="submit" name="btnDownload" value="Download" id="btnDownload" /></span></p>
<p style="margin:0;"><span style="font-family:'Courier New';color:blue;font-size:10pt;"></span> </p>
<p></font><br />
<span></p>
<p></span></p>
<p>WebForms has created a table, labels, and checkboxes.  Note that the IDs have been changed from the original names we gave them.  We have effectively lost control of our ID naming at this point.  This makes it difficult to use JavaScript to target these elements after they&#8217;ve been rendered.  Here is a workaround to target the CheckListBox and the Button post render.</p>
<p>First we get the mangled IDs and use those values in JQuery selectors to create JQuery objects.  Then we pass them as parameters to the wireButtonShowToCheckListBox function in order to wire the click event of each checkbox to a nested anonymous function, which checks to see if at least one of the boxes are checked and, if so, shows the button.</p>
<p> </p>
<p><span></p>
<p></span></p>
<p>JAVASCRIPT:</p>
<p style="margin:0;"><span style="font-family:'Courier New';color:blue;font-size:10pt;"><</span><span style="font-family:'Courier New';color:#a31515;font-size:10pt;">script</span><span style="font-family:'Courier New';font-size:10pt;"><font color="#000000"> </font><span style="color:red;">type</span><span style="color:blue;">=&#8221;text/javascript&#8221;</span><font color="#000000"> </font><span style="color:red;">language</span><span style="color:blue;">=&#8221;javascript&#8221;></span></span></p>
<p style="margin:0;"><span style="font-family:'Courier New';color:blue;font-size:10pt;"> </span></p>
<p style="margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><font color="#000000">    $(document).ready(</font><span style="color:blue;">function</span><font color="#000000">() {</font></span></p>
<p style="margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><font color="#000000">        </font><span style="color:blue;">var</span><font color="#000000"> id = </font><span style="color:#a31515;">&#8220;<%= chklstFilesAvailable.ClientID %>&#8220;</span><font color="#000000">;</font></span></p>
<p style="margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><font color="#000000">        </font><span style="color:blue;">var</span><font color="#000000"> chklist = $(</font><span style="color:#a31515;">&#8220;#&#8221;</span><font color="#000000"> + id);</font></span></p>
<p style="margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><font color="#000000"> </font></span></p>
<p style="margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><font color="#000000">        </font><span style="color:blue;">var</span><font color="#000000"> btnId = </font><span style="color:#a31515;">&#8220;<%= btnDownload.ClientID %>&#8220;</span><font color="#000000">;</font></span></p>
<p style="margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><font color="#000000">        </font><span style="color:blue;">var</span><font color="#000000"> button = $(</font><span style="color:#a31515;">&#8220;#&#8221;</span><font color="#000000"> + btnId);</font></span></p>
<p style="margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><font color="#000000"> </font></span></p>
<p style="margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><font color="#000000">        </font><span style="color:green;">//reusable show/hide button wiring</span></span></p>
<p style="margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><font color="#000000">        wireButtonShowToCheckListBox(chklist, button);</font></span></p>
<p style="margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><font color="#000000">    });</font></span></p>
<p style="margin:0;"><span style="font-family:'Courier New';font-size:10pt;"><font color="#000000"> </font></span></p>
<p style="margin:0;"><span style="font-family:'Courier New';color:blue;font-size:10pt;"> </span></p>
<p style="margin:0 0 0 .5in;"><span style="font-family:'Courier New';color:blue;font-size:10pt;">function</span><span style="font-family:'Courier New';font-size:10pt;"><font color="#000000"> wireButtonShowToCheckListBox(chklist, button) {</font></span></p>
<p style="margin:0 0 0 .5in;"><span style="font-family:'Courier New';font-size:10pt;"><font color="#000000">    chklist.find(</font><span style="color:#a31515;">&#8216;input:checkbox&#8217;</span><font color="#000000">).each(</font><span style="color:blue;">function</span><font color="#000000">() {</font></span></p>
<p style="margin:0 0 0 .5in;"><span style="font-family:'Courier New';font-size:10pt;"><font color="#000000">        </font><span style="color:blue;">var</span><font color="#000000"> cb = $(</font><span style="color:blue;">this</span><font color="#000000">);</font></span></p>
<p style="margin:0 0 0 .5in;"><span style="font-family:'Courier New';font-size:10pt;"><font color="#000000">        cb.click(</font><span style="color:blue;">function</span><font color="#000000">() {</font></span></p>
<p style="margin:0 0 0 .5in;"><span style="font-family:'Courier New';font-size:10pt;"><font color="#000000"> </font></span></p>
<p style="margin:0 0 0 .5in;"><span style="font-family:'Courier New';font-size:10pt;"><font color="#000000">            </font><span style="color:blue;">var</span><font color="#000000"> hit = </font><span style="color:blue;">false</span><font color="#000000">;</font></span></p>
<p style="margin:0 0 0 .5in;"><span style="font-family:'Courier New';font-size:10pt;"><font color="#000000">            chklist.find(</font><span style="color:#a31515;">&#8216;input:checkbox&#8217;</span><font color="#000000">).each(</font><span style="color:blue;">function</span><font color="#000000">() {</font></span></p>
<p style="margin:0 0 0 .5in;"><span style="font-family:'Courier New';font-size:10pt;"><font color="#000000">                </font><span style="color:blue;">var</span><font color="#000000"> checked = $(</font><span style="color:blue;">this</span><font color="#000000">).attr(</font><span style="color:#a31515;">&#8216;checked&#8217;</span><font color="#000000">);</font></span></p>
<p style="margin:0 0 0 .5in;"><span style="font-family:'Courier New';font-size:10pt;"><font color="#000000">                </font><span style="color:blue;">if</span><font color="#000000"> (checked)</font></span></p>
<p style="margin:0 0 0 .5in;"><span style="font-family:'Courier New';font-size:10pt;"><font color="#000000">                    hit = </font><span style="color:blue;">true</span><font color="#000000">;</font></span></p>
<p style="margin:0 0 0 .5in;"><span style="font-family:'Courier New';font-size:10pt;"><font color="#000000">            });</font></span></p>
<p style="margin:0 0 0 .5in;"><span style="font-family:'Courier New';font-size:10pt;"><font color="#000000"> </font></span></p>
<p style="margin:0 0 0 .5in;"><span style="font-family:'Courier New';font-size:10pt;"><font color="#000000">            </font><span style="color:blue;">if</span><font color="#000000"> (hit == </font><span style="color:blue;">true</span><font color="#000000">) {</font></span></p>
<p style="margin:0 0 0 .5in;"><span style="font-family:'Courier New';font-size:10pt;"><font color="#000000">                button.show();</font></span></p>
<p style="margin:0 0 0 .5in;"><span style="font-family:'Courier New';font-size:10pt;"><font color="#000000">            } </font><span style="color:blue;">else</span><font color="#000000"> {</font></span></p>
<p style="margin:0 0 0 .5in;"><span style="font-family:'Courier New';font-size:10pt;"><font color="#000000">                button.hide();</font></span></p>
<p style="margin:0 0 0 .5in;"><span style="font-family:'Courier New';font-size:10pt;"><font color="#000000">            }</font></span></p>
<p style="margin:0 0 0 .5in;"><span style="font-family:'Courier New';font-size:10pt;"><font color="#000000">        });</font></span></p>
<p style="margin:0 0 0 .5in;"><span style="font-family:'Courier New';font-size:10pt;"><font color="#000000">    });</font></span></p>
<p style="margin:0 0 0 .5in;"><span style="font-family:'Courier New';font-size:10pt;"><font color="#000000">}<span style="color:blue;"></span></font></span></p>
<p style="margin:0;"><span style="font-family:'Courier New';color:blue;font-size:10pt;"> </span></p>
<p style="margin:0;"><span style="font-family:'Courier New';color:blue;font-size:10pt;"></</span><span style="font-family:'Courier New';color:#a31515;font-size:10pt;">script</span><span style="font-family:'Courier New';color:blue;font-size:10pt;">></span></p>
<p>  </p>
<p>Thats it.. With this approach we can pass any CheckListBox and any Button to this function and achieve a very fast pure client-side solution to control when and if the user can click the button.  The same basic approach can be used to target and wire other rendered WebForms controls.  Enjoy..</p>
</div>
