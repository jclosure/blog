---
layout: post
title: "Evo Lumen Life, creating a living ecosystem in the browser"
date: 2026-03-02 01:49:46 -0600
categories: []
tags: []
wordpress_id: 1252
original_url: "https://joelholder.com/2026/03/02/evo-lumen-life-building-a-living-artificial-ecosystem-in-the-browser/"
---
<p class="wp-block-paragraph"><em>Evo Lumen Life</em> started as a shader experiment and became a living artificial-life sandbox where organisms swim, feed, reproduce, struggle, and evolve in a shared ecosystem.</p>



<p class="wp-block-paragraph"><strong>Project repo:</strong> <a href="https://github.com/jclosure/evo-lumen-life">https://github.com/jclosure/evo-lumen-life</a></p>



<h2 class="wp-block-heading">What it is</h2>



<p class="wp-block-paragraph">Evo Lumen Life is a browser-based simulation of emergent behavior. Instead of static entities, the world is populated by evolving forms (worms, flagellates, protozoa, and virus-like agents) whose movement and survival are shaped by local interaction rules, resource pressure, and reproduction strategies.</p>



<figure class="wp-block-image size-large"><img data-recalc-dims="1" decoding="async" src="/blog/assets/wp/evo-lumen-life-building-a-living-artificial-ecosystem-in-the-browser/evo-overview-v2.png" alt="Evo Lumen Life ecosystem overview"/></figure>



<h2 class="wp-block-heading">Why?</h2>



<p class="wp-block-paragraph">I wanted something more alive than classic cellular automata: not just a pattern engine, but a watchable ecology. The design intent was to create a system that felt continuous and organic—something you could tune and observe like a tiny synthetic biosphere.</p>



<ul class="wp-block-list">
<li>Continuous lifecycle instead of abrupt generation resets</li>



<li>Predator/prey pressure and resource competition</li>



<li>Egg-based worm reproduction and juvenile growth</li>



<li>Interactive controls for time, evolution speed, drift, and species-level behavior</li>
</ul>



<h2 class="wp-block-heading">Goals</h2>



<ul class="wp-block-list">
<li><strong>Make emergence visible:</strong> behavior should unfold over time, not be hidden in static metrics.</li>



<li><strong>Keep it playful:</strong> enough complexity to surprise, enough controls to steer.</li>



<li><strong>Stay portable:</strong> run on Mac, Linux, and Windows in a browser.</li>



<li><strong>Favor flow:</strong> births, deaths, and adaptation drive the simulation</li>
</ul>



<figure class="wp-block-image size-large"><img data-recalc-dims="1" decoding="async" src="/blog/assets/wp/evo-lumen-life-building-a-living-artificial-ecosystem-in-the-browser/evo-champion-view-v2.png" alt="Champion-focused view in Evo Lumen Life"/></figure>



<h2 class="wp-block-heading">What we learned</h2>



<p class="wp-block-paragraph">The strongest improvements came from treating the system as a controlled dynamical model and validating behavior under parameter sweeps.</p>



<ul class="wp-block-list">
<li><strong>State integration quality dominates perceived realism.</strong> We update organism state in small timesteps (position, velocity, energy, age), which reduces aliasing and prevents visual/mechanical discontinuities from coarse step changes.</li>



<li><strong>Bounded nonlinear terms are mandatory.</strong> Core drivers (aggression, drift, growth, resource intake) are clamped to stable ranges. Without bounds, positive feedback causes blow-up modes (population spikes, lock-step clumping, or immediate collapse).</li>



<li><strong>Energy economics creates meaningful behavior.</strong> A simple budget model (intake &#8211; metabolic cost &#8211; reproduction cost) produced emergent strategy differences more reliably than hand-scripted behavior trees.</li>



<li><strong>Asymmetry produces richer phase space.</strong> Predator-prey and forager-resource interactions are intentionally asymmetric; this increases attractor diversity versus symmetric pairwise rules.</li>



<li><strong>Fitness is multi-objective.</strong> Useful scoring required balancing persistence, exploration, locomotion efficiency, and survivability. Single-objective optimization collapsed diversity too quickly.</li>



<li><strong>Continuity constraints matter to observers.</strong> Interpolated hatch/growth curves and decay on death states improved interpretability and made causal chains easier to track.</li>



<li><strong>Live controls function as instrumentation.</strong> Real-time sliders effectively became online experiments: we could locate bifurcation-like regime shifts quickly and tune toward stable-but-interesting dynamics.</li>
</ul>



<p class="wp-block-paragraph">Bottom line: better outcomes came from numerical stability, bounded feedback, and measurable objective tradeoffs—not from adding more visual entities alone.</p>



<h2 class="wp-block-heading">Where this could go next</h2>



<ul class="wp-block-list">
<li>Speciation tracking with lineage trees and trait inheritance maps</li>



<li>Courtship and mate selection behaviors before egg-laying</li>



<li>Objective-driven environments (seasonality, gradients, hazards)</li>



<li>Replay/annotation mode for interesting events</li>



<li>Networked multiplayer ecosystem tournaments</li>



<li>Hybrid mode: AI ecology + human strategic interventions</li>
</ul>
