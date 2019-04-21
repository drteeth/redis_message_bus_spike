FROM ruby:2.5.1

ARG UID=1000
ARG GID=1000

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        redis-tools \
        build-essential \
        nodejs \
    && rm -rf /var/lib/apt/lists/*

RUN groupadd -g ${GID} -r code && useradd -u ${UID} --no-log-init -r -m -g code code \
&& chown -R code:code /home/code

WORKDIR /mnt/code
RUN chown -R code:code /mnt/code

COPY Gemfile* ./
RUN bundle install
COPY . .

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
