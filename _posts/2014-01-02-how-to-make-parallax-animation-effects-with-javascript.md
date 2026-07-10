---
layout: post
title: "Making Parallax Animation Effects With JavaScript"
date: 2014-01-02 19:39:57 -0600
categories: []
tags: ["Animation", "Canvas", "HTML5", "JavaScript"]
wordpress_id: 422
original_url: "https://joelholder.com/2014/01/02/how-to-make-parallax-animation-effects-with-javascript/"
---
<p>The Term &#8220;<a title="Parallax" href="http://en.wikipedia.org/wiki/Parallax" target="_blank">Parallax</a>&#8221; means a  difference in the apparent position of an object viewed along two different lines of sight, and is measured by the angle of inclination between those two lines.  The positional difference between objects creates a visual illusion that is specific to the position of the observer.  A simple everyday example of parallax can be seen in the dashboard of motor vehicles that use a needle-style speedometer gauge.  When viewed from directly in front, the speed may show exactly 60; but when viewed from the passenger seat the needle may appear to show a slightly different speed, due to the angle of viewing.  This effect can be exploited when presenting content to trick the eyes into seeing multiple forced perspectives in the same scene.  When animated, the effects become visually interesting to people. Recently, I began a series of experiments to learn how parallax works.  In this article, I&#8217;ll walk you through the basics and leave you with a working example of a parallax web banner.  The code in this writeup, is available <a title="Joel Holder's Blog" href="https://github.com/jclosure/beautiful_world" target="_blank">here</a>.</p>
<p></p>
<p>First, let&#8217;s layout what we want to accomplish.</p>
<ul>
<li>Mountains (far texture) &#8211; We want to build a scene that uses a scrolling landscape to provide the feeling of panning or having it spin around you.  (Note that I&#8217;ve modified this image to seamlessly scroll.  Here&#8217;s the technique <a title="ref" href="http://demosthenes.info/blog/264/Five-Steps-To-Making-A-Seamless-Tiled-Image-in-PhotoShop-For-Use-In-CSS-Backgrounds" target="_blank">ref</a>.)</li>
<li>Sun (back texture) &#8211; We want to have a sun fixed in the sky in a position similar to the direction that the light in the landscape is coming from.</li>
<li>Cloud (mid texture) &#8211; We want to have clouds moving across our sky.</li>
<li>Girl (close texture) &#8211; We want a central figure of a person (our girl) at the front to hold our users&#8217; attention and give the illusion that she&#8217;s in the scene.</li>
</ul>
<p>Preview Results:</p>
<p><figure id="attachment_430" aria-describedby="caption-attachment-430" style="width: 652px" class="wp-caption aligncenter"><a href="/assets/wp/how-to-make-parallax-animation-effects-with-javascript/screenshot.png"><img data-recalc-dims="1" loading="lazy" decoding="async" data-attachment-id="430" data-permalink="https://joelholder.com/2014/01/02/how-to-make-parallax-animation-effects-with-javascript/screenshot/" data-orig-file="https://i0.wp.com/joelholder.com/wp-content/uploads/2014/01/screenshot.png?fit=1017%2C505&amp;ssl=1" data-orig-size="1017,505" data-comments-opened="1" data-image-meta="{&quot;aperture&quot;:&quot;0&quot;,&quot;credit&quot;:&quot;&quot;,&quot;camera&quot;:&quot;&quot;,&quot;caption&quot;:&quot;&quot;,&quot;created_timestamp&quot;:&quot;0&quot;,&quot;copyright&quot;:&quot;&quot;,&quot;focal_length&quot;:&quot;0&quot;,&quot;iso&quot;:&quot;0&quot;,&quot;shutter_speed&quot;:&quot;0&quot;,&quot;title&quot;:&quot;&quot;}" data-image-title="screenshot" data-image-description="" data-image-caption="&lt;p&gt;Screenshot&lt;/p&gt;
" data-large-file="https://i0.wp.com/joelholder.com/wp-content/uploads/2014/01/screenshot.png?fit=1017%2C505&amp;ssl=1" src="/assets/wp/how-to-make-parallax-animation-effects-with-javascript/screenshot-2.png" alt="Parallax In Action Screenshot" width="652" height="323" class="size-large wp-image-430" /></a><figcaption id="caption-attachment-430" class="wp-caption-text">Screenshot</figcaption></figure></p>
<p>We&#8217;ll begin with these 4 images.  Each is considered a texture that will be layered onto our stage, which in this case will be an HTML5 Canvas. With these images in our project, we can now write the code to bring them together and animate the scene.</p>
<p><figure id="attachment_426" aria-describedby="caption-attachment-426" style="width: 559px" class="wp-caption aligncenter"><a href="/assets/wp/how-to-make-parallax-animation-effects-with-javascript/textures1.png"><img data-recalc-dims="1" loading="lazy" decoding="async" data-attachment-id="426" data-permalink="https://joelholder.com/2014/01/02/how-to-make-parallax-animation-effects-with-javascript/textures-2/" data-orig-file="https://i0.wp.com/joelholder.com/wp-content/uploads/2014/01/textures1.png?fit=559%2C437&amp;ssl=1" data-orig-size="559,437" data-comments-opened="1" data-image-meta="{&quot;aperture&quot;:&quot;0&quot;,&quot;credit&quot;:&quot;&quot;,&quot;camera&quot;:&quot;&quot;,&quot;caption&quot;:&quot;&quot;,&quot;created_timestamp&quot;:&quot;0&quot;,&quot;copyright&quot;:&quot;&quot;,&quot;focal_length&quot;:&quot;0&quot;,&quot;iso&quot;:&quot;0&quot;,&quot;shutter_speed&quot;:&quot;0&quot;,&quot;title&quot;:&quot;&quot;}" data-image-title="textures" data-image-description="" data-image-caption="&lt;p&gt;Textures Images To Be Used As Sprites&lt;/p&gt;
" data-large-file="https://i0.wp.com/joelholder.com/wp-content/uploads/2014/01/textures1.png?fit=559%2C437&amp;ssl=1" src="/assets/wp/how-to-make-parallax-animation-effects-with-javascript/textures1-2.png" alt="Textures" width="559" height="437" class="size-full wp-image-426" /></a><figcaption id="caption-attachment-426" class="wp-caption-text">Texture Images To Be Used As Sprites</figcaption></figure></p>
<p>First, we&#8217;ll make our markup. This is a minimal HTML file, with only a canvas element that will serve as our rendering stage for the scene.</p>

