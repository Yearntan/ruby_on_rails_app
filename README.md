# DigniSpace Application
This is a Ruby on Rails appplication for DigniSpace.

## Table of Contents

- [DigniSpace](#dignisSpace)
  - [Features](#features)
  - [Requirements](#requirements)
  - [Installation](#installation)
  - [Database Setup](#database-setup)
  - [Pre-defined Data](#pre-defined-data)
  - [Running the Application](#running-the-application)
  - [Running Tests](#running-tests)
  - [Deployment](#deployment)

## Features:
- User authentication and account management
- Provide and receive emotional support
- Responsive design for mobile and desktop

## Requirements
- Ruby 3.0.0
- Rails 7.0
- PostgreSQL 13+
- Yarn
- Redis (for background jobs)
- Bundler (for managing Ruby gems)

## Installation

1. **Clone the repository**:

    ```sh
    git clone git@git.shefcompsci.org.uk:com3420-2023-24/team22/project.git
    cd project
    ```

2. **Install the required gems**:

    ```sh
    bundle install
    ```

3. **Install JavaScript dependencies**:

    ```sh
    yarn install
    ```
3. **Set up the project**:

    ```sh
    bin/setup
    ``` 

## Database Setup

1. **Create and migrate the database**:

    ```sh
    rails db:create
    rails db:migrate
    ```

2. **(Optional) Seed the database with initial data**:

    ```sh
    rails db:seed
    ```

## Running the Application

1. **Start the Rails server**:

    ```sh
    bundle exec rails s
    ```
2. **Run the webpacker in another terminal**:

    ```sh
    bin/shakapacker-dev-server
    ```
2. **Open your browser and navigate to `http://localhost:3000`**.

3. To stop the application:
 Make sure that you log out from the application
In terminal, execute shortcut ctrl + c
```console
Ctrl + c
```

## Pre-defined data
Note: Standard usernames and passwords have been added to the database. Please see the table below:

| Types of users                   | Username                   | Password         |
| :--------------------------------| :------------------------: | :---------------:|
| Admin                            |  admin@admin.com           | admin1           |
| Supporters                       |  supporter1@test.com       | supporter        |
|                                  |  supporter2@test.com       | supporter        |
| Loved Ones                       |  friend1@test.com          | friend           |
|                                  |  friend2@test.com          | friend           |
|                                  |  friend3@test.com          | friend           |
|                                  |  friend4@test.com          | friend           |
| Young Persons                    |  yperson1@test.com         | person           |
|                                  |  yperson2@test.com         | person           |

## Running Tests

1. **Run the test suite**:

    ```sh
    rails test
    ```

2. **Run specific tests using `rails test <test_file>`**:

    ```sh
    rails test test/models/user_test.rb
    ```

## Deployment

### Prerequisites

1. **Ensure your production environment variables are set, particularly for the database and secret keys**.
2. **Set up a production database and ensure the credentials are correctly configured**.










