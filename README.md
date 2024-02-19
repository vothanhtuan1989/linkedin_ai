# README

## What is LinkedIn AI?
This application is a simple tool for analyzing your LinkedIn network. It allows you to upload a CSV file containing your LinkedIn connections and use the OpenAI API to generate insights from the data. You can explore various aspects of your network, such as the most common first name, last name, email, position, and linkedin URL of your connections. You can also ask natural language questions to the AI and get relevant answers based on your data.

## How to run on your local machine?
### Requirements
- Ruby version 3.1.2
- Rails version 7.1.3

### Steps
- Clone the code to your local machine.
```command
  git clone git@github.com:vothanhtuan1989/linkedin_ai.git
```

- Install dependencies with bundle install.
```command
  bundle install
```

- Set ENV variables on your local machine, and change some values as you wish and run it on terminal.
```command
  export OPENAI_ACCESS_TOKEN=xxx
```
or create .env in root directory with value
```command
  OPENAI_ACCESS_TOKEN=xxx
```

- Setup the database your local machine.
```command
  rails db:create db:migrate db:seed
```

- Run the server and enjoy the service.
```command
  rails server
```