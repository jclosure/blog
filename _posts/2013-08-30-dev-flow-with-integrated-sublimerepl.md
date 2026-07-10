---
layout: post
title: "Dev flow with integrated SublimeREPL"
date: 2013-08-30 18:12:09 -0500
categories: []
tags: ["Python", "REPL", "Sublime Text 2", "SublimeREPL"]
wordpress_id: 386
original_url: "https://joelholder.com/2013/08/30/dev-flow-with-integrated-sublimerepl/"
---
<p>Here is a short screencast that I made to demonstrate what I believe are some of the more useful features and techniques of working in Sublime Text 2 and the python repl.  Specifically, I wanted to show others who might need the dots connected to understand just what the intended usage flow of <a title="SublimeREPL" href="http://github.com/wuub/SublimeREPL" target="_blank">SublimeRepl</a> is.</p>
<p>The following is covered:</p>
<ul>
<li>Where to find your Sublime Text 2 keymap file.
<ul>
<li>How to add a keymapping</li>
<li>I&#8217;ll post my example below</li>
</ul>
</li>
<li>Use the REPL to work with objects loaded from the open file buffer.</li>
<li>Use the built-in key mappings for transferring current file to the REPL.</li>
</ul>
<p><span class="embed-youtube" style="text-align:center; display: block;"><iframe loading="lazy" class="youtube-player" width="640" height="480" src="https://www.youtube.com/embed/ONti1X_8IKI?version=3&#038;rel=1&#038;showsearch=0&#038;showinfo=1&#038;iv_load_policy=1&#038;fs=1&#038;hl=en-US&#038;autohide=2&#038;wmode=transparent" allowfullscreen="true" style="border:0;" sandbox="allow-scripts allow-same-origin allow-popups allow-presentation allow-popups-to-escape-sandbox"></iframe></span></p>
<p>KEYMAPPING CODE</p>
<pre class="brush: jscript; title: ; notranslate" title="">
{ &quot;keys&quot;: &#x5B;&quot;f8&quot;],
  &quot;command&quot;: &quot;repl_open&quot;,
  &quot;caption&quot;: &quot;Python&quot;,
  &quot;mnemonic&quot;: &quot;p&quot;,
  &quot;args&quot;: {
              &quot;type&quot;: &quot;subprocess&quot;,
              &quot;encoding&quot;: &quot;utf8&quot;,
              &quot;cmd&quot;: &#x5B;&quot;python&quot;, &quot;-i&quot;, &quot;-u&quot;, &quot;$file&quot;],
              &quot;cwd&quot;: &quot;$file_path&quot;,
              &quot;syntax&quot;: &quot;Packages/Python/Python.tmLanguage&quot;,
              &quot;external_id&quot;: &quot;python&quot;
           }
}
</pre>
<p><figure id="attachment_387" aria-describedby="caption-attachment-387" style="width: 652px" class="wp-caption alignnone"><a href="/blog/assets/wp/dev-flow-with-integrated-sublimerepl/desktop-1_004.png"><img data-recalc-dims="1" loading="lazy" decoding="async" data-attachment-id="387" data-permalink="https://joelholder.com/2013/08/30/dev-flow-with-integrated-sublimerepl/desktop-1_004/" data-orig-file="https://i0.wp.com/joelholder.com/wp-content/uploads/2013/08/desktop-1_004.png?fit=1024%2C768&amp;ssl=1" data-orig-size="1024,768" data-comments-opened="1" data-image-meta="{&quot;aperture&quot;:&quot;0&quot;,&quot;credit&quot;:&quot;&quot;,&quot;camera&quot;:&quot;&quot;,&quot;caption&quot;:&quot;&quot;,&quot;created_timestamp&quot;:&quot;0&quot;,&quot;copyright&quot;:&quot;&quot;,&quot;focal_length&quot;:&quot;0&quot;,&quot;iso&quot;:&quot;0&quot;,&quot;shutter_speed&quot;:&quot;0&quot;,&quot;title&quot;:&quot;&quot;}" data-image-title="desktop 1_004" data-image-description="" data-image-caption="&lt;p&gt;debugging in two row layout&lt;/p&gt;
" data-large-file="https://i0.wp.com/joelholder.com/wp-content/uploads/2013/08/desktop-1_004.png?fit=1024%2C768&amp;ssl=1" class="size-full wp-image-387" src="/blog/assets/wp/dev-flow-with-integrated-sublimerepl/desktop-1_004-2.png" alt="debugging in two row layout" width="652" height="489" /></a><figcaption id="caption-attachment-387" class="wp-caption-text">debugging in two row layout</figcaption></figure></p>
<p>Namaste&#8230;</p>
