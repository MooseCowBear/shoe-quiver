# Shoe Quiver

A full-stack Rails app for runners to keep track of their shoe mileage. 

## Features

- Stimulus controller to keep current shoes in reverse chronolocial order of their last run so as to encourage rotation
- Shoes are color coded by percentage of mileage to retirement
- An archive of past shoes so users never forget a model
- A calendar display of runs, color coded by how the run felt so users can keep an eye on early indicators of overtraining.
- Tabs to view shoes by category (i.e. daily trainer, speed, race)

## To run locally

Clone and run: 

```
bundle install
```

### Screenshots

Current rotation:

![alt text](screenshots/shoe_index_light.jpg "current shoe rotation light")

With new shoe form:

![alt text](screenshots/new_shoe_dark.jpg "current shoe rotation dark with form")

Runs page:

![alt text](screenshots/runs_index_light.jpg "runs page light")

![alt text](screenshots/runs_index_dark.jpg "runs page dark")

Archive:

![alt text](screenshots/archive_light.jpg "archive page light")

Shoe show page: 

![alt text](screenshots/shoe_show_dark.jpg "shoe show page dark")

### Built with

- Ruby on Rails
- Tailwind
- Postgresql