---
layout: default
title: Joel Holder
---

<section class="site-hero">
  <div class="hero-media"><canvas id="hero-geometry" aria-hidden="true"></canvas></div>
  <div class="hero-copy">
    <hr/>

    <div class="hero-statement">
      <h1>Joel Holder</h1>
      <p class="lede">Recreational Learning & Discovery</p>
      <div class="hero-focus" aria-label="Areas of focus">
        <!-- <span>Geometry</span>
        <span>Math</span>
        <span>Artificial Intelligence</span> -->
      </div>
    </div>


    <div class="hero-bottom">
      <div class="hero-actions" aria-label="Primary sections">
        <a class="button-link primary" href="{{ '/blog/' | relative_url }}">Read the blog</a>
        <a class="button-link" href="{{ '/projects/' | relative_url }}">See projects</a>
      </div>
    </div>
  </div>
</section>

<section class="intro-band">
  <p class="intro-lede">This site is a rolling subset of my momentary interests. Here you'll find exploratory writing and ideas turned into software, simulations, and small instruments for thinking.</p>
  <div class="intro-note">
    <span class="feature-kicker">What am I doing?</span>
    <strong>Learning in public, building for fun, and keeping the lab door open.</strong>
  </div>
</section>

<section class="section-band">
  <div class="section-heading">
    <p class="eyebrow">Selected work</p>
    <h2>Projects and experiments</h2>
  </div>

  <div class="work-grid">
    <a class="work-card primary-work" href="https://automata-arcade.vercel.app">
      <span class="feature-kicker">Cellular automata</span>
      <strong>Automata Arcade</strong>
      <span>A playable workbench for composing, inspecting, and mutating emergent systems.</span>
    </a>
    <a class="work-card" href="https://github.com/jclosure/evo-lumen-life">
      <span class="feature-kicker">Artificial life</span>
      <strong>Evo Lumen Life</strong>
      <span>A browser ecosystem experiment with agents, energy, and evolving behavior.</span>
    </a>
    <a class="work-card" href="{{ '/blog/2026/07/11/a-tiny-proof-from-first-principles/' | relative_url }}">
      <span class="feature-kicker">Pure math</span>
      <strong>First principles of proof</strong>
      <span>A tiny proof showing how associativity and commutativity make algebra move.</span>
    </a>
  </div>
</section>

<section class="section-band writing-band">
  <div class="section-heading">
    <p class="eyebrow">Loose Leaf</p>
    <h2>Recent writing</h2>
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

  <p><a href="{{ '/blog/' | relative_url }}">Browse the archive</a></p>
</section>

<section class="feature-grid home-map" aria-label="Site sections">
  <a class="feature-card" href="{{ '/blog/' | relative_url }}">
    <span class="feature-kicker">Writing</span>
    <strong>Loose Leaf</strong>
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
