# Jekyll Now

## Publish your a blog post

Filename format: `/_posts/<year>-<month>-<day>-<title>.md` 

Front matter format:

```
---
layout: post
title:	"Title"
category: [Games, Programming, Networking, DOS]
excerpt: A short description of the article
image: public/images/buttons/large/ahmygod.gif
comment_id: 72374862398476
---
```

[Post template](_drafts/Template.md)

This [Markdown Cheatsheet](http://www.jekyllnow.com/Markdown-Style-Guide/) might come in handy.

> You can add additional posts in the browser on GitHub.com too!
> Just hit the + icon in `/_posts/` to create new content.
> Just make sure to include the [front-matter](http://jekyllrb.com/docs/frontmatter/) block at the top of each new blog post and make sure the post's filename is in this format: year-month-day-title.md

## Local Development

1. Install Jekyll and plug-ins in one fell swoop. `gem install github-pages` This mirrors the plug-ins used by GitHub Pages on your local machine including Jekyll, Sass, etc.
2. Clone down your fork `git clone https://github.com/yourusername/yourusername.github.io.git`
3. Serve the site and watch for markup/sass changes `jekyll serve`
4. View your website at `http://127.0.0.1:4000/`
5. Commit any changes and push everything to the master branch of your GitHub user repository. GitHub Pages will then rebuild and serve your website.

## Useful commands

* Test site locally: `jekyll s`
* Load draft posts: `jekyll s --drafts`
* Testing on WSL: `jekyll s --force_polling`
* Generate future posts: `jekyll s --future`

[Other userful commands](tools/useful_commands.md)



## Credits

- [Jekyll](https://github.com/jekyll/jekyll) - Thanks to its creators, contributors and maintainers.
- [SVG icons](https://github.com/neilorangepeel/Free-Social-Icons) - Thanks, Neil Orange Peel. They're beautiful.
- [Joel Glovier](http://joelglovier.com/writing/) - Great Jekyll articles. I used Joel's feed.xml in this repository.
- [Poole](https://github.com/poole/lanyon) - Designed the currently used theme