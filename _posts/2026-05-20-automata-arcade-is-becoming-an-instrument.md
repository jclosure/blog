---
layout: post
title: "Automata Arcade Is Becoming an Instrument"
date: 2026-05-20 00:38:03 -0600
categories: []
tags: ["Automata Arcade", "cellular automata", "creative coding", "manifolds", "simulation"]
wordpress_id: 1810
original_url: "https://joelholder.com/2026/05/20/automata-arcade-is-becoming-an-instrument/"
---
<p><em>Automata Arcade now has selection transforms, lenses, zones, and manifold-mapped regions. The project is shifting from a cellular automata sandbox into a small workbench for building, inspecting, and reusing emergent systems.</em></p>
<p>Automata Arcade started as a simple cellular automata canvas: paint cells, run the simulation, watch the pattern evolve.</p>
<p>That loop is still there, but the tool now supports the operations needed for serious iteration: select, transform, inspect, isolate, map, and reuse.</p>
<p>Try it here: <a href="https://automata-arcade.vercel.app">Automata Arcade live demo</a> · <a href="https://github.com/jclosure/automata-arcade">GitHub repository</a></p>
<h2>The board is editable</h2>
<p>Selection mode turns a region of cells into an object you can operate on. You can draw a rectangular selection, translate it, rotate it 90 degrees, flip it, copy it, cut it, paste it, and save the result as a prefab.</p>
<p>For cellular automata, that matters. A glider stream, oscillator, eater, failed collision, or partial circuit is no longer just transient state on the board. It becomes material.</p>
<p>The workflow changes from redrawing patterns by hand to editing mechanisms directly:</p>
<ol>
<li>observe a behavior</li>
<li>select the active region</li>
<li>transform or duplicate it</li>
<li>test the new geometry</li>
<li>save the useful result</li>
</ol>
<p>That is the basic interaction model for an automata workbench.</p>
<h2>Lenses keep local behavior readable</h2>
<p>Lenses are circular magnifiers placed directly on the canvas. They enlarge a local region without zooming the whole board.</p>
<figure class="wp-block-image size-large"><img data-recalc-dims="1" loading="lazy" decoding="async" width="960" height="600" data-attachment-id="1807" data-permalink="https://joelholder.com/01-lenses-zones-fields-live-2/" data-orig-file="https://i0.wp.com/joelholder.com/wp-content/uploads/2026/05/01-lenses-zones-fields-live.gif?fit=960%2C600&amp;ssl=1" data-orig-size="960,600" data-comments-opened="1" data-image-meta="{&quot;aperture&quot;:&quot;0&quot;,&quot;credit&quot;:&quot;&quot;,&quot;camera&quot;:&quot;&quot;,&quot;caption&quot;:&quot;&quot;,&quot;created_timestamp&quot;:&quot;0&quot;,&quot;copyright&quot;:&quot;&quot;,&quot;focal_length&quot;:&quot;0&quot;,&quot;iso&quot;:&quot;0&quot;,&quot;shutter_speed&quot;:&quot;0&quot;,&quot;title&quot;:&quot;&quot;,&quot;orientation&quot;:&quot;0&quot;}" data-image-title="01-lenses-zones-fields-live" data-image-description="" data-image-caption="" data-large-file="https://i0.wp.com/joelholder.com/wp-content/uploads/2026/05/01-lenses-zones-fields-live.gif?fit=960%2C600&amp;ssl=1" src="/assets/wp/automata-arcade-is-becoming-an-instrument/01-lenses-zones-fields-live.gif" alt="A short capture of lenses and zones while the automaton evolves" class="wp-image-1807" /><figcaption>A short capture of lenses and zones while the automaton evolves</figcaption></figure>
<p>Automata are multiscale. You often need neighbor-level detail and board-level context at the same time: births, deaths, phase offsets, collision fronts, stream timing, boundaries, and population waves.</p>
<p>A normal zoom makes you choose between those views. Lenses let you keep both.</p>
<p>You can place one lens over a generator, another over a collision site, and compare cause and effect while the simulation runs.</p>
<h2>Zones make rules spatial</h2>
<p>Zones are rectangular regions with rule overrides. A cell can move from classic Life into HighLife, Seeds, Day &amp; Night, or a custom B/S rule without leaving the board.</p>
<p>That makes the plane heterogeneous. A zone can act as a reaction chamber, protected basin, hostile boundary, rule-gradient experiment, or computational component.</p>
<p>The question becomes more precise: what happens when a structure crosses from one local physics into another?</p>
<p>That is useful for design, debugging, and play. It also gives rule changes a spatial form instead of treating them as global configuration.</p>
<h2>Manifold regions make topology local</h2>
<p>Manifold Regions map a rectangular patch of the flat board onto a topology such as a sphere, torus, Möbius strip, or Klein bottle.</p>
<figure class="wp-block-image size-large"><img data-recalc-dims="1" loading="lazy" decoding="async" width="960" height="600" data-attachment-id="1809" data-permalink="https://joelholder.com/03-manifold-regions-curvature/" data-orig-file="https://i0.wp.com/joelholder.com/wp-content/uploads/2026/05/03-manifold-regions-curvature.gif?fit=960%2C600&amp;ssl=1" data-orig-size="960,600" data-comments-opened="1" data-image-meta="{&quot;aperture&quot;:&quot;0&quot;,&quot;credit&quot;:&quot;&quot;,&quot;camera&quot;:&quot;&quot;,&quot;caption&quot;:&quot;&quot;,&quot;created_timestamp&quot;:&quot;0&quot;,&quot;copyright&quot;:&quot;&quot;,&quot;focal_length&quot;:&quot;0&quot;,&quot;iso&quot;:&quot;0&quot;,&quot;shutter_speed&quot;:&quot;0&quot;,&quot;title&quot;:&quot;&quot;,&quot;orientation&quot;:&quot;0&quot;}" data-image-title="03-manifold-regions-curvature" data-image-description="" data-image-caption="" data-large-file="https://i0.wp.com/joelholder.com/wp-content/uploads/2026/05/03-manifold-regions-curvature.gif?fit=960%2C600&amp;ssl=1" src="/assets/wp/automata-arcade-is-becoming-an-instrument/03-manifold-regions-curvature.gif" alt="A short capture of automata evolving across manifold-mapped regions" class="wp-image-1809" /><figcaption>A short capture of automata evolving across manifold-mapped regions</figcaption></figure>
<p>The whole board does not need to become a torus. A local patch can have toroidal adjacency while the surrounding workspace stays flat. Another patch can contain a Möbius seam.</p>
<p>This makes topology an editable part of the system. The same rule and seed can behave differently because the neighborhood graph changed.</p>
<p>For cellular automata, the rule is not the whole machine. Initial condition, observation, tools, and geometry all matter. Manifold Regions make the geometry explicit.</p>
<h2>The IDE shape</h2>
<p>Several systems are now converging:</p>
<ul>
<li>canvas tools: paint, select, transform, stamp</li>
<li>analysis tools: period detection, population tracking, heatmaps</li>
<li>rule tools: presets, B/S editing, kernel radius, Lenia controls</li>
<li>spatial tools: zones, force fields, lenses</li>
<li>topology tools: manifold regions and curvature visualization</li>
<li>journal/script tools: documented, replayable experiments</li>
</ul>
<p>The next useful step is persistence. Experiments should capture board state, rule configuration, selected regions, camera and lens positions, script cells, manifold mappings, and replayable timelines.</p>
<p>Prefabs should also become structured objects instead of screenshots: period, bounding box, velocity, input/output lanes, required phase, compatible rules, and known failure modes.</p>
<p>After that, topology can become a programming surface. Region seams, wraps, and local adjacency changes could be used as parts of spatial circuits.</p>
<p>The longer-term direction is an interactive atlas: scenes, rules, mechanisms, manifolds, and experiments that can be inspected, forked, mutated, and republished.</p>
<p>Automata Arcade is still an arcade. The play matters. But the current direction is clear: it is becoming an instrument for composing and studying cellular automata.</p>
