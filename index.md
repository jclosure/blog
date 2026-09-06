---
layout: default
title: Joel Holder
---

<canvas id="fractal-field" class="fractal-canvas" aria-hidden="true"></canvas>

<div class="fractal-content">

<section class="fractal-mast">
  <p class="fractal-kicker">Recreational learning &amp; discovery</p>
  <h1 class="fractal-name">Joel Holder</h1>
  <p class="fractal-tagline">A small, living form adrift in colored light &mdash; real geometry, real physics, nothing faked.</p>
  <p class="fractal-caption">Drag to orbit it. Scroll or pinch to move closer. It has its own slow orbit too &mdash; take over any time.</p>

  <div class="fractal-actions">
    <a class="fractal-btn primary" href="{{ '/blog/' | relative_url }}">Read the blog</a>
    <a class="fractal-btn" href="{{ '/projects/' | relative_url }}">See projects</a>
    <button type="button" id="fractal-toggle" class="fractal-toggle">Pause the field</button>
  </div>
</section>

<section class="fractal-section">
  <div class="note-panel">
    <p class="note-text">I'm a lifelong tinkerer with math, code, and the occasional unanswerable question &mdash; the kind of person who'll spend a weekend proving something nobody asked for, then spend the next one teaching a shape to breathe.</p>
    <p class="note-sub"><strong>Why write it down?</strong>Because the interesting part usually only shows up once you've tried to explain it.</p>
  </div>
</section>

<section class="fractal-section">
  <div class="fractal-heading">
    <p class="fractal-kicker">Selected work</p>
    <h2>Things I've built</h2>
  </div>

  <div class="cluster-grid">
    <a class="cluster-card" style="--i: 0" href="https://automata-arcade.vercel.app">
      <span class="cluster-tag">Cellular automata</span>
      <strong>Automata Arcade</strong>
      <span class="cluster-desc">A playable workbench for composing, inspecting, and mutating emergent systems.</span>
    </a>
    <a class="cluster-card" style="--i: 1" href="https://github.com/jclosure/evo-lumen-life">
      <span class="cluster-tag">Artificial life</span>
      <strong>Evo Lumen Life</strong>
      <span class="cluster-desc">A browser ecosystem experiment with agents, energy, and evolving behavior.</span>
    </a>
    <a class="cluster-card" style="--i: 2" href="{{ '/blog/2026/07/11/a-tiny-proof-from-first-principles/' | relative_url }}">
      <span class="cluster-tag">Pure math</span>
      <strong>First principles of proof</strong>
      <span class="cluster-desc">A tiny proof showing how associativity and commutativity make algebra move.</span>
    </a>
  </div>
</section>

<section class="fractal-section">
  <div class="fractal-heading">
    <p class="fractal-kicker">Loose Leaf</p>
    <h2>Recent writing</h2>
  </div>

  <ol class="signal-list">
  {% for post in site.posts %}
    {% if forloop.index <= 5 %}
    <li class="signal-row">
      <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
      <time datetime="{{ post.date | date_to_xmlschema }}">{{ post.date | date: "%b %-d, %Y" }}</time>
    </li>
    {% endif %}
  {% endfor %}
  </ol>
  <p class="browse-line"><a href="{{ '/blog/' | relative_url }}">Browse the full archive &rarr;</a></p>
</section>

<section class="fractal-section">
  <div class="orbit-row" aria-label="Site sections">
    <a class="orbit-card" href="{{ '/blog/' | relative_url }}">
      <span class="orbit-kicker">Writing</span>
      <strong>Loose Leaf</strong>
      <span>Technical notes, philosophy, experiments, and recovered posts from the old archive.</span>
    </a>
    <a class="orbit-card" href="{{ '/projects/' | relative_url }}">
      <span class="orbit-kicker">Builds</span>
      <strong>Projects</strong>
      <span>Automata Arcade, Evo Lumen Life, and other working sketches.</span>
    </a>
    <a class="orbit-card" href="{{ '/about/' | relative_url }}">
      <span class="orbit-kicker">Context</span>
      <strong>About</strong>
      <span>A small map of what this site is for and where the experiments point.</span>
    </a>
  </div>
</section>

</div>
