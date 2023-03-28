# ZeeMee Lite

This is a simple starter app for interview purposes

## Getting started with Docker

We chose to provide a docker image for this project. Development maybe be slower, but it may also be easier to get the project up and running. Feel free to set this up outside of Docker. To use Docker, install the [Docker Desktop](https://www.docker.com/products/docker-desktop/)

We have set up the following aliases... 

```
zldebug() {
  docker attach $(docker container ls | grep 'zeemee-lite-web' | grep -Eo '^[^ ]+')
}
zlbash() {
  docker exec -it $(docker container ls | grep 'zeemee-lite-web' | grep -Eo '^[^ ]+') /bin/bash
}
alias dcbuild='docker-compose build'
alias dccomp=docker-compose
alias dccon='docker-compose run web bundle exec rails c'
alias dccop='docker-compose run web rubocop'
alias dcdown='docker-compose down'
alias dcrails='docker-compose run web bundle exec rails'
alias dcrake='docker-compose run web bundle exec rake'
alias dcrspec='docker-compose run web bundle exec rspec'
alias dcup='docker-compose up'
```

### Running docker

Note: this will take a long time (5-10 minutes) the first time - but docker
will speed up after the initial installation.

```
git clone https://github.com/zeemee/zeemee-lite
cd zeemee-lite
dcbuild
dcrake db:setup
dcup
```

Open app at http://localhost:3000

If you've made changes to `db/seeds.rb` and want to regenrate data:

```
dcrake db:reset
```

If you want revert to an empty db:

```
rm -f db/schema.rb db/*.sqlite3 && dcrake db:create db:migrate
```

### Rebuilding the Docker Image

You can run `dcup --build` and it will rebuild the container when needed. This isn't much slower than just doing `dcup`

### Debugging/Bash

Make sure `dcup` is running. 

In a new terminal... 

Just place `debugger` in your code and run `zldebug`

If you need to use terminal in the container run `zlbash`

### Running tests

Make sure `dcup` is running. 

In a new terminal... `dcrspec spec` or run just one spec 
`dcrspec spec/services/feed_service_spec.rb`

### Rubcop

This is optional for this project. If you want to run rubcop: `dccop`

## Database

This is on `Sqllite`. If you would like to use a different SQL engine, feel free. This isn't covered here but would require changing docker to load required libs, etc.

## Redis

Test in code `dccon`

```
RedisHelper.set "x", "y"
RedisHelper.get "x"
"y"
```

## Sidekiq

If you want to use sidekiq for async functionalty, here's a quick example: 
this adds `Time.now.to_f` to a user name.

```
u = User.first
TestSidekiqJob.perform_async(u.id)
puts u.reload.name
```

# ZeeMee Lite Interview Coding Project

*Synopsis*:
Most social media platforms have some variation of a feed. Facebook, Twitter, Instagram, etc. We have designed a simple feed in rails that we would like you to modify to add specific features to. This is primarily designed to assess your backend coding abilities. 

### Objectives
- See how you approach problems with an existing system
- Acquire real-world code in a controlled environment
- Understand how you devise solutions
- Get a general feel for your dev velocity

### System Overview

**Stack & Frameworks**
- Rails 7
- Database: SQLite. it comes prepopulated with data for you to work with. 
- Admin Interface: Administrate.
- CSS framework: Bootstrap. 
- Rspec/FactoryBot
- Optional Service: Sidekiq, if you choose to use it.
- Optional Service: Redis. 

**System Setup**
We have created a schema, models and simple controllers for you. Here's a quick breakdown of the schema:
- Users: self-explanatory
- Orgs: Organizations that a user can belong to. In our example, these are all colleges.
- Events: These are org-generated events.
- Notifications: Various notifications a user can receive.
- Ad Units: Ads that can be shown to the user in their feed.
- Follows: A map between users who follow each other
- User Orgs: A map of orgs a user follows
- Posts: User-generated feed posts.
- Post Comments: User-generated comments on feed posts.
 
### Your Tasks

We've created a simple spec for what we want to have working that covers the basics of what we'd like to see. There are tons of solutions to this but the spec is the general scope. You probably shouldn't need to modify the spec but changes are allowed if you can justify them. 

Fix feed spec: 
* get the project running per README.md
* `spec/services/feed_service_spec.rb` is a completed spec that currently doesn't pass. Getting this spec to pass is the test.
* The UI is just there to help you out if you want it. You are not being tested on the UI. It ( `/feed` ) is an easy way to see feed results in UI and controller/api mode, test paging and see objects and object relationships. You can work entirely from console if you prefer.
* The feed must remain AREL/ActiveRecord::Relation result/return for this, that's part of the problem, and must support paging
* Doing the absolute bare minimum should take around an hour.
* Be verbose with comments to show us how you're thinking about things and to justify your decisions.

Notes:
* Feel free to do whatever you want to the code. Add gems, remove code, clean up things (this is a mock project - not real world code by any means).
* Docker: We went with Docker with this because it was the simplest setup on virtually any system we could think of. Feel free to just setup this up to run locally.
* We used SQLite to keep things simple but feel free to swap out the DB for whatever you want.

# How to submit

Send us a `diff` or a `.zip` file of the completed project. Do not `fork` this repro. 

