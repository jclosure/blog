---
layout: default
title: Home
---

Welcome. This site is powered by GitHub Pages + Jekyll + Markdown.

## Posts

<ul>
  {% for post in site.posts %}
    <li>
      <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
      <small>({{ post.date | date: "%b %-d, %Y" }})</small>
    </li>
  {% endfor %}
</ul>
