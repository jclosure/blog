---
layout: post
title: "Gource Recipe For Win32"
date: 2010-07-25 13:28:11 -0500
categories: []
tags: []
wordpress_id: 5
original_url: "https://joelholder.com/2010/07/25/gource-recipe-for-win32/"
---
<div id="msgcns!3FC3980D58CF7EFB!541" class="bvMsg">I think that a rendered historical view of a source controlled software project can be a key asset in understanding how a piece of software got to be what it is at any point in time.  This seems to me to be a missing first class asset from our general tooling.  <a href="http://code.google.com/p/gource/">Gource</a> provides this as a beautifully rendered video timeline of a software project’s birth and evolution over time.</p>
<p>Here I’ve provided a small sample showing John Resig’s initial commit activity in JQuery’s Git repository.</p>
<div style="display:inline;float:none;margin:0;padding:0;">
<div><span style="display:none;"> </span><span class="embed-youtube" style="text-align:center; display: block;"><iframe loading="lazy" class="youtube-player" width="640" height="360" src="https://www.youtube.com/embed/aKPQPXZYGlk?version=3&#038;rel=1&#038;showsearch=0&#038;showinfo=1&#038;iv_load_policy=1&#038;fs=1&#038;hl=en-US&#038;autohide=2&#038;wmode=transparent" allowfullscreen="true" style="border:0;" sandbox="allow-scripts allow-same-origin allow-popups allow-presentation allow-popups-to-escape-sandbox"></iframe></span> </div>
</div>
<p> </p>
<p>Most of the documentation and work with Gource appears to be targeted toward *nix.  To the end spreading this love a bit wider into the Windows community, I’ll now share with you my recipe for getting it working in Win32.</p>
<p>1. First you’ll need to get Git working in Windows.  For this I recommend downloading and installing the Full Official Version of MsysGit from its Google code page: <a title="http://code.google.com/p/msysgit/downloads/list" href="http://code.google.com/p/msysgit/downloads/list">http://code.google.com/p/msysgit/downloads/list</a>.  Make sure you install it with the “Git Bash Here” option (see the install options in the wizard).  Also, you should allow the installer to put Git into your PATH environment variable, so that its globally accessible from the command-line.  The default location of  git.exe in Win32 is “C:\Program Files\Git\bin”</p>
<p>2. Next you’ll need Gource.  You can get it from its Google code page: <a title="http://code.google.com/p/gource/" href="http://code.google.com/p/gource/">http://code.google.com/p/gource/</a>.  Download the binaries for Windows and place them into a directory at c:\gource.  Manually add this path to your PATH environment variable so that it too is globally accessible.</p>
<p>3. Now in order to save the video output of Gource, you’ll need a video capture program.  For this you can use the free <a href="http://ffmpeg.arrozcru.org/autobuilds/">ffmpeg</a>, althrough I was not able to get the ppm output working in Windows to pipe it into ffmpeg.  Thus, I opted for the shareware version of <a href="http://www.fraps.com/download.php">Fraps</a>: <a title="http://www.fraps.com/download.php" href="http://www.fraps.com/download.php">http://www.fraps.com/download.php</a>.  Fraps can be used to create a video of any window, including in our case the Gource output.  Also while I have not tried it myself, I suspect that Techsmith’s <a href="http://www.techsmith.com/camtasia.asp?gclid=CMCAscSmh6MCFRkcswodWnyyjA">Camtasia</a> and/or <a href="http://www.jingproject.com/?gclid=CIiGqNCmh6MCFYxU2godiXeBeA">Jing</a> might do the trick nicely also.</p>
<p>4. Next its time to get some source and make a vid.  You can get the source of a Git project by cloning its repository to your local system.</p>
<ul>
<li>Create a local folder called c:\src
<li>In Windows Explorer right mouseclick and choose “Git Bash Here”.  Follow the instructions here: <a title="http://kylecordes.com/2008/git-windows-go" href="http://kylecordes.com/2008/git-windows-go">http://kylecordes.com/2008/git-windows-go</a> to get your Git account and public key setup. 
<li>Clone JQuery’s Git repository by typing into your Bash command prompt the following: <font color="#000000">git clone </font><a title="http://github.com/jquery/jquery.git" href="http://github.com/jquery/jquery.git"><font color="#000000">http://github.com/jquery/jquery.git</font></a>.  Now you’ll have a new folder at c:\src\jquery with the jquery project’s src.
<li>Now to create a video of the project history do the following:
<ul>
<li>Start up Fraps and minimize it to your system tray.
<li>open up a new cmd window and type the following command: <font color="#000000">c:\gource\gource &#8211;stop-at-end  c:\src\jquery</font>.  This will start Gource from the beginning of the project’s historical timeline.  You’ll the see the video begin at this point.
<li>Finally, with the Gource video window focussed, hit F9 which is Fraps’ default video capture key to get it to begin to capture the Gource output.
<li>After Gource finishes, Fraps will save the video to its default video location, which is c:\Fraps\Videos.</li>
</li>
</li>
</ul>
</li>
</li>
</li>
</ul>
<p>Tada!…  Pretty nifty tools.  Gource works with Git, Mercurial, and SVN to date.  I’ve seen a few ppl out there claiming to have it working with TFS also. </p>
<p>See what kind of fun you can have with it..  Go forth and be fruitful..</p>
</div>
