---
layout: post
title: "Automata Arcade: Building a Playable Lab for Conway’s Game of Life"
date: 2026-03-07 23:21:02 -0600
categories: []
tags: []
wordpress_id: 1460
original_url: "https://joelholder.com/2026/03/07/automata-arcade-building-a-playable-lab-for-conways-game-of-life/"
---
<p class="wp-block-paragraph"><em>Automata Arcade turns Conway’s Game of Life into a live engineering arena. You do not just observe emergence, you shape it in real time.</em></p>



<p class="wp-block-paragraph"><strong>Live demo:</strong> <a href="https://automata-arcade.vercel.app">automata-arcade.vercel.app</a><br><strong>GitHub:</strong> <a href="https://github.com/jclosure/automata-arcade">github.com/jclosure/automata-arcade</a></p>



<figure class="wp-block-image size-full"><img data-recalc-dims="1" decoding="async" src="/assets/wp/automata-arcade-building-a-playable-lab-for-conways-game-of-life/hero.gif" alt="Automata Arcade hero animation"/></figure>



<h3 class="wp-block-heading">The core idea: computation through conflict</h3>



<p class="wp-block-paragraph">Game of Life is deceptively simple. Tiny local rules create global behavior that feels alive. In Automata Arcade, that behavior is not just visual, it is playable. You drop mechanisms, route moving signals, and watch tiny decisions scale into system-level outcomes.</p>



<p class="wp-block-paragraph">You are not placing pixels. You are placing <strong>possibility</strong>.</p>



<h3 class="wp-block-heading">Changing the game while it is being played</h3>



<p class="wp-block-paragraph">The board never freezes for you. Mid-simulation, you can rotate a structure into a stream, place an eater to terminate flow, or inject a fresh emitter into a crowded lane. That shifts your role from “builder” to “operator”, making architecture decisions under motion.</p>



<h3 class="wp-block-heading">The palette is your machine language</h3>



<ul class="wp-block-list">
<li><strong>Gliders</strong> as mobile information packets</li>



<li><strong>LWSS</strong> for directional traffic experiments</li>



<li><strong>Gosper glider guns</strong> as persistent emitters</li>



<li><strong>Eater-1</strong> as selective termination and routing control</li>



<li><strong>Seeds and oscillators</strong> for timing, cadence, and pressure</li>
</ul>



<p class="wp-block-paragraph">The moment these pieces start interacting, the system becomes legible in a new way. You stop asking “what pattern is this?” and start asking “what behavior does this enforce?”</p>



<h3 class="wp-block-heading">Battles, timing, and emergent strategy</h3>



<p class="wp-block-paragraph">Two glider streams can annihilate, reinforce, or generate surprising downstream structures depending on phase and offset. A tiny timing shift can flip a design from stable to catastrophic. That is where the battles happen, not cosmetic combat, but true dynamical conflict between interacting rule systems.</p>



<p class="wp-block-paragraph">Because the world is deterministic, every surprise is still explainable after the fact. That tension between surprise and explainability is what makes the learning loop addictive.</p>



<h3 class="wp-block-heading">Implementation, deliberately lightweight</h3>



<ul class="wp-block-list">
<li>Vanilla HTML/CSS/JS front end</li>



<li>Large-grid simulation with pan/zoom and variable stepping</li>



<li>Draggable prefab placement with rotate/flip transforms</li>



<li>Arcade wrapper with objectives, scoring, combo, and fail states</li>



<li>Static-friendly deploy and self-hosted media on Vercel</li>
</ul>



<p class="wp-block-paragraph">The goal was not maximal complexity. The goal was maximal <strong>agency</strong>: every control should help you reason about emergence without flattening it.</p>







<h3 class="wp-block-heading">Watch it in motion</h3>



<figure class="wp-block-image alignwide size-large"><img data-recalc-dims="1" loading="lazy" decoding="async" width="960" height="540" data-attachment-id="1934" data-permalink="https://joelholder.com/2026/03/07/automata-arcade-building-a-playable-lab-for-conways-game-of-life/automata-arcade-demo/" data-orig-file="https://i0.wp.com/joelholder.com/wp-content/uploads/2026/03/automata-arcade-demo.gif?fit=960%2C540&amp;ssl=1" data-orig-size="960,540" data-comments-opened="1" data-image-meta="{&quot;aperture&quot;:&quot;0&quot;,&quot;credit&quot;:&quot;&quot;,&quot;camera&quot;:&quot;&quot;,&quot;caption&quot;:&quot;&quot;,&quot;created_timestamp&quot;:&quot;0&quot;,&quot;copyright&quot;:&quot;&quot;,&quot;focal_length&quot;:&quot;0&quot;,&quot;iso&quot;:&quot;0&quot;,&quot;shutter_speed&quot;:&quot;0&quot;,&quot;title&quot;:&quot;&quot;,&quot;orientation&quot;:&quot;0&quot;,&quot;alt&quot;:&quot;&quot;}" data-image-title="automata-arcade-demo" data-image-description="" data-image-caption="&lt;p&gt;Automata Arcade demo animation&lt;/p&gt;
" data-large-file="https://i0.wp.com/joelholder.com/wp-content/uploads/2026/03/automata-arcade-demo.gif?fit=960%2C540&amp;ssl=1" src="/assets/wp/automata-arcade-building-a-playable-lab-for-conways-game-of-life/automata-arcade-demo.gif" alt="Automata Arcade demo animation" class="wp-image-1934"/><figcaption>Automata Arcade demo animation</figcaption></figure>



<h3 class="wp-block-heading">Why this matters</h3>



<p class="wp-block-paragraph">Automata Arcade is a reminder that complex behavior can emerge from minimal rules, and that interactive systems can teach hard ideas quickly. Computation, resilience, failure modes, and control become tactile when you can build and intervene in real time.</p>



<p class="wp-block-paragraph">We are still early. There is far more power to unlock here.</p>
