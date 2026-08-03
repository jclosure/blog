---
layout: post
title: "The Staircase and the Slide"
date: 2026-07-21 00:10:00 -0500
categories: [math]
tags: ["calculus", "limits", "triangular numbers", "first principles", "integration"]
image:
  path: /assets/hero/the-staircase-and-the-slide.png
  width: 1200
  height: 630
  alt: "A coarse staircase and a finer staircase both hugging the same rising diagonal line, with amber overshoot slivers shrinking as the steps get finer"
---

<style>
.staircase-post .katex-display > .katex { font-size: 1.35em !important; }
.staircase-post .katex { font-size: 1.3em !important; }
</style>

<div class="staircase-post" markdown="1">

A staircase and a ramp can connect the same two floors. Stand at the bottom of each and they look like different ideas entirely — one moves in flat steps and sudden jumps, the other in one continuous rise. Digital and analog. Pixels and ink. A number line marked only at the integers, versus a number line with no gaps in it anywhere.

Discreteness counts. Continuity flows. They feel like two different worlds.

This post is about a place where those two worlds turn out to be the same picture, seen at two different resolutions. We won't name where we're headed just yet — better to let it arrive on its own.

## Quick recap: the staircase we already built

[Last time](/blog/2026/07/12/gauss-pascal-and-triangular-numbers/), we stacked blocks in rows — 1 block, then 2, then 3, and so on — and asked how many blocks were in the whole triangular stack.

Let's fix the names we'll reuse throughout this post:

- $n$ is how many rows we stack — how far we count up to.
- $T(n)$ is the total number of blocks once we've stacked all $n$ rows.

We found $T(n)$ by copying the stack, flipping the copy upside down, and fitting the two together into a plain rectangle:

<figure class="math-figure">
  <img src="/assets/math/gauss-pascal-triangular/triangle-rectangle-proof.svg" alt="A five-row triangular stack of blocks copied and flipped to form a five by six rectangle" />
  <figcaption>The triangular numbers, one more time: a stack of blocks is exactly half of a rectangle.</figcaption>
</figure>

A rectangle is easy: it's just rows times columns, cut in half to undo the copy:

$$
T(n) = \dfrac{n(n + 1)}{2}
$$

That's where we left off. Now we're going to take that same staircase and start shrinking its steps.

## A series is just a sum, one term at a time

Let's slow down and name a couple of things carefully before we go further.

A **sequence** is nothing more than a list of numbers, in order: $1, 2, 3, 4, 5, \dots$ That's it. No trick to it.

A **series** takes a sequence and starts adding its terms together, one at a time. If you stop after some number of terms, what you get is called a **partial sum** — the running total up to that point.

That's exactly what $T(n)$ has been the whole time, we just didn't use these words for it yet. $T(n)$ *is* the partial sum of the sequence of counting numbers, stopped after $n$ terms:

$$
T(n) = 1 + 2 + 3 + \cdots + n
$$

Nothing new has happened here. We're only putting a name on something we've already been doing since the last post.

## Watching the sum grow, one step at a time

Now let's watch what happens to that running total as one more term joins it. Two concrete partial sums, side by side:

$$
T(4) = 1+2+3+4 = 10 \qquad\qquad T(5) = 1+2+3+4+5 = 15
$$

Compare them:

$$
T(5) - T(4) = 15 - 10 = 5
$$

That's not a coincidence, and it's not special to 4 and 5. $T(5)$ is just $T(4)$ with one new term tacked on — the term $5$ itself. Of course the difference is $5$. In general, going from $n-1$ terms to $n$ terms adds exactly one new term, and that new term is $n$:

$$
T(n) - T(n-1) = n
$$

Hang on to that. **Every time $n$ goes up by one, $T(n)$ goes up by exactly $n$.**

## Difference quotients, and a staircase where h = 1

We just found something true specifically about $T$: it grows by exactly $n$ every time $n$ increases by 1. Before we go further, it's worth learning the general version of what we just did — the version that works for *any* function, not just $T$ — because we're about to reuse it on shapes and areas, too.

