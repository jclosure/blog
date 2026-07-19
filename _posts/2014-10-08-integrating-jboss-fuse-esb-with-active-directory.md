---
layout: post
title: "Integrating JBoss Fuse ESB with Active Directory"
date: 2014-10-08 23:08:27 -0500
categories: []
tags: []
wordpress_id: 836
original_url: "https://joelholder.com/2014/10/08/integrating-jboss-fuse-esb-with-active-directory/"
---

As of the time of this writing, I could not find a documented recipe for using [Active Directory](http://msdn.microsoft.com/en-us/library/aa746492(v=vs.85).aspx) as the authentication and authorization backend of [JBoss Fuse ESB](http://www.redhat.com/en/technologies/jboss-middleware/fuse). Here's a link to the official documentation on [Enabling LDAP Authentication](https://access.redhat.com/documentation/en-US/Red_Hat_JBoss_Fuse/6.1/html-single/Security_Guide/#ESBSecurityLDAPAuthentPlugin). It describes how to integrate with [Apache Directory Server](http://directory.apache.org/apacheds/), which has some key differences from [Microsoft Active Directory](http://technet.microsoft.com/en-us/library/bb742424.aspx).

The process to use Active Directory is actually rather simple, if you know what to do.

We will make these assumptions for this exercise:

- Domain Name: **fqdn.local**
- The OU where the esb's groups will be found is: **ou=users,dc=fqdn,dc=local** (The default location for groups in AD)

First lets create a new XML File to represent our OSGI Blueprint module.

## Step 1: Create file ldap-module.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<blueprint xmlns="http://www.osgi.org/xmlns/blueprint/v1.0.0"
           xmlns:cm="http://aries.apache.org/blueprint/xmlns/blueprint-cm/v1.1.0"
           xmlns:jaas="http://karaf.apache.org/xmlns/jaas/v1.0.0">

  <jaas:config name="karaf" rank="9">
    <jaas:module className="org.apache.karaf.jaas.modules.ldap.LDAPLoginModule"
                 flags="required">
      initialContextFactory = com.sun.jndi.ldap.LdapCtxFactory
      connection.username = my_service_account
      connection.password = *********
      connection.url = ldap://domaincontroller.fqdn.local:389
      user.filter = (samAccountName=%u)
      user.base.dn = dc=fqdn,dc=local
      user.search.subtree = true
      role.name.attribute = cn
      role.filter = (member=%dn,dc=fqdn,dc=local)
      role.base.dn = ou=users,dc=fqdn,dc=local
      role.search.subtree = true
      authentication = simple
      debug=true
    </jaas:module>
  </jaas:config>
</blueprint>
```

The above file defines a Jaas Module that creates an instance of the built in org.apache.karaf.jaas.modules.ldap.LDAPLoginModule. Its configuration is the key to successfully integrating with AD. We'll take a look at some of the properties now.

First the connection.username and connection.password are going to be your service account that the ESB will use to do the LDAP lookups. While not shown here I do recommend that you externalize and encrypt the configuration for these using the [Config Admin Service](https://access.redhat.com/documentation/en-US/Red_Hat_JBoss_Fuse/6.1/html/Getting_Started/files/Develop-Configure.html).

Next see that the user.filter property is set to use the samAccountName attribute to lookup users by username in AD. We set the user.base.dn to the top of our AD Forrest with the value dc=fqdn,dc=local. You can constrain which users are able to login by ANDing an additional LDAP predicate on to the user.filter that constrains the user to also be a member of some "ESB Users" group, etc.

Example:

```java
user.filter = (&
  (samAccountName=%u)(memberof=cn=ESB\ Users,cn=users,dc=fqdn,dc=local)
)
```

This takes care of authentication, but does not allow for authorization. This is where the role related attributes come in. We set the role.name.attribute to be the "cn" (Common Name). In Active Directory this corresponds to the actual group name.

Next note that we defined a role.filter. This is very important to get right. Our's specifies an LDAP query that finds groups to which the authenticated user belongs. See that in the query (member=%dn,dc=fqdn,dc=local), the member attribute must contain an entry for the user's fully qualified "dn" (Distinguished Name). Notice the variable in the member=%dn. Fuse will replace this variable with the relative dn of the user being authorized. See in my configuration that I add the remaining suffix part "dc=fqdn,dc=local" of the Full Distinguished Name. YOU MUST DO THIS OR THE FILTER WILL NOT WORK AT ALL. This allows JBoss Fuse to find the groups for AD a user.

Lastly, you should be aware that since we specified a role.base.dn of OU=USERS,dc=fqdn,dc=local, the groups used by the ESB must exist under OU=USERS or below.

## Step 2: Deploy file ldap-module.xml

You can deploy this file to AD Enable your instance of JBoss Fuse by simply copying this file to the $FUSE_HOME/deploy directory.

With that, you're rocking. You are now using Active Directory as the User backend of your ESB.

## Step 3: Adjust the karaf.admin.role in system.properties

One thing that you'll want to do at this point is be able to login to Karaf and the Management Web Console with AD Users. To enable this, just edit the file $FUSE_HOME/etc/system.properties and set the property karaf.admin.role to a group name in the AD.

Example:

```java
karaf.admin.role="ESB Administrators"
```

With a setup like this, only authorized users will be able to login to the management tools.

That's all there is to it.
