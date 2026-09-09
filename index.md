---
layout: default
title: Joel Holder
---

<canvas id="chalk-canvas" class="chalk-canvas" aria-hidden="true"></canvas>

<svg width="0" height="0" style="position:absolute" aria-hidden="true">
  <filter id="chalk-rough">
    <feTurbulence type="fractalNoise" baseFrequency="0.9" numOctaves="2" seed="7" result="noise" />
    <feDisplacementMap in="SourceGraphic" in2="noise" scale="2.6" xChannelSelector="R" yChannelSelector="G" />
  </filter>
</svg>

<div class="chalk-content">

<section class="chalk-mast">
  <p class="chalk-kicker">Recreational learning &amp; discovery</p>
  <h1 class="chalk-name">Joel Holder
    <svg class="chalk-underline" viewBox="0 0 340 20" preserveAspectRatio="none" aria-hidden="true">
      <path d="M4 12 Q 60 2 120 11 T 240 10 T 336 8" />
    </svg>
  </h1>
  <p class="chalk-tagline">Math, code, and the occasional unanswerable question &mdash; pursued mostly because I can't leave them alone.</p>
  <p class="chalk-caption">This board is real: drag anywhere to write on it, pick a color from the tray, or grab the eraser.</p>

  <div class="chalk-actions">
    <a class="chalk-btn primary" href="{{ '/blog/' | relative_url }}">Read the blog</a>
    <a class="chalk-btn" href="{{ '/projects/' | relative_url }}">See projects</a>
  </div>

  <div class="chalk-tray">
    <span class="chalk-tray-label">Chalk tray:</span>
    <button type="button" class="chalk-stick active" data-color="#f4f1e6" style="background:#f4f1e6" aria-label="White chalk"></button>
    <button type="button" class="chalk-stick" data-color="#f0d78c" style="background:#f0d78c" aria-label="Yellow chalk"></button>
    <button type="button" class="chalk-stick" data-color="#a8cfe0" style="background:#a8cfe0" aria-label="Blue chalk"></button>
    <button type="button" class="chalk-stick" data-color="#e8aebd" style="background:#e8aebd" aria-label="Pink chalk"></button>
    <button type="button" id="chalk-erase" class="chalk-tool">Eraser</button>
    <button type="button" id="chalk-clear" class="chalk-tool">Wipe board</button>
  </div>
</section>

<section class="chalk-section">
  <div class="note-panel">
    <p class="note-text">I'm a lifelong tinkerer with math, code, and the occasional unanswerable question &mdash; I'd rather build a small working model of an idea than just read about it, then write down whatever I find along the way.</p>
    <p class="note-sub"><strong>Why write it down?</strong>Because the interesting part usually only shows up once you've tried to explain it.</p>
  </div>
</section>

<section class="chalk-section">
  <div class="chalk-heading">
    <p class="chalk-kicker">Selected work</p>
    <h2>Things I've built</h2>
  </div>

  <div class="lesson-grid">
    <a class="lesson-card" href="https://automata-arcade.vercel.app">
      <span class="lesson-tag">Cellular automata</span>
      <strong>Automata Arcade</strong>
      <span class="lesson-desc">A playable workbench for composing, inspecting, and mutating emergent systems.</span>
    </a>
    <a class="lesson-card" href="https://github.com/jclosure/evo-lumen-life">
      <span class="lesson-tag">Artificial life</span>
      <strong>Evo Lumen Life</strong>
      <span class="lesson-desc">A browser ecosystem experiment with agents, energy, and evolving behavior.</span>
    </a>
    <a class="lesson-card" href="{{ '/blog/2026/07/11/a-tiny-proof-from-first-principles/' | relative_url }}">
      <span class="lesson-tag">Pure math</span>
      <strong>First principles of proof</strong>
      <span class="lesson-desc">A tiny proof showing how associativity and commutativity make algebra move.</span>
    </a>
  </div>
</section>

<section class="chalk-section">
  <div class="chalk-heading">
    <p class="chalk-kicker">Loose Leaf</p>
    <h2>Recent writing</h2>
  </div>

  <ol class="roster-list">
  {% for post in site.posts %}
    {% if forloop.index <= 5 %}
    <li class="roster-row">
      <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
      <time datetime="{{ post.date | date_to_xmlschema }}">{{ post.date | date: "%b %-d, %Y" }}</time>
    </li>
    {% endif %}
  {% endfor %}
  </ol>
  <p class="browse-line"><a href="{{ '/blog/' | relative_url }}">Browse the full archive &rarr;</a></p>
</section>

<section class="chalk-section">
  <div class="door-row" aria-label="Site sections">
    <a class="door-card" href="{{ '/blog/' | relative_url }}">
      <span class="door-kicker">Writing</span>
      <strong>Loose Leaf</strong>
      <span>Technical notes, philosophy, experiments, and recovered posts from the old archive.</span>
    </a>
    <a class="door-card" href="{{ '/projects/' | relative_url }}">
      <span class="door-kicker">Builds</span>
      <strong>Projects</strong>
      <span>Automata Arcade, Evo Lumen Life, and other working sketches.</span>
    </a>
    <a class="door-card" href="{{ '/about/' | relative_url }}">
      <span class="door-kicker">Context</span>
      <strong>About</strong>
      <span>A small map of what this site is for and where the experiments point.</span>
    </a>
  </div>
</section>

</div>