Here's the general setup, with no staircase in it yet. Take any function $f$. Pick some input to start from, and call it $a$ — just a placeholder name for "wherever we happen to be starting." Now take a step: move the input away from $a$ by some amount, and call the size of that step $h$. Moving the input by $h$ takes us from $a$ to $a+h$, and the function's output moves too — from $f(a)$ to $f(a+h)$.

Two new letters, both doing simple jobs: $a$ names the starting point, and $h$ names how big a step we took away from it. Neither one is tied to any particular function or number yet — they're placeholders that work the same way no matter what $f$ happens to be.

With that fully in view, here's the definition. The quantity

$$
\dfrac{f(a+h) - f(a)}{h}
$$

is called a **difference quotient**. Read the pieces separately: $f(a+h)$ is the function's value after the step, $f(a)$ is its value before the step, so $f(a+h) - f(a)$ is how much $f$ changed. Dividing by $h$ turns that change into a rate — change *per unit of input*, over a step of size $h$.

Now let's connect this back to the staircase. Our function is $T$. A moment ago, we moved from $T(n-1)$ to $T(n)$ — in the language we just built, that's starting point $a = n-1$, and step size $h = 1$, since the input moved from $n-1$ to $n$, a jump of exactly one unit. That's the only step size we'll use for most of this post: $h=1$, always, because we're only ever moving from one whole number to the very next one. Later on, we'll deliberately let $h$ shrink smaller than 1 — but not yet.

Apply the difference quotient to $T$, with $a = n-1$ and $h=1$:

$$
\dfrac{T(n) - T(n-1)}{h} = \dfrac{T(n)-T(n-1)}{1} = T(n) - T(n-1)
$$

Dividing by $h=1$ doesn't change anything — so the difference quotient of $T$ is just the plain difference we already found by hand a moment ago: $n$. Rearranged, that's the relationship we'll lean on for the rest of this post:

$$
T(n) = T(n-1) + n
$$

## The staircase is a rough sketch of a line

Picture the blocks again, but as bars: a bar of height 1, then height 2, then 3, up to height $n$. We just showed that each bar adds exactly the next counting number to the running total — a difference quotient of $n$, with $h=1$.

That "$+n$" is worth sitting with. The bars aren't growing by some rule bolted on from outside. They grow by exactly the next whole number, because whole numbers are spaced exactly 1 apart. The staircase has no choice but to look like this — it's the number line, stood up in blocks.

Now draw the line $y = x$ underneath the bars.

<figure class="math-figure">
  <img src="/assets/math/staircase-to-integral/staircase-overshoot.svg" alt="Five bars of increasing height sitting above the diagonal line y equals x, with the overshoot triangles shaded" />
  <figcaption>Each bar overshoots the line by a small triangular sliver — always the same size.</figcaption>
</figure>

The bars hug that line closely, but not perfectly. Each bar sits a little taller than the line beneath it, everywhere except at its top-right corner, where the two touch.

The gap between a bar's flat top and the line rising underneath it is a little right triangle. Every one of those triangles has legs of length 1 — the width of a bar, and the amount the line climbs across that width. Legs of 1 and 1 mean area $\dfrac{1}{2}$, every time, no matter how tall the bar is.

## Where the line was hiding

So the staircase is really two things stacked together: the region under the line, plus $n$ identical leftover slivers of area $\dfrac{1}{2}$.

Why talk about *area* at all, though? Last time, we counted blocks by stacking them, and since each block has area 1, counting blocks *was* computing area, in block-units. Nothing about that has changed. Each bar has width $h$, and right now $h=1$, so a bar of height $k$ still covers exactly $k$ square units — the same $k$ we were always adding. Summing bar areas is just another way of writing $T(n)$. It always was.

Let's find those two areas, step by step, without skipping anything.

**The region under the line.** It's a right triangle with base $n$ and height $n$, since the line runs from $(0,0)$ to $(n,n)$.

<div class="proof-sequence" markdown="1">
<div class="proof-step" markdown="1">
**The rectangle around it**

<p class="step-formula">\(n \times n = n^2\)</p>
</div>

<div class="proof-step" markdown="1">
**The triangle is half that rectangle**

<p class="step-formula">\(\dfrac{n^2}{2}\)</p>
</div>
</div>

