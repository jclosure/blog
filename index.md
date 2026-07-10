---
layout: default
title: Joel Holder
---

<section class="site-hero">
  <div class="hero-media"></div>
  <div class="hero-copy">
    <p class="eyebrow">Loose Leaf Experiments</p>
    <h1>Joel Holder</h1>
    <p class="lede">Ideas, philosophical probes, and working implementations from the edge between software, systems, and strange little machines.</p>
    <div class="hero-actions" aria-label="Primary sections">
      <a class="button-link primary" href="{{ '/archive/' | relative_url }}">Read the blog</a>
      <a class="button-link" href="{{ '/projects/' | relative_url }}">See projects</a>
    </div>
  </div>
</section>

<section class="section-band">
  <div class="section-heading">
    <p class="eyebrow">Recent writing</p>
    <h2>Fresh Leaves</h2>
  </div>

  <ol class="post-river">
  {% for post in site.posts %}
    {% if forloop.index <= 5 %}
    <li>
      <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
      <time datetime="{{ post.date | date_to_xmlschema }}">{{ post.date | date: "%b %-d, %Y" }}</time>
    </li>
    {% endif %}
  {% endfor %}
  </ol>

  <p><a href="{{ '/archive/' | relative_url }}">Browse the archive</a></p>
</section>

<section class="feature-grid" aria-label="Site sections">
  <a class="feature-card" href="{{ '/archive/' | relative_url }}">
    <span class="feature-kicker">Writing</span>
    <strong>Blog</strong>
    <span>Technical notes, philosophy, experiments, and recovered posts from the old archive.</span>
  </a>
  <a class="feature-card" href="{{ '/projects/' | relative_url }}">
    <span class="feature-kicker">Builds</span>
    <strong>Projects</strong>
    <span>Automata Arcade, Evo Lumen Life, and other working sketches.</span>
  </a>
  <a class="feature-card" href="{{ '/about/' | relative_url }}">
    <span class="feature-kicker">Context</span>
    <strong>About</strong>
    <span>A small map of what this site is for and where the experiments point.</span>
  </a>
</section>
