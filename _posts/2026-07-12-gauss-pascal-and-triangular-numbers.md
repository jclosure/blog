---
layout: post
title: "Gauss, Pascal, and Triangular Numbers"
date: 2026-07-12 23:06:00 -0500
categories: [math]
tags: ["proofs", "pascal's triangle", "triangular numbers", "gauss", "first principles"]
---

Before we talk about formulas, start with a picture.

If we stack blocks in rows of 1, then 2, then 3, and keep going, we get a triangle. Let $n$ be the number we count up to. In the picture below, $n = 5$, so the triangle has 5 rows.

$$
1 + 2 + 3 + 4 + 5
$$

The running totals show how the count grows. The dot picture shows the same thing as rows of blocks:

<div class="running-dot-grid" markdown="1">
<div class="running-total-list" markdown="1">
**Running totals**

<p class="step-formula">\(1 = 1\)</p>
<p class="step-formula">\(1 + 2 = 3\)</p>
<p class="step-formula">\(1 + 2 + 3 = 6\)</p>
<p class="step-formula">\(1 + 2 + 3 + 4 = 10\)</p>
<p class="step-formula">\(1 + 2 + 3 + 4 + 5 = 15\)</p>
<div class="running-note">15 = running total</div>
</div>

<div class="dot-triangle">
  <strong>Dot picture</strong>
  <div>&bull;</div>
  <div>&bull; &bull;</div>
  <div>&bull; &bull; &bull;</div>
  <div>&bull; &bull; &bull; &bull;</div>
  <div>&bull; &bull; &bull; &bull; &bull;</div>
  <div class="dot-note">15 dots = area \(T\)</div>
</div>
</div>

Let $T$ be the number of blocks in that triangle. Our goal is to find $T$ without counting every block one at a time.

Now make a copy of the same triangle, flip it, and put the two pieces together. The two triangles form a rectangle.

<figure class="math-figure">
  <img src="/assets/math/gauss-pascal-triangular/triangle-rectangle-proof.svg" alt="A triangular stack copied and flipped to make a rectangle" />
  <figcaption>A triangular stack is half of a rectangle.</figcaption>
</figure>

Each small block has area 1 block-unit. So counting blocks is the same as computing area in block-units.

For the example with $n = 5$, the calculation is:

<div class="proof-sequence" markdown="1">
<div class="proof-step" markdown="1">
**Rectangle area**

<p class="step-formula">\(5 \cdot 6 = 30\)</p>
</div>

<div class="proof-step" markdown="1">
**Half the rectangle**

<p class="step-formula">\(T = 30 / 2 = 15\)</p>
</div>
</div>

The picture suggests the general rule. If the triangle has $n$ rows, the doubled rectangle has $n$ rows and $n + 1$ columns. Its area is $n(n + 1)$ block-units. The triangle is half the rectangle, so:

$$
T = \frac{n(n + 1)}{2}
$$

But a picture is not quite a proof. It gives us the idea. Now we want to prove the idea with algebra.

That is where Gauss's trick comes in.

Suppose we want to add the numbers from 1 to 100. Here $n = 100$, and $T$ is the total we are trying to find:

$$
1 + 2 + 3 + \dots + 98 + 99 + 100
$$

Gauss's trick is to write the same total twice: once forward, and once backward.

$$
\begin{array}{rrrrrrrr}
T = & 1   & + 2  & + 3  & + \dots & + 98 & + 99 & + 100 \\
T = & 100 & + 99 & + 98 & + \dots & + 3  & + 2  & + 1
\end{array}
$$

Now add the two rows together. Associativity lets us group the sum by columns: first with first, second with second, third with third, and so on.

<div class="proof-sequence" markdown="1">
<div class="proof-step" markdown="1">
**Pair the columns**

<p class="step-formula">\(2T = (1 + 100) + (2 + 99) + \dots + (100 + 1)\)</p>
</div>

<div class="proof-step" markdown="1">
**Notice the repeated sum**

<p class="step-formula">\(2T = 101 + 101 + \dots + 101\)</p>
</div>

<div class="proof-step" markdown="1">
**Count the pairs**

<p class="step-formula">\(2T = 100 \cdot 101\)</p>
</div>
</div>

Each column-pair adds to 101, and there are 100 pairs. This is the same idea as the block picture: 100 rows, 101 columns, and twice the triangle.

Since $2T$ is twice the original total, divide by 2:

$$
T = \frac{100 \cdot 101}{2} = 5050
$$

The important step is not the number 5050. The important step is the pairing.

The same proof works for any $n$. Write the total forward and backward:

$$
\begin{array}{rrrrrr}
T(n) = & 1 & + 2 & + 3 & + \dots & + n \\
T(n) = & n & + (n - 1) & + (n - 2) & + \dots & + 1
\end{array}
$$

Then use associativity to group the columns into pairs:

<div class="proof-sequence" markdown="1">
<div class="proof-step" markdown="1">
**Pair the columns**

<p class="step-formula">\(2T(n) = (1 + n) + (2 + (n - 1)) + \dots + (n + 1)\)</p>
</div>

<div class="proof-step" markdown="1">
**Notice the repeated sum**

<p class="step-formula">\(2T(n) = (n + 1) + (n + 1) + \dots + (n + 1)\)</p>
</div>

<div class="proof-step" markdown="1">
**Count the pairs**

<p class="step-formula">\(2T(n) = n(n + 1)\)</p>
</div>
</div>

Every pair adds to $n + 1$, and there are $n$ pairs. Divide by 2 and we get:

$$
T(n) = \frac{n(n + 1)}{2}
$$

That proves the formula behind the rectangle picture. The algebra and the geometry are saying the same thing.

Now we can connect this to Pascal's triangle.

Pascal's triangle is built by addition. Every inside number is the sum of the two numbers above it:

$$
\begin{array}{ccccccccccc}
&&&&&1&&&&&\\
&&&&1&&1&&&&\\
&&&1&&2&&1&&&\\
&&1&&3&&3&&1&&\\
&1&&4&&6&&4&&1&\\
1&&5&&10&&10&&5&&1
\end{array}
$$

For example, the 6 is made from the two 3s above it:

$$
\begin{array}{ccccc}
& 3 && 3 &\\
& \searrow && \swarrow &\\
&& 3 + 3 = 6 &&
\end{array}
$$

The edge numbers stay 1. The inside numbers are where the adding happens.

The counting numbers appear along one diagonal:

$$
1,\ 2,\ 3,\ 4,\ 5,\ \dots
$$

The next diagonal keeps a running total of those counting numbers:

$$
1,\quad 1 + 2,\quad 1 + 2 + 3,\quad 1 + 2 + 3 + 4,\quad \dots
$$

That gives:

$$
1,\ 3,\ 6,\ 10,\ 15,\ \dots
$$

Those are the same triangular totals we just proved.
<figure class="math-figure">
  <img src="/assets/math/gauss-pascal-triangular/pascal-triangle-diagonal.svg" alt="The triangular numbers highlighted in Pascal's triangle" />
  <figcaption>The triangular numbers appear as a diagonal in Pascal's triangle.</figcaption>
</figure>

So the same idea appears in three forms:

$$
1 + 2 + 3 + 4 + 5 + 6 + \dots + n = \frac{n(n + 1)}{2}
$$

The block picture shows why the triangle is half of a rectangle. Gauss's pairing turns that picture into a proof. Pascal's triangle shows the same repeated addition hiding inside a larger pattern.