Same halving move as the two-triangles-make-a-rectangle picture from last time — just applied to a slope instead of a stack of blocks.

**The leftover slivers.** Each one is a right triangle whose legs both equal $h$, and $h=1$ here.

<div class="proof-sequence" markdown="1">
<div class="proof-step" markdown="1">
**One sliver's legs**

<p class="step-formula">\(h = 1, \quad h = 1\)</p>
</div>

<div class="proof-step" markdown="1">
**One sliver's area**

<p class="step-formula">\(\dfrac{h \times h}{2} = \dfrac{1 \times 1}{2} = \dfrac{1}{2}\)</p>
</div>

<div class="proof-step" markdown="1">
**All $n$ slivers together**

<p class="step-formula">\(n \times \dfrac{1}{2} = \dfrac{n}{2}\)</p>
</div>
</div>

Now watch what happens when we split the formula we already had:

<div class="proof-sequence" markdown="1">
<div class="proof-step" markdown="1">
**Start from what we proved last time**

<p class="step-formula">\(T(n) = \dfrac{n(n+1)}{2}\)</p>
</div>

<div class="proof-step" markdown="1">
**Expand the numerator**

<p class="step-formula">\(T(n) = \dfrac{n^2 + n}{2}\)</p>
</div>

<div class="proof-step" markdown="1">
**Split the fraction**

<p class="step-formula">\(T(n) = \dfrac{n^2}{2} + \dfrac{n}{2}\)</p>
</div>
</div>

That split isn't a trick of algebra. It's the picture, in symbols. $\dfrac{n^2}{2}$ is the smooth triangle under the line — the one we just found by halving a rectangle. $\dfrac{n}{2}$ is the pile of leftover slivers — the one we just found by adding up $n$ little half-square triangles. Same two areas, twice now: once from the picture, once from the algebra.

Let's slow down and check that against actual numbers — the same five bars pictured above, where $n = 5$.

First, the formula from last time, plugged in directly:

$$
T(5) = \dfrac{5 \cdot 6}{2} = \dfrac{30}{2} = 15
$$

Now split that 15 the same way we just split $T(n)$ in general:

$$
T(5) = \dfrac{5^2}{2} + \dfrac{5}{2} = \dfrac{25}{2} + \dfrac{5}{2} = 12.5 + 2.5
$$

$12.5$ is the smooth triangle — five columns wide, five tall, cut in half. $2.5$ is the five little slivers, $\dfrac{1}{2}$ each, one riding on top of every bar. Add the two pieces back together and we're at 15 again, exactly where we started:

$$
12.5 + 2.5 = 15
$$

## Shrinking the grain

Natural next question: what if the steps were narrower?

Use bars of width $h$ instead of width 1 — a half, a quarter, anything smaller. Rebuild the same staircase over the same line, out of finer steps.

Each sliver is still a little right triangle between a flat step and the rising line. But now both legs have length $h$, so each sliver has area $\dfrac{h^2}{2}$. There are $\dfrac{n}{h}$ of them needed to reach all the way to $n$:

$$
\text{leftover} = \dfrac{n}{h} \cdot \dfrac{h^2}{2} = \dfrac{nh}{2}
$$

When $h = 1$, that's our familiar $\dfrac{n}{2}$. When $h = \dfrac{1}{2}$, the leftover is exactly half that. Halve $h$ again, and it halves again.

<figure class="math-figure">
  <img src="/assets/math/staircase-to-integral/shrinking-steps.svg" alt="Three staircases over the same diagonal line with step sizes one, one half, and one quarter, showing the leftover area shrinking from two to one to one half" />
  <figcaption>Narrower steps, same line, a leftover that shrinks in exact proportion to the step size.</figcaption>
</figure>

The staircase never jumps to being the line. It just hugs it more closely, and the leftover shrinks in lock step with the width of the steps. Shrink the grain by half, the leftover shrinks by half. Nothing surprising happens along the way — it just keeps going.

## Zooming in on one corner

Let's watch this happen up close. Instead of the whole staircase, zoom in on just one unit of it — the square from $x=0$ to $x=1$ — and keep refining the steps inside that same little window.

