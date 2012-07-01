# Twat

Like twitter? Hate GUIs? twat might be for you.

in it's simplest form, twat is a tweeting thing. I wrote it so I could
tweet from my hacktop at a conference.

```bash

twat tweet goes here.
```
simple. You'll need to hide metacharacters from your shell though. It
can also do other neat things:

You can put twat into follow mode, which is like tail -f for twitter:

```bash

twat
```

or optionionally follow a search or a hashtag

```bash

twat follow_tag #melbwebdev
```

You'll need to add your account with

```bash

twat add <username>
```

Importantly, <username> is just an internal alias, it will signin to whatever
account you login to twitter with, since it's oauth backed.

(Actually twat doesn't do lots of things, in truth, if one other person
than me finds it useful, it will have far exceeded my expections)

## Release status

Features are implemented pretty much as I see need for them, and I still
haven't put together a test suite so changes may or may not leave the code in
an inconsistent state.

Twat is feature complete enough to allow a user to send tweets without editing
a config file, but much of it's interface is missing/counterintuitive. Support
for sites other than twitter (identi.ca, for example) is planned but not
implemented.

## Credits and thanks

I used a lot the structure from codeplane to work out how to structure it. It's
obviously not as neat, but the gemspec was shamelessly adapted from codeplane

the oauth and Twitter gems saved me from actually having to do much work.

## Contact

I'm reachable at richo@psych0tik.net, and I contribute to a blog at
http://blog.psych0tik.net

## License

Twat is released under the WTFPL ( sam.zoy.org/wtfpl/ ), or, at your option the
GPLv2.

I do request that any useful changes are passed back to me so that I may
incorporate them/see what people are doing with it though.
