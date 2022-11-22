FROM node:16-alpine AS installNode
WORKDIR /app
COPY package.json ./package.json
RUN yarn install

FROM ruby:3.0.0
ENV LANG C.UTF-8
ENV RAILS_ENV=development
# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1
WORKDIR /usr/src/app
COPY --from=installNode /app/node_modules ./node_modules
COPY Gemfile Gemfile.lock ./
RUN apt install libpq-dev
RUN gem install pg -v '1.4.1'
RUN apt update
RUN apt install -y nodejs
RUN bundle install

COPY . .

EXPOSE 3000
CMD ["bundle", "exec", "rails", "server" , "-b", "0.0.0.0"]

# multi container build 
# most likely to change goes on top
# line 12 is copying line 1 
# line 3 and 13 are relative files and will be in the same dir
# quad 0 goes into every user interface not just local 