---
layout: default
title: Loose Leaf
permalink: /blog/
---

<section class="site-hero blog-hero">
  <div class="hero-media"><canvas id="hero-leaves" aria-hidden="true"></canvas></div>
  <div class="hero-copy">
    <hr/>

    <div class="hero-statement">
      <h1>Loose Leaf</h1>
      <p class="lede">Pages that came unbound from the notebook: old code hacks dug back up, proofs that got out of hand, and small artificial worlds built just to see what they'd do.</p>
      <div class="hero-focus" aria-label="What's inside">
        <span>Code</span>
        <span>Proofs</span>
        <span>Living systems</span>
        <span>Digressions</span>
      </div>
    </div>

    <div class="hero-bottom">
      <div class="hero-actions" aria-label="Start reading">
        <a class="button-link primary" href="{{ site.posts.first.url | relative_url }}">Read the latest</a>
        <a class="button-link" href="{{ '/' | relative_url }}">Back to the lab</a>
      </div>
    </div>
  </div>
</section>

<p class="eyebrow archive-eyebrow">All posts, newest first</p>

<ol class="archive-list">
{% for post in site.posts %}
  <li>
    <time datetime="{{ post.date | date_to_xmlschema }}">{{ post.date | date: "%Y.%m.%d" }}</time>
    <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
  </li>
{% endfor %}
</ol>
