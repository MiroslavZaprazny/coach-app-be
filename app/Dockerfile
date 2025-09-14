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
CMD ["mix", "phx.server"]

FROM base as test
COPY . .
RUN mix deps.get
RUN mix compile
CMD ["mix", "test"]
