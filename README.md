# Pastel

[![CI](https://github.com/fralps/pastel-api/actions/workflows/ci.yml/badge.svg?event=push)](https://github.com/fralps/pastel-api/actions/workflows/ci.yml) [![staging-deploy](https://github.com/fralps/pastel-api/actions/workflows/staging-deploy.yml/badge.svg?event=workflow_run)](https://github.com/fralps/pastel-api/actions/workflows/staging-deploy.yml)

*Save your wildest dreams*

- Staging url: <https://staging-pastel-front.vercel.app/>
- Production url : *coming soon*

Tech stack
-

![Ruby](https://img.shields.io/badge/Ruby_v3.3.5-%23CC342D.svg?style=flat&logo=ruby&logoColor=white) ![Rails](https://img.shields.io/badge/Rails_v7.2.1-%23CC0000.svg?style=flat&logo=ruby-on-rails&logoColor=white)
![Postgres](https://img.shields.io/badge/Postgres-%23316192.svg?style=flat&logo=postgresql&logoColor=white)
![Render](https://img.shields.io/badge/Render-%46E3B7.svg?style=flat&logo=render&logoColor=white)

Requirements
-

- Ruby version `3.3.5` (with Rbenv)
- Bundler: `gem install bundler`
- Ruby On Rails: `gem install rails`
- Foreman: `gem install foreman`

Setup
-

- Clone project: `git clone git@github.com:fralps/pastel-api.git`
- Move to folder: `cd pastel-api`
- Install dependencies: `bundle install`
- Run `reset-db` bash script to install DB, migrations and seed: `./scripts/reset-db`
- Run `dev` bash script to run both api and front-end server: `./script/dev`
- Go to `http://localhost:8080`

Testing
-

- Run tests with Rspec: `bundle exec rspec`  

ℹ️ CI / CD are running with Github Actions in `.github/workflows` folder

More
-

- In development and staging environement, emails are catched by `letter_opener` on api url with this params 👉 `/letter_opener` (ex: <http://localhost:3000/letter_opener>)
