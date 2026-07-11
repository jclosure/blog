---
layout: post
title: "A Tiny Proof From First Principles"
date: 2026-07-11 00:43:00 -0500
categories: [math]
tags: ["pure math", "proofs", "first principles", "algebra"]
---

One of the pleasures of pure math is how far you can travel with very small tools.

Before the symbols become intimidating, before the machinery becomes elaborate, there are laws so simple they almost disappear into common sense. Two of the most important are associativity and commutativity.

Commutativity says that order does not matter for addition:

$$
x + y = y + x
$$

Associativity says that grouping does not matter for addition:

$$
(x + y) + z = x + (y + z)
$$

These are tiny statements. But they give us permission to reorganize a sum without changing its value. That permission is powerful.

Consider this identity:

$$
(a + b) + (c + d) = (a + d) + (b + c)
$$

At first glance, the right side looks like a rearrangement by instinct. But a proof should not rely on instinct. It should show exactly which moves are allowed.

Starting on the left:

$$
\begin{aligned}
(a + b) + (c + d)
&= a + \bigl(b + (c + d)\bigr) && \text{associativity} \\
&= a + \bigl((b + c) + d\bigr) && \text{associativity} \\
&= a + \bigl(d + (b + c)\bigr) && \text{commutativity} \\
&= (a + d) + (b + c) && \text{associativity}
\end{aligned}
$$

That is the whole proof.

The lovely thing is that nothing fancy happened. We did not calculate. We did not expand into a more complicated system. We simply used two first principles to move parentheses and reorder terms.

This is what makes proof feel different from arithmetic. Arithmetic often asks, "What is the answer?" Proof asks, "What transformations are legitimate?" Once the rules are clear, the path becomes visible.

In this small identity, associativity lets us change the shape of the expression. Commutativity lets us change the order. Together, they turn a rigid-looking formula into something flexible:

$$
(a + b) + (c + d)
\quad \longrightarrow \quad
(a + d) + (b + c)
$$

That flexibility is not a trick. It is structure. And much of mathematics is the art of noticing which structures give us freedom, then learning how to move beautifully inside them.
