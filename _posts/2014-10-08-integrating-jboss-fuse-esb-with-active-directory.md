---
layout: post
title: "Integrating JBoss Fuse ESB with Active Directory"
date: 2014-10-08 23:08:27 -0500
categories: []
tags: []
wordpress_id: 836
original_url: "https://joelholder.com/2014/10/08/integrating-jboss-fuse-esb-with-active-directory/"
---
<style>
.postid-836 .entry-content pre,
.postid-836 .entry-content code {
  white-space: pre-wrap;
  overflow-wrap: anywhere;
  word-break: break-word;
}
.postid-836 .entry-content table,
.postid-836 .entry-content img,
.postid-836 .entry-content iframe {
  max-width: 100%;
}
.postid-836 .entry-content {
  overflow-wrap: anywhere;
}
</style>



<p class="wp-block-paragraph">As of the time of this writing, I could not find a documented recipe for using <a href="http://msdn.microsoft.com/en-us/library/aa746492(v=vs.85).aspx">Active Directory</a> as the authentication and authorization backend of <a href="http://www.redhat.com/en/technologies/jboss-middleware/fuse">JBoss Fuse ESB</a>. &nbsp;Here&#8217;s a link to the official documentation on <a href="https://access.redhat.com/documentation/en-US/Red_Hat_JBoss_Fuse/6.1/html-single/Security_Guide/#ESBSecurityLDAPAuthentPlugin">Enabling LDAP Authentication</a>. It describes how to integrate with <a href="http://directory.apache.org/apacheds/">Apache Directory Server</a>, which has some key differences from <a href="http://technet.microsoft.com/en-us/library/bb742424.aspx">Microsoft Active Directory</a>.</p>



<p class="wp-block-paragraph">The process to use Active Directory is actually rather simple, if you know what to do.</p>



<p class="wp-block-paragraph">We will make these assumptions for this excersise:</p>



<ul class="wp-block-list">
<li>Domain Name: <strong>fqdn.local</strong></li>



<li>The OU where the esb&#8217;s groups will be found is: <strong>ou=users,dc=fqdn,dc=local</strong> (The default location for groups in AD)</li>
</ul>



<p class="wp-block-paragraph">First lets create a new XML File to represent our OSGI Blueprint module.</p>



<h2 class="wp-block-heading">Step 1: Create file ldap-module.xml</h2>


<div class="wp-block-code">
	<div class="cm-editor">
		<div class="cm-scroller">
			
<pre>
<code class="language-xml"><div class="cm-line"><span class="tok-meta">&lt;?xml version=&quot;1.0&quot; encoding=&quot;UTF-8&quot;?&gt;</span></div><div class="cm-line"><span class="tok-punctuation">&lt;</span><span class="tok-typeName">blueprint</span> <span class="tok-propertyName">xmlns</span><span class="tok-operator">=</span><span class="tok-string">&quot;http://www.osgi.org/xmlns/blueprint/v1.0.0&quot;</span></div><div class="cm-line">           <span class="tok-propertyName">xmlns:cm</span><span class="tok-operator">=</span><span class="tok-string">&quot;http://aries.apache.org/blueprint/xmlns/blueprint-cm/v1.1.0&quot;</span></div><div class="cm-line">           <span class="tok-propertyName">xmlns:jaas</span><span class="tok-operator">=</span><span class="tok-string">&quot;http://karaf.apache.org/xmlns/jaas/v1.0.0&quot;</span><span class="tok-punctuation">&gt;</span></div><div class="cm-line"></div><div class="cm-line">  <span class="tok-punctuation">&lt;</span><span class="tok-typeName">jaas:config</span> <span class="tok-propertyName">name</span><span class="tok-operator">=</span><span class="tok-string">&quot;karaf&quot;</span> <span class="tok-propertyName">rank</span><span class="tok-operator">=</span><span class="tok-string">&quot;9&quot;</span><span class="tok-punctuation">&gt;</span></div><div class="cm-line">    <span class="tok-punctuation">&lt;</span><span class="tok-typeName">jaas:module</span> <span class="tok-propertyName">className</span><span class="tok-operator">=</span><span class="tok-string">&quot;org.apache.karaf.jaas.modules.ldap.LDAPLoginModule&quot;</span></div><div class="cm-line">                 <span class="tok-propertyName">flags</span><span class="tok-operator">=</span><span class="tok-string">&quot;required&quot;</span><span class="tok-punctuation">&gt;</span></div><div class="cm-line">      initialContextFactory = com.sun.jndi.ldap.LdapCtxFactory</div><div class="cm-line">      connection.username = my_service_account</div><div class="cm-line">      connection.password = *********</div><div class="cm-line">      connection.url = ldap://domaincontroller.fqdn.local:389</div><div class="cm-line">      user.filter = (samAccountName=%u)</div><div class="cm-line">      user.base.dn = dc=fqdn,dc=local</div><div class="cm-line">      user.search.subtree = true</div><div class="cm-line">      role.name.attribute = cn</div><div class="cm-line">      role.filter = (member=%dn,dc=fqdn,dc=local)</div><div class="cm-line">      role.base.dn = ou=users,dc=fqdn,dc=local</div><div class="cm-line">      role.search.subtree = true</div><div class="cm-line">      authentication = simple</div><div class="cm-line">      debug=true</div><div class="cm-line">    <span class="tok-punctuation">&lt;/</span><span class="tok-typeName">jaas:module</span><span class="tok-punctuation">&gt;</span></div><div class="cm-line">  <span class="tok-punctuation">&lt;/</span><span class="tok-typeName">jaas:config</span><span class="tok-punctuation">&gt;</span></div><div class="cm-line"><span class="tok-punctuation">&lt;/</span><span class="tok-typeName">blueprint</span><span class="tok-punctuation">&gt;</span></div></code></pre>
		</div>
	</div>
