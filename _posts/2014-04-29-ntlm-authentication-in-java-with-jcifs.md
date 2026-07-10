---
layout: post
title: "NTLM Authentication in Java with JCifs"
date: 2014-04-29 21:47:06 -0500
categories: []
tags: ["cifs", "java", "ntlm"]
wordpress_id: 580
original_url: "https://joelholder.com/2014/04/29/ntlm-authentication-in-java-with-jcifs/"
---
<p>In enterprise software development contexts, one of the frequent needs we encounter is working with FileSystems remotely via <a title="CIFS" href="http://technet.microsoft.com/en-us/library/cc939973.aspx" target="_blank">CIFS</a>, sometimes referred to as <a title="SMB" href="http://en.wikipedia.org/wiki/Server_Message_Block" target="_blank">SMB</a>.  If you are using Java in these cases, you&#8217;ll want <a href="http://jcifs.samba.org/" title="JCifs" target="_blank">JCifs</a>, a pure Java CIFS implementation.  In this post, I&#8217;ll show you how to remotely connect to a Windows share on an Active Directory domain and read/write a file.</p>
<p>In your pom.xml place this dependency:</p>
<pre class="brush: xml; title: ; notranslate" title="">
&lt;dependency&gt;
    &lt;groupId&gt;jcifs&lt;/groupId&gt;
    &lt;artifactId&gt;jcifs&lt;/artifactId&gt;
    &lt;version&gt;1.3.17&lt;/version&gt;
&lt;/dependency&gt;
</pre>
<p>Here is a simple class with a main, you can run to see how it works:</p>
<pre class="brush: java; title: ; notranslate" title="">
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.MalformedURLException;
import java.net.UnknownHostException;
import java.util.logging.Level;
import java.util.logging.Logger;

import jcifs.UniAddress;
import jcifs.smb.NtlmPasswordAuthentication;
import jcifs.smb.SmbException;
import jcifs.smb.SmbFile;
import jcifs.smb.SmbFileInputStream;
import jcifs.smb.SmbFileOutputStream;
import jcifs.smb.SmbSession;

public class Program {

	public static void main(String&#x5B;] args) throws SmbException, UnknownHostException, Exception {
	    
        final UniAddress domainController = UniAddress.getByName(&quot;DOMAINCONTROLLERHOSTNAME&quot;);
		 
	    final NtlmPasswordAuthentication credentials = new NtlmPasswordAuthentication(&quot;DOMAIN.LOCAL&quot;, &quot;USERNAME&quot;, &quot;SECRET&quot;);
	 
	    SmbSession.logon(domainController, credentials);
	    
	    SmbFile smbFile = new SmbFile(&quot;smb://localhost/share/foo.txt&quot;, credentials);
	    
	    //write to file
	    new SmbFileOutputStream(smbFile).write(&quot;testing....and writing to a file&quot;.getBytes());
	    
	    //read from file
	    String contents = readFileContents(smbFile);
	    
	    System.out.println(contents);

	}

	private static String readFileContents(SmbFile sFile) throws IOException {

		BufferedReader reader = reader = new BufferedReader(
				new InputStreamReader(new SmbFileInputStream(sFile)));

		StringBuilder builder = new StringBuilder();
		
		String lineReader = null;
		while ((lineReader = reader.readLine()) != null) {
			builder.append(lineReader).append(&quot;\n&quot;);
		}
		return builder.toString();
	}

}
</pre>
<p>As you can see its quite trivial to reach out across your network and interact with Files and Directories in Windows/Samba Shares.  Being able to authenticate via NTLM is convenient and tidy for this purpose, not to mention the FileSystem API is straight forward and powerful.</p>
<p>Enjoy the power..</p>
