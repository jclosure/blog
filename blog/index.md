---
layout: default
title: Blog
permalink: /blog/
---

<section class="archive-head">
  <p class="eyebrow">Loose Leaf Experiments</p>
  <h1>Blog</h1>
  <p>Notes, builds, experiments, and older archive posts brought forward from WordPress.</p>
</section>

<ol class="archive-list">
{% for post in site.posts %}
  <li>
    <time datetime="{{ post.date | date_to_xmlschema }}">{{ post.date | date: "%Y.%m.%d" }}</time>
    <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
  </li>
{% endfor %}
</ol>