~~~ xml
<html>
  <head>
    <link rel='stylesheet' type='text/css' href='https://cdnjs.cloudflare.com/ajax/libs/meyer-reset/2.0/reset.min.css' />
    <link rel='stylesheet' type='text/css' href='style.css' />
  </head>
  <body onload="init();">
      <script src="pixi.js"></script>
    <script src="http://code.jquery.com/jquery-1.10.2.min.js"></script>
      <script src="http://cdnjs.cloudflare.com/ajax/libs/underscore.js/1.4.4/underscore-min.js"></script>

    <script type='text/javascript' src='script.js'></script>

    <div id=container; align="center">
      <p id="caption">
        Its A Beautiful World
      </p>
      <canvas id="game-canvas" width="1024" height="512"></canvas>
    </div>
  </body>
</html>
~~~

<p>Next, we&#8217;ll write the JavaScript to bring it to life.</p>
<p>function init(){</p>
<p>  var WIDTH = 1024;<br />
  var HEIGHT = 512;<br />
  var stage = new PIXI.Stage();</p>
<p>  // let pixi choose WebGL or canvas<br />
  var renderer;<br />
  var back, far, mid, close;</p>
<p>  // target render to something on dom<br />
  renderer = PIXI.autoDetectRenderer(WIDTH, HEIGHT, document.getElementById(&#8220;game-canvas&#8221;));</p>
<p>  //sun texture<br />
  var backTexture = PIXI.Texture.fromImage(&#8220;sun1.gif&#8221;);<br />
  back = new PIXI.Sprite(backTexture, WIDTH, HEIGHT);<br />
  back.position.x = 20;<br />
  back.position.y = 7;</p>
<p>  //mountain texture<br />
  var farTexture = PIXI.Texture.fromImage(&#8220;mountain-04.jpg&#8221;);<br />
  far = new PIXI.TilingSprite(farTexture, WIDTH, HEIGHT);<br />
  far.position.x = 0;<br />
  far.position.y = 0;<br />
  far.tilePosition.x = 0;<br />
  far.tilePosition.y = 0;</p>
<p>  //cloud texture<br />
  var midTexture = PIXI.Texture.fromImage(&#8220;cloud1.gif&#8221;);<br />
  mid = new PIXI.Sprite(midTexture, WIDTH, HEIGHT);<br />
  mid.position.x = WIDTH &#8211; 40;<br />
  mid.position.y = -10;</p>
<p>  //girl texture<br />
  var closeTexture = PIXI.Texture.fromImage(&#8220;girl_character.gif&#8221;);<br />
  close = new PIXI.Sprite(closeTexture, WIDTH, HEIGHT);<br />
  close.position.x = 512 &#8211; 256;<br />
  close.position.y = 15;</p>
<p>  //add textures to stage in order from back to front<br />
  stage.addChild(far);<br />
  stage.addChild(back);<br />
  stage.addChild(mid);<br />
  stage.addChild(close);</p>
<p>  //render stage<br />
  renderer.render(stage);</p>
<p>  //start animation loop<br />
  requestAnimFrame(update);</p>
<p>  //recursive animation looper<br />
  function update() {</p>
<p>    //move the far sprite to the left slowly<br />
    far.tilePosition.x -= 0.128;</p>
<p>    //move the mid sprite to the left a little faster<br />
    mid.position.x -= 0.37;<br />
    if (mid.position.x < 0 - 512)
      mid.position.x = WIDTH + 512;

    renderer.render(stage);

    requestAnimFrame(update);
  }
}
[/sourcecode]

Note that I've commented each stanza in this script to help you understand what's happening.  The code flow is generally this:



<ol>
<li>
     Set dimensions for the stage (HEIGHT/WIDTH variables)
   </li>
<li>
     Instantiate the stage.
   </li>
<li>
     Instantiate a renderer targeted to the canvas element in the DOM
   </li>
<li>
     Create sprites for the textures.  Note that the far texture is a TilingSprite, so it&#8217;s position is manipulated by using the tilePosition attribute instead of the position attribute like the regular sprites.
   </li>
<li>
     Place the stage into the renderer.
   </li>
<li>
     Then finally, we start the animation loop by feeding the recursive update callback to the requestAnimFrame function given to us by PIXI.  A more thorough look at the update function is required:</p>
<ol>
<li>
        Since we want the far texture to scroll to the left slowly, we decrement by .128px its position on the x axis each time the update function is called.
      </li>
<li>
        Since we want the mid texture to scroll to the left more quickly, we decrement by .37px (a larger number) its position on the x axis each time the update function is called.
      </li>
</ol>
</li>
</ol>
<p>When brought together, the effects can be visually interesting.  I say interesting, because the effect can be pleasant or disorienting depending upon how you&#8217;ve positioned the sprites and how quickly they are moving.  The basic approach that I&#8217;m showing here can be used as the foundation for side-scrolling video games.  There are also many potential uses for Web Banners, Presentations, Data Visualization, Rich User Interfaces, and more.</p>
<p>Result:</p>
<p><span class="embed-youtube" style="text-align:center; display: block;"><iframe loading="lazy" class="youtube-player" width="640" height="360" src="https://www.youtube.com/embed/Q_uWJSxUka4?version=3&#038;rel=1&#038;showsearch=0&#038;showinfo=1&#038;iv_load_policy=1&#038;fs=1&#038;hl=en-US&#038;autohide=2&#038;wmode=transparent" allowfullscreen="true" style="border:0;" sandbox="allow-scripts allow-same-origin allow-popups allow-presentation allow-popups-to-escape-sandbox"></iframe></span></p>
<p>Hopefully you find this useful, or if nothing else instructive.  You can get my code <a title="Joel Holder's Blog" href="https://github.com/jclosure/beautiful_world" target="_blank">here</a></p>
<p>Namaste..</p>
