# syntax=docker/dockerfile:1

# Container image that runs your code
FROM koalaman/shellcheck-alpine:latest

RUN apk update

# Common commands needed by the render scripts
RUN apk add --no-cache --update \
    bash \
    make \
    git \
    perl \
    nodejs \
    yarn

# Node modules
RUN yarn add \
    jsonlint \
    remark-cli \
    remark-preset-lint-recommended \
    remark-validate-links \
    yaml-lint

# Copy the lint script and other files
COPY scripts.mk lint.sh .remarkrc /.scripts/

# /entrypoint.sh is executed by default when the container runs
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

COPY multi-repo.sh /multi-repo.sh
