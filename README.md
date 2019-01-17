# texlive-in-a-box

A simple Docker container with a big TeXLive install, to allow easy testing of
document compilations with TeX engines that aren’t Tectonic.

Build it with a command like:

```
docker build --tag tlaib .
```

The resulting container expects to bind-mount a volume at the path `/work`,
which is also the initial working directory of commands launched in the
container. Typical usage might be:

```
docker run --rm -v $(pwd):/work tlaib:latest pdflatex document.tex
```

The only clever thing that this container does is that it looks at the user
and group IDs that own `/work` and runs any commands under the same UID/GID
pair. That way, the generated files will be owned by your user, not `root` as
would be the case by default. See `./entrypoint.sh` for how this works.

Because the resulting container includes a very complete TeXLive install, it
will usually weigh in at a few gigabytes.


## Legalities

Copyright 2019 Peter Williams. Licensed under the MIT License.