<figure class="math-figure">
  <img src="/assets/math/staircase-to-integral/zoom-sequence.svg" alt="Four panels zooming into the same unit square of the diagonal line, with step sizes one, one quarter, one sixteenth, and one sixty-fourth, showing the amber leftover thinning toward the line" />
  <figcaption>Same square, same line, four times finer each panel. The amber sliver never disappears — it just gets thinner than we can see.</figcaption>
</figure>

By the last panel, the staircase looks like a straight line. It isn't one. Zoom the image itself in far enough on that last panel and you'd still find flat treads and square corners — 64 of them, packed into one unit. No amount of shrinking $h$ ever turns a staircase into an actual, corner-free line. It's always built from flat steps and right angles, at every size.

So here's a precise way to say what *is* true: the staircase itself never becomes smooth. What shrinks to nothing is the **gap** between the staircase and the line — the amber sliver. And once that gap is gone completely, in the limit, what's left standing is smooth — not because the staircase gradually earned smoothness, step by step, but because smoothness was a property of the line all along, and the last trace of the staircase's roughness has been squeezed out from around it.

It's a bit like a photo made of large, visible pixels. Refine the resolution, and the pixels don't personally get rounder or softer — they just get smaller, and smaller, until you can no longer tell they're there. The photograph you're approximating was smooth the entire time. The blockiness was never a rival to that smoothness. It was just the resolution you happened to be looking at it with.

## What's left when the grain is gone

Let's name what we've actually been computing, because the notation is about to change and it should change for a reason we can see.

Every bar's area is height times width: $k \cdot h$. Adding up all of those bar areas is a sum:

$$
\text{staircase area} = \sum_{k=1}^{n/h} (kh)\cdot h
$$

A sum of thin rectangle areas like this, approximating the area under a line, has a name: a **Riemann sum**. It's the exact thing we've been computing this whole time — we just didn't have the word for it yet. $T(n)$ itself is a Riemann sum, the special case where $h=1$.

We already know what this particular sum equals, because we found it by hand with the sliver picture:

$$
\text{staircase area} = \dfrac{n^2}{2} + \dfrac{nh}{2}
$$

Now send $h$ toward 0. Nothing about the sum stops being a sum — it just ends up with more and more terms, each one thinner than the last. Take the limit of both sides:

$$
\lim_{h \to 0} \left( \dfrac{n^2}{2} + \dfrac{nh}{2} \right) = \dfrac{n^2}{2}
$$

since we already showed $\dfrac{nh}{2} \to 0$. That limiting value — the one left standing once the grain is gone — has its own name too: the **definite integral** of $f(x) = x$, from 0 to $n$:

$$
\int_0^n x\,dx = \dfrac{n^2}{2}
$$

The notation isn't a coincidence. $\sum$ is the Greek letter sigma, for *sum*. $\int$ is a stretched-out $S$ — Leibniz's own shorthand for *summa*, Latin for *sum*. Both symbols mean the same word. The only difference is what's being summed: $\sum$ adds up finitely many rectangles of a fixed width $h$; $\int$ is what's left in the limit, once that width has shrunk to 0. That's exactly what "$dx$" means, too — it isn't a new, mysterious infinitesimal object. It's just the name calculus gives to $h$, once $h$ has been sent to its limit. Same quantity, different alphabet.

So summation and integration were never two separate operations that happen to look alike. $\int$ *is* $\sum$, at the exact moment its rectangles become infinitely thin. Every triangular number we've ever computed was a Riemann sum — one with a step size fixed at exactly 1, instead of a step size carried all the way to the limit.

Let's slow down and look at two concrete examples, side by side, so this isn't just a claim — we can watch it happen with real numbers.

**First, $n=5$ — the case we've been picturing the whole time.** The sum is one we already know by heart:

$$
\sum_{k=1}^{5} k = 1+2+3+4+5 = 15
$$

And we've already found the integral, too, even though we didn't call it that yet. Back when we split $T(5)$ into its two pieces, the $12.5$ we found *was* this integral all along:

$$
\int_0^5 x\,dx = \dfrac{5^2}{2} = 12.5
$$

Subtract the integral from the sum:

$$
15 - 12.5 = 2.5
$$

