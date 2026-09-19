---
layout: post
title: "Conway's Circle, and the Right Triangle Hiding in Every Triangle"
date: 2026-08-27 14:30:00 -0500
categories: [math]
tags: ["geometry", "conway's circle", "pythagorean theorem", "incenter", "first principles", "triangle centers"]
---

<style>
.conway-post .katex-display > .katex { font-size: 1.3em !important; }
.conway-post .katex { font-size: 1.28em !important; }
.conway-post .lead-in { color: #cdd7db; font-size: 1.04rem; }
</style>

<div class="conway-post" markdown="1">

Here is a party trick you can do with a ruler.

Draw any triangle. Take each side and, at each of its two ends, keep going past the corner — extend the line — by a very specific amount: the length of the side *opposite* that corner. You now have six new points floating out beyond the triangle, two hanging off each vertex.

Those six points lie on a circle.

Not approximately. Exactly. And it doesn't matter what triangle you started with — squat, spindly, obtuse, nearly equilateral. Six extensions, one circle, every time.

<figure class="math-figure">
  <img src="/assets/math/conways-circle/construction.svg" alt="Triangle A B C with every side produced past both endpoints by the length of the opposite side; the six endpoints lie on one amber circle centred at the incentre, with the incircle drawn concentric inside it" />
  <figcaption>Produce each side past each corner by the opposite side's length. The six endpoints are concyclic.</figcaption>
</figure>

This is **Conway's circle**, after [John Conway](/blog/2026/03/07/automata-arcade-building-a-playable-lab-for-conways-game-of-life/) — the same restless mind behind the Game of Life. It is one of those results that looks like a coincidence and turns out to be a right triangle wearing a disguise. This post is about taking the disguise off: why a circle, where its center is, where its radius comes from, and why the whole thing is really the Pythagorean theorem applied six times in six different reference frames.

## The claim, said precisely

Let's pin down a few names and keep them for the rest of the post.

Label the corners $A$, $B$, and $C$. Label each **side** with the small letter of the corner it faces — the corner it does *not* touch:

$$
a = |BC|, \qquad b = |CA|, \qquad c = |AB|.
$$

So $a$ is the side directly across from corner $A$, $b$ is across from $B$, and $c$ is across from $C$. Add the three side lengths together and you get the **perimeter** — the distance once around the triangle. Half of that gets its own name, the **semiperimeter** ("semi-" just means half):

$$
s = \frac{a + b + c}{2}.
$$

<figure class="math-figure">
  <img src="/assets/math/conways-circle/naming.svg" alt="Triangle ABC with each side coloured and labelled for the corner opposite it: side a opposite A, side b opposite B, side c opposite C. Below, the three side lengths laid end to end, with the first half of that total length bracketed and marked s." />
  <figcaption>Each side is named for the corner across from it. The semiperimeter $s$ is half the trip around.</figcaption>
</figure>

Now the construction itself, one corner at a time.

Start at a corner — say $A$. Two sides of the triangle meet there. **Extend both of them in a straight line past $A$**, out beyond the triangle, and keep going until you have added a length equal to $a$, the side opposite $A$. A concrete way to add "a length equal to $a$": open a compass to the length of side $a$, put its point on $A$, and sweep an arc. Wherever that arc crosses an extended side is where you stop. Corner $A$ now has two new points hanging off it.

Do exactly the same at $B$, adding a length $b$ each time, and at $C$, adding a length $c$. Six extensions, six new points.

<figure class="math-figure">
  <img src="/assets/math/conways-circle/construction-steps.svg" alt="Four panels. Panel 1: the triangle with the side opposite corner A highlighted and labelled a. Panel 2: a dashed compass arc of radius a swung from A, crossing the two sides extended past A at two marked points. Panel 3: the same arcs drawn at all three corners, giving six marked points and six extension segments. Panel 4: a single circle drawn through all six points, with the triangle and its incentre inside." />
  <figcaption>The construction in four steps: mark the opposite side, swing that length past the corner, repeat at all three corners, and a circle catches all six points.</figcaption>
</figure>

Here is the same thing in motion — swing the arc at one corner, mark where it lands, move to the next, and once all six points are down, draw the circle:

<figure class="math-figure">
  <img src="/assets/math/conways-circle/walkthrough.svg" alt="An animation. From corner A, an arc the length of the opposite side is swung out, and two points appear where it crosses the two sides extended past A. The same happens at B and at C. Finally a circle is drawn through all six points." />
  <figcaption>One corner at a time: step out by the opposite side, and every landing spot turns out to sit on the same circle.</figcaption>
</figure>

**Claim.** Those six points lie on a single circle. Its center is the triangle's incenter $I$, and its radius is

$$
R = \sqrt{r^2 + s^2},
$$

where $r$ is the inradius — the radius of the inscribed circle.

Everything interesting is packed into that square root. Let's earn it.

## A circle is a promise about distance

Before chasing the proof, it helps to be blunt about what a circle *is*, because the definition does most of the work.

A circle is not primarily a round shape. A circle is **the set of all points at one fixed distance from one fixed point.** That's the whole content. "These points lie on a circle" is exactly the statement "there is a single point from which all of them are the same distance away."

So the mystery "why do six points land on a circle?" collapses into a much more concrete question:

> Is there one point in the plane that is equidistant from all six extension points?

If we can name that point and measure that distance, we are done — the circle is then guaranteed, for free, by the definition. No roundness to verify, no curvature to check. Just one distance, computed six times, coming out equal.

That reframing is the first real move. We are no longer looking for a circle. We are looking for a **center**.

## Finding the center

From the last section, the whole job is now this: **find one point that is the same distance from all six extension points.** Call it the center — the problem is solved the moment we have it.

Here is the only clue on the table. The six points aren't scattered at random; they come in three pairs, and each pair sits on the straight line through one side of the triangle. (Every side lies along an endless straight line, and the extensions just slide out along it. I'll call that line the side's **side-line**.)

So whatever the center is, it sits at some distance from each of the three side-lines. "Distance from a point to a line" means the *shortest* distance: head straight at the line so you meet it square-on, at a right angle, and measure that.

In the next two sections the radius $R$ will turn out to be built from two ingredients — this straight-in distance, and a distance measured *along* the side-line. For all six points to come out at one common distance, the straight-in distance has to be the **same number for all three side-lines**. That is the one thing we need from the center:

> it is equally far from all three sides.

**Exactly one point does that, and you can find it by folding.**

Take two sides — say $AB$ and $AC$ — that meet at corner $A$. Which points are equally far from both of those lines? Picture standing in the corner of a room: the spots the same distance from both walls run down the diagonal, straight through the middle of the corner. In a triangle that middle line is the **angle bisector** at $A$ — the crease you would get by folding side $AB$ exactly onto side $AC$. Every point on that crease is equally far from the two sides.

Do the same fold at corner $B$. Its bisector is the set of points equally far from $BA$ and $BC$.

Where the two creases cross, the point is equally far from $AB$ and $AC$ (it lies on $A$'s bisector) **and** equally far from $AB$ and $BC$ (it lies on $B$'s bisector) — so it is the same distance from all three sides at once. That point is the **incenter**, $I$.

<figure class="math-figure">
  <img src="/assets/math/conways-circle/incenter-find.svg" alt="Triangle ABC with the angle bisectors from corners A and B drawn as dashed lines crossing at a point I. From I, three short perpendicular segments of equal length reach the three sides, each with a right-angle mark. An amber circle centred at I passes through those three feet — the incircle — and one perpendicular is labelled r." />
  <figcaption>Two folds locate $I$: the point the same distance $r$ from all three sides. Its circle, the incircle, is the largest that fits inside.</figcaption>
</figure>

The circle centered at $I$ with that common distance as its radius touches all three sides and crosses none of them — the biggest circle that fits inside the triangle. It is the **incircle**, and its radius is the **inradius**, $r$. Picture blowing up a balloon inside the triangle until it presses on all three sides: its center is $I$, and $r$ is how big it got.

That is our candidate center. Now we measure.

## Why the number is $s$: half the perimeter, made of pieces

We are about to see $s$ — half the perimeter — turn up everywhere. It's worth a minute on *why that exact number*, because it isn't a convenience. It is the total of three little lengths hiding on the triangle's edges.

The incircle touches each side once. Mark those three touch points. They chop the triangle's boundary into six pieces.

Look at the two pieces that meet at corner $A$: one runs from $A$ to the touch point on $AB$, the other from $A$ to the touch point on $AC$. **They are the same length.** (It's the "two tangents from one point" fact: the two lines you can draw from an outside point to just touch a circle are equal, because the picture is mirror-symmetric across the line from the point to the circle's center.) Call that shared length $x$. Call the matching pair at corner $B$ length $y$, and the pair at corner $C$ length $z$.

<figure class="math-figure">
  <img src="/assets/math/conways-circle/semiperimeter-why.svg" alt="Triangle ABC with its incircle. The three touch points cut the boundary into six coloured pieces: two greens of length x meeting at A, two blues of length y meeting at B, two ambers of length z meeting at C. Below, the six pieces are regrouped into x plus y plus z, then x plus y plus z again, each half bracketed and labelled s, with the full bar labelled 2s." />
  <figcaption>The boundary is six pieces — $x, y, z$ each appearing twice. One of each is $s$.</figcaption>
</figure>

Now walk once around the triangle. In order, you cross $x,\ y,\ y,\ z,\ z,\ x$ — each of the three lengths **twice**. So

$$
\text{perimeter} = 2x + 2y + 2z,
$$

and half of it is

$$
s = x + y + z.
$$

*That* is what "halfway" means here: **$s$ is one copy of each tangent length.** The perimeter counts each of them twice, because every one is shared between two sides; $s$ is what's left once you stop double-counting.

<figure class="math-figure">
  <img src="/assets/math/conways-circle/semiperimeter-walk.svg" alt="An animation. A marker travels once around the triangle. As it crosses each of the six boundary pieces, a coloured bar of that length drops into a tally below. After a full lap the tally holds two greens, two blues and two ambers; the pieces then slide into the order x, y, z, x, y, z, and each half of the bar is bracketed as x plus y plus z equals s." />
  <figcaption>One lap spends $x$, $y$, and $z$ twice each. Half the lap is one full set: $s = x + y + z$.</figcaption>
</figure>

And now each tangent length gets a short name. On side $AB$ the two pieces are $x$ (from $A$) and $y$ (from $B$), and together they make the whole side: $x + y = c$. Since $x + y + z = s$, subtracting gives $z = s - c$. The same move on the other two sides gives all three:

$$
x = s - a, \qquad y = s - b, \qquad z = s - c.
$$

So on side $AB$, the touch point $F$ sits a distance $s - a$ from corner $A$, and $s - b$ from corner $B$.

## The top-up to $s$

Now extend the side. Past $A$ we add a length $a$; past $B$ we add a length $b$. Measure from the touch point $F$ out to each new point, *along the line*:

<div class="proof-sequence" markdown="1">
<div class="proof-step" markdown="1">
**Toward the "beyond A" point**

<p class="step-formula">\((s - a) + a = s\)</p>
</div>

<div class="proof-step" markdown="1">
**Toward the "beyond B" point**

<p class="step-formula">\((s - b) + b = s\)</p>
</div>
</div>

Both land on $s$. And this is exactly why the rule extends by the *opposite* side. On side $AB$, the piece from corner $A$ to the touch point is $x = s - a$. To reach a full set $s$, the gap still to fill is $s - (s - a) = a$ — the side opposite $A$. "Extend by the opposite side" is just "fill the gap back up to one full set of tangent lengths." Every extension point, on every side-line, ends up exactly $s$ from that line's touch point.

<figure class="math-figure">
  <img src="/assets/math/conways-circle/tangent-topup.svg" alt="Side AB drawn as a measured strip: the touch point F splits the side into segments s minus a and s minus b; producing past A by a and past B by b extends each run to exactly s" />
  <figcaption>The touch point cuts the side into $s-a$ and $s-b$. Producing by the opposite side tops each run up to $s$.</figcaption>
</figure>

## The right triangle hiding in the picture

Now put the two measurements together, on one side-line, say $AB$.

Stand at the incenter $I$. Drop a perpendicular to line $AB$. By definition of "distance from a point to a line," this perpendicular has length $r$ and its foot is the touch point $F$. From $F$, walk along the line a distance $s$ — and you arrive at one of the extension points, $P$.

So $I$, $F$, and $P$ form a triangle with a right angle at $F$: one leg $r$ straight down to the line, one leg $s$ along the line. The distance from $I$ back to $P$ is the hypotenuse.

<figure class="math-figure">
  <img src="/assets/math/conways-circle/right-triangle.svg" alt="A schematic right triangle: vertical leg r from the incentre I down to the contact point F on the side line, horizontal leg s from F out to an extension point, and the hypotenuse R from I to that extension point, equal to the square root of r squared plus s squared" />
  <figcaption>One leg $r$, one leg $s$, right angle at the touch point. The hypotenuse is $R$.</figcaption>
</figure>

<div class="proof-sequence" markdown="1">
<div class="proof-step" markdown="1">
**Legs of the right triangle**

<p class="step-formula">\(|IF| = r, \qquad |FP| = s\)</p>
</div>

<div class="proof-step" markdown="1">
**Pythagoras**

<p class="step-formula">\(|IP|^2 = r^2 + s^2\)</p>
</div>

<div class="proof-step" markdown="1">
**Distance from the incenter to the extension point**

<p class="step-formula">\(|IP| = \sqrt{r^2 + s^2}\)</p>
</div>
</div>

Nothing in that calculation mentioned *which* side, *which* end, or *which* extension point. Every one of the six points is $r$ off some side-line and $s$ along it from that line's touch point. So every one of the six is exactly $\sqrt{r^2 + s^2}$ from $I$.

Six points, one distance, one center. By the definition of a circle, we're finished. The radius is $R = \sqrt{r^2 + s^2}$, and Conway's circle is real.

## Hypotenuse, or law of cosines?

Both — and seeing why is the "mental bedrock" worth sitting with.

The general tool for "two sides and the angle between them, find the third side" is the **law of cosines**. For triangle $IFP$, with the angle $\theta$ at the vertex $F$:

$$
R^2 = |IF|^2 + |FP|^2 - 2\,|IF|\,|FP|\cos\theta = r^2 + s^2 - 2rs\cos\theta.
$$

The Pythagorean theorem is not a different law. It is this law at one specific angle. When $\theta = 90^\circ$, $\cos\theta = 0$, the entire cross term $-2rs\cos\theta$ vanishes, and what's left is

$$
R^2 = r^2 + s^2.
$$

So the honest answer to "are we taking the hypotenuse, or using the law of cosines?" is: we are using the law of cosines, and it *collapses* to the hypotenuse, because the angle is exactly right. And the angle is exactly right for a reason we did not arrange by hand — it is $90^\circ$ because "the distance from $I$ to the line" *means* the perpendicular distance. Perpendicularity is baked into the word "distance." The right angle is a gift from the metric, not a feature of the triangle.

That $\cos\theta = 0$ is doing something quietly profound: it is the reason the two legs don't interfere. The run along the line ($s$) and the drop to the line ($r$) contribute to $R$ *independently*, each through its own square, with no interaction term. Change one, and the other's contribution is untouched. That independence is exactly what "perpendicular" buys you, and it is why the answer is a clean sum of two squares rather than a messy blend of three lengths.

## Sum of squares, and what it means

You asked what it *means* to add the squares. Three answers, at three altitudes.

**Geometrically.** $r$ and $s$ are the two legs of a right triangle, and $\sqrt{r^2 + s^2}$ is its hypotenuse — the straight-line shortcut across the right angle. Adding the squares and taking the root is the operation that turns "how far across, how far up" into "how far, as the crow flies." Set up local coordinates on side-line $AB$: origin at the touch point $F$, one axis running along the line, the other pointing at $I$. Then $I$ sits at $(0, r)$ and the two extension points sit at $(+s, 0)$ and $(-s, 0)$. The displacement from $I$ to an extension point is $(\pm s, -r)$, and its length is $\sqrt{s^2 + r^2}$. The construction is a machine for handing six points the *same* coordinates $(\pm s, 0)$ relative to $I$'s $(0,r)$ — in six different frames, one per side per end — and the sum of squares reports all six back as the same distance.

**Mathematically.** The plane's ruler *is* the sum of squares. The distance between $(x_1, y_1)$ and $(x_2, y_2)$ is $\sqrt{(x_2 - x_1)^2 + (y_2 - y_1)^2}$ — Pythagoras, promoted to the definition of length. And a circle of radius $R$ about a center is, by definition, the level set

$$
(x - x_0)^2 + (y - y_0)^2 = R^2 :
$$

the places where that sum of squares holds a constant value. So "why do the six points form a circle?" and "why does the sum $r^2 + s^2$ come out constant?" are *the same question asked twice*. The circle is the shape of "sum of squares = constant." Nothing else.

**Philosophically.** The sum-of-squares law is the statement that space is *flat* — Euclidean, uncurved, the same in every direction. It is the local ruler that a flat plane hands you. A circle is what "keep the same distance" looks like when you measure with that ruler. On a curved surface — the sphere, the hyperbolic plane — the ruler is different, "straight lines" bend, and this construction would not close up into a circle without being re-derived from scratch, with $r$ and $s$ no longer combining by a bare Pythagoras. So Conway's circle is a fingerprint of the triangle, yes — but just as much a fingerprint of the flat plane it's drawn on. The roundness is borrowed from the metric.

That last point echoes something from [the staircase post](/blog/2026/07/21/the-staircase-and-the-slide/): the Euclidean distance formula is the quiet foundation under a surprising amount of calculus and geometry, and it is *always* a sum of squares under a root.

## The perimeter is the chord

Look again at a single side-line. It carries two of the six points — one produced past each endpoint — and we showed each sits a distance $s$ from the touch point, on opposite sides of it. So the two extension points on that line are

$$
s + s = 2s = a + b + c
$$

apart. The chord that side-line cuts across Conway's circle has length **exactly the perimeter of the triangle.**

That is the clean answer to why the extension points terminate where they do — "along the line the perimeter traces." The stopping rule was chosen so that the half-chord equals the *half*-perimeter $s$. Then $s$ becomes one leg of the right triangle, the perpendicular offset $r$ is the other, and $R = \sqrt{r^2 + s^2}$ falls out. The perimeter is not lurking in the background of this figure; it is drawn on it three times, once as each side-line's chord. Walk once around the triangle and you have walked the length of any one of those chords.

There is a satisfying bookkeeping here. The semiperimeter $s$ is a *sum* — it is literally $\tfrac{1}{2}(a + b + c)$, the kind of running total that [shows up all over elementary geometry](/blog/2026/07/12/gauss-pascal-and-triangular-numbers/). Conway's construction takes that sum, stands it up as the long leg of a right triangle, and squares it. The radius carries the whole perimeter inside it, folded into one term under the root.

## Change the triangle — the circle keeps its promise

Every step above used only three things: that the triangle *has* an incenter (every triangle does), that the tangent lengths from a vertex are equal (true for any circle and any external point), and that $r$ and $s$ are positive (true unless the triangle collapses to a segment). Nowhere did we use a special angle, a special ratio, or a special shape.

So the circle is not a property of *some* triangles. It is a property of the word "triangle." Deform yours however you like — the incenter slides, $r$ and $s$ change, the radius $\sqrt{r^2 + s^2}$ grows and shrinks — and the six points ride the changing circle without ever stepping off it.

<figure class="math-figure">
  <img src="/assets/math/conways-circle/morph.svg" alt="An animation: one vertex of a triangle wanders continuously while the six extension points and their circle are recomputed each instant; the six points stay exactly on the circle as its centre and radius shift" />
  <figcaption>One vertex wanders. The incenter drifts, the radius breathes, and the six points never leave the circle.</figcaption>
</figure>

## Watch the edge land

The walk-through above took one corner at a time. Here is the same construction fired all at once, so you can see the six tips reach and the circle close in a single motion.

Each edge is a directed segment — a vector from one corner to the next. (In the geometric-algebra sense the *edge* is the vector; the oriented triangle it bounds is the bivector, an area element. What we stretch here is the edge vector.) Take that edge vector, run it past the far corner, and keep going by the length of the opposite side. Do it on all six half-edges. The six tips light up — and a circle threads all six.

<figure class="math-figure">
  <img src="/assets/math/conways-circle/extend.svg" alt="An animation: starting from a fixed triangle, each side grows outward past both endpoints by the opposite side's length; dots appear at the six new endpoints and a circle then draws itself through all six" />
  <figcaption>Produce each edge by the opposite side. The tips land, and the circle closes through them.</figcaption>
</figure>

The reason it always lands: extending by the opposite side is the same as topping the tangent run up to $s$, and once every tip is $s$ along its line and the center is $r$ off every line, Pythagoras gives all six tips the same distance from the center. The "landing" is just $\sqrt{r^2 + s^2}$ agreeing with itself six times.

## What it implies, and what it only rhymes with

**A concentric pair.** $R^2 = r^2 + s^2$ says Conway's circle is the incircle with the semiperimeter *added in quadrature*. Same center; the incircle is Conway's circle with the $s$ term switched off. Two circles about one point, and the gap between them is entirely the perimeter's doing.

**A family, not a one-off.** A triangle carries a small crowd of distinguished circles: the circumcircle through its three vertices, the incircle tangent to its three sides, the nine-point circle, the three excircles, and Conway's. Three points already pin down a unique circle; three lines already pin down an incircle. The triangle is the smallest figure with enough structure to have a "center" worth arguing about — and it turns out to have several, each the center of its own circle.

**Where I'd be careful.** You raised the circle's other lives — the shape that encloses the most area for a given perimeter, the curve that is the envelope of infinitely many tangent lines while a triangle makes do with three. Those are true and lovely facts about circles, but they are not the *cause* here. Conway's circle is not the output of an optimization and not an envelope; it is six points that happen to be equidistant from the incenter. Keeping that distinction sharp is the difference between a resonance and an explanation. The honest through-line is smaller and, I think, better: three straight edges, extended by a rule that knows nothing but lengths, are already enough data to summon a curve — because a circle needs almost no data. One center, one radius. Three tangent lengths and a flat metric hand you both.

**And the plane it lives on.** "Is a triangle the simplest closed figure that can exist?" In the flat plane, essentially yes: three is the fewest sides that bound a region, and three non-collinear points determine exactly one circle — triangle and circle are paired from the start. But push the same question onto the actual sphere $S^2$ and the tidy answer frays. There is no scaling-similarity there, angles in a triangle sum to more than $\pi$, "lines" are great circles, and $r$ and $s$ stop combining by a clean $r^2 + s^2$. The Pythagorean sum of squares is a flat-space privilege. Conway's circle leans on it completely.

## Conway

John Horton Conway (1937–2020) collected constructions like this — things you can do with a pencil in ten seconds that hide a clean reason a layer down. The Game of Life is the famous one, but the instinct is the same here: a rule simple enough to hand to a child, generating structure that takes a paragraph to explain and a diagram to feel.

He apparently liked this circle enough that a proof-without-words version circulated with his name on it. Fitting. The proof really does fit in a picture: drop a perpendicular of length $r$, run a distance $s$ along the side, and the hypotenuse back to the incenter is the same length no matter which of the six tips you chose.

That is the whole secret. A triangle is just barely enough scaffolding — three tangent lengths, one incenter, one flat ruler — for a circle to have no choice but to appear.

</div>
