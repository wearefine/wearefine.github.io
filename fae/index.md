---
---

Fae is CMS for Rails unlike any other. Like most Rails CMS engines, Fae provides all the basics to get you up and running: authentication, a responsive UI, form element and workflows. But unlike other CMS engines, Fae's methodology is based around generators and a DSL over configuration. This allows you to get to a working CMS very quickly, but gives you the flexibility to customize any piece you need.

Fae supports Rails >= 4.1.

## Installation

Add the gem to your Gemfile and run `bundle install`

```ruby
gem 'fae-rails'
```

Run Fae's installer

```bash
$ rails g fae:install
```

After the installer completes, visit `/admin` and setup your first user account. That should automatically log you in to your blank Fae instance.

For complete documentation, visit [Fae's GitHub page](https://github.com/wearefine/fae).