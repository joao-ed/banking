FROM hexpm/elixir:1.10.2-erlang-22.2.8-alpine-3.11.3


ARG PUID=1000
ARG PGID=1000
ARG HOME="/app"


RUN addgroup -g ${PGID} banking && \
    adduser -S -h ${HOME} -G banking -u ${PUID} banking

USER banking


RUN mkdir -p ${HOME}
COPY . ${HOME}
WORKDIR ${HOME}

RUN mix local.hex --force && \
    mix local.rebar --force

RUN mix deps.get && \
    mix deps.compile && \
    mix ecto.setup && \
    mix test

RUN mix phx.server
