# Lint scripts for AMWA NMOS specs

(c) AMWA 2020

This repo holds scripts used to lint documentation, RAML and JSON for NMOS specification repos.

These are invoked (using CI) on dev branches of repos.

To lint a local checkout of a spec repo with the `amwa/nmos-lint` image, mount the checkout as the working directory:

```sh
docker run --rm -v "$PWD":/repo -w /repo amwa/nmos-lint:latest
```

When the working directory does not contain `.lint/`, the image instead fetches `$GITHUB_REF` from `https://github.com/$GITHUB_REPOSITORY` and lints that.
