FROM elixir:1.18.4-alpine as base

WORKDIR /app

RUN apk add build-base

RUN mix local.hex --force && \
    mix local.rebar --force

FROM base as dev
COPY mix.exs mix.lock ./
RUN mix deps.get

COPY config config
RUN mix deps.compile
COPY priv priv
COPY lib lib

RUN mix compile
# We will probably have some assets later on, so we will need to pre-compile them
# RUN mix assets.deploy || echo "No assets to deploy"
# RUN mix phx.digest
CMD ["mix", "phx.server"]

FROM base as test
ENV MIX_ENV=test
COPY mix.exs mix.lock ./
RUN mix deps.get
COPY config config
RUN mix deps.compile
COPY priv priv
COPY lib lib
COPY test test
CMD ["mix", "test"]