That $2.5$ is exactly $\dfrac{n}{2}$ for $n=5$ — the same leftover we've been tracking this entire post.

**Now let's check a different $n$, so we're sure this wasn't a coincidence.** Take $n=10$. The sum:

$$
\sum_{k=1}^{10} k = 1+2+\cdots+10 = 55
$$

The integral:

$$
\int_0^{10} x\,dx = \dfrac{10^2}{2} = 50
$$

Subtract again:

$$
55 - 50 = 5
$$

And $5$ is exactly $\dfrac{n}{2}$ for $n=10$. Different $n$, same relationship, right on schedule.

Both times, the sum comes out a little bigger than the integral — by exactly $\dfrac{n}{2}$, never more, never less. The sum was never wrong. It's the integral, plus one small and completely predictable extra piece, owed entirely to the fact that we counted in whole steps of $h=1$ instead of sweeping continuously.

And now we can finally answer the question from earlier properly. **Is the "$1$" in $\dfrac{n(n+1)}{2}$ there because the counting numbers are one apart?** Yes — and now we know exactly how much of the answer that fact is responsible for. It contributes precisely $\dfrac{n}{2}$, and that whole term is the fossil of a step size of 1. Shrink the step, and the fossil shrinks with it, right on schedule, until nothing is left of it at all.

## Zero was never a destination

It's tempting to describe all this as "shrinking $h$ until it becomes infinitesimal" — some final, smallest possible step, just barely above zero.

But there's no such thing to land on. However small a step you pick, half of it is smaller still, and just as valid a step. There is no smallest positive number waiting at the bottom of that halving process.

So what is actually being approached? Zero itself. And [zero, we already established](/blog/2026/07/19/the-deep-meaning-of-zero/), isn't a quantity at all. It's the additive identity — the point on the line with no parts left to subdivide.

That's exactly why it makes a safe target for this kind of shrinking. $h$ never has to arrive at some smallest surviving crumb of size, because it was never heading toward a quantity in the first place. It's heading toward the one point that was never a quantity to begin with. The grain doesn't bottom out — it just keeps finding room to get closer to a target with no size for it to bump into.

## The tolerance game

So mathematicians don't ask "how small can $h$ get?" They ask a sharper question instead: **can the leftover be forced below any tolerance you name, no matter how demanding?**

Name a tolerance — call it $\varepsilon$. It can be as stingy as you like: a thousandth, a trillionth, anything positive. We need $\dfrac{nh}{2}$ to come in under it. Solve for $h$:

$$
\dfrac{nh}{2} < \varepsilon \quad\Longleftrightarrow\quad h < \dfrac{2\varepsilon}{n}
$$

For any $\varepsilon > 0$, choosing $h$ smaller than $\dfrac{2\varepsilon}{n}$ guarantees the leftover is smaller than $\varepsilon$. Whatever tolerance gets demanded, a step size exists that satisfies it.

That, in full, is the epsilon-delta idea. Not a smallest number — a guarantee that closeness can be forced past any bar you set, on demand, forever. It replaces "there exists an infinitesimal" with something needing no controversial number at all: "for every tolerance, a response exists." The bars in our figures were an $\varepsilon$–$\delta$ argument, drawn in color before it was ever written in symbols.

## The slide was always there

We started by asking what happens when a staircase shrinks down to nothing. The honest answer: the staircase was never the fundamental object. The slide was.

The smooth line $y=x$ and its triangular area $\dfrac{n^2}{2}$ were there from the start. The staircase was just a particular, coarse way of measuring that same area — one unit-wide sliver of overcounting at a time. Discreteness wasn't a rival to continuity. It was a grain laid on top of it, precise enough to name exactly ($\dfrac{nh}{2}$), and finable down to nothing.

It's the same reason a square's growth and a triangle's growth turn out to be relatives, not coincidences: $n^2$ is the sum of the first $n$ odd numbers, and $T(n-1) + T(n) = n^2$ splits that same square straight down its diagonal into two staircases. Every one of these formulas is a continuous curve, caught mid-pixelation, still recognizably itself underneath the grain.

The two triangles that made a rectangle, back at the start of all this, and the triangle under a line, at the end of it, are the same shape, doing the same job, at two different resolutions.

</div>
