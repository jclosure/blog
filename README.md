# Joel Blog

GitHub Pages blog powered by Jekyll.

## Local preview

This project uses the same `github-pages` gem that GitHub Pages uses in
production.

Install dependencies:

```sh
brew install ruby@3.3
export PATH="/opt/homebrew/opt/ruby@3.3/bin:/opt/homebrew/lib/ruby/gems/3.3.0/bin:$PATH"
gem install bundler -v 2.5.23
bundle _2.5.23_ install
```

Build once:

```sh
bin/jekyll build
```

Run a local preview:

```sh
bin/jekyll serve --livereload
```

Then open `http://127.0.0.1:4000/`.

## Write a post

Create a file in `_posts/` named:

`YYYY-MM-DD-title.md`

Use front matter:

```md
---
layout: post
title: "Your title"
date: 2026-03-19 22:30:00 -0500
categories: notes
---
```

Then write normal Markdown content.