</div>


<p class="wp-block-paragraph">The above file defines a Jaas Module that creates an instance of the built in org.apache.karaf.jaas.modules.ldap.LDAPLoginModule. Its configuration is the key to successfully integrating with AD. We&#8217;ll take a look at some of the properties now.</p>



<p class="wp-block-paragraph">First the connection.username and connection.password are going to be your service account that the ESB will use to do the LDAP lookups. While not shown here I do recommend that you externalize and encrypt the configuration for these using the <a href="https://access.redhat.com/documentation/en-US/Red_Hat_JBoss_Fuse/6.1/html/Getting_Started/files/Develop-Configure.html">Config Admin Service</a>.</p>



<p class="wp-block-paragraph">Next see that the user.filter property is set to use the samAccountName attribute to lookup users by username in AD. We set the user.base.dn to the top of our AD Forrest with the value dc=fqdn,dc=local. You can constrain which users are able to login by ANDing an additional LDAP predicate on to the user.filter that constrains the user to also be a member of some &#8220;ESB Users&#8221; group, etc.</p>



<p class="wp-block-paragraph">Example:</p>


<div class="wp-block-code">
	<div class="cm-editor">
		<div class="cm-scroller">
			
<pre>
<code><div class="cm-line">user.filter = (&amp; </div><div class="cm-line">  (samAccountName=%u)(memberof=cn=ESB\ Users,cn=users,dc=fqdn,dc=local)</div><div class="cm-line">)</div></code></pre>
		</div>
	</div>
</div>


<p class="wp-block-paragraph">This takes care of authentication, but does not allow for authorization. This is where the role related attributes come in. We set the role.name.attribute to be the &#8220;cn&#8221; (Common Name). In Active Directory this corresponds to the actual group name.</p>



<p class="wp-block-paragraph">Next note that we defined a role.filter. This is very important to get right. Our&#8217;s specifies an LDAP query that finds groups to which the authenticated user belongs. See that in the query (member=%dn,dc=fqdn,dc=local), the member attribute must contain an entry for the user&#8217;s fully qualified &#8220;dn&#8221; (Distinguished Name). Notice the variable in the member=%dn. Fuse will replace this variable with the relative dn of the user being authorized. See in my configuration that I add the remaining suffix part &#8220;dc=fqdn,dc=local&#8221; of the Full Distinguished Name. YOU MUST DO THIS OR THE FILTER WILL NOT WORK AT ALL. This allows JBoss Fuse to find the groups for AD a user.</p>



<p class="wp-block-paragraph">Lastly, you should be aware that since we specified a role.base.dn of OU=USERS,dc=fqdn,dc=local, the groups used by the ESB must exist under OU=USERS or below.</p>



<h2 class="wp-block-heading">Step 2: Deploy file ldap-module.xml</h2>



<p class="wp-block-paragraph">You can deploy this file to AD Enable your instance of JBoss Fuse by simply copying this file to the $FUSE_HOME/deploy directory.</p>



<p class="wp-block-paragraph">With that, you&#8217;re rocking. You are now using Active Directory as the User backend of your ESB.</p>



<h2 class="wp-block-heading">Step 3: Adjust the karaf.admin.role in system.properties</h2>



<p class="wp-block-paragraph">One thing that you&#8217;ll want to do at this point is be able to login to Karaf and the Management Web Console with AD Users. To enable this, just edit the file $FUSE_HOME/etc/system.properties and set the property karaf.admin.role to a group name in the AD.</p>



<p class="wp-block-paragraph">Example:</p>


<div class="wp-block-code">
	<div class="cm-editor">
		<div class="cm-scroller">
			
<pre>
<code><div class="cm-line">karaf.admin.role=&quot;ESB Administrators&quot;</div></code></pre>
		</div>
	</div>
</div>


<p class="wp-block-paragraph">With a setup like this, only authorized users will be able to login to the management tools.</p>



<p class="wp-block-paragraph">That&#8217;s all there is to it.</p>
