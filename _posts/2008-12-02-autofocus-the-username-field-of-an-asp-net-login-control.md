---
layout: post
title: "AutoFocus the UserName field of an ASP.NET Login Control"
date: 2008-12-02 12:00:34 -0600
categories: []
tags: []
wordpress_id: 21
original_url: "https://joelholder.com/2008/12/02/autofocus-the-username-field-of-an-asp-net-login-control/"
---
<div id="msgcns!3FC3980D58CF7EFB!232" class="bvMsg">
<div>
<p>Even if you&#8217;re not using a templated version of the Login Control, the builtin TextBox for username entry can be targeted like this:</p>
<p>protected void Page_Load(object sender, EventArgs e){ </p>
<p>           SetFocus(Login1.FindControl(&#8220;UserName&#8221;)); </p>
<p>} </p>
<p>SetFocus is in the Page class.</p>
<p>Easy joy..</p></div>
</div>
