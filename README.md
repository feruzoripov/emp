# EMP Task

REST API based implementation of EMP task

## Overview

This application uses Rails version 6.1, Ruby version 2.5

## Local setup

This application is dockerized

To run the application:
* Build `docker-compose build`
* Migrate `docker-compose run web bundle exec rails db:migrate`
* Run `docker-compose up`
* Rspecs `docker-compose run web rspec`
* Rubocop `docker-compose run web rubocop`
* Run Sidekiq for Background jobs `docker-compose run web bundle exec sidekiq`

## Create users from CSV file

* update `users.csv` file with users
* run rake task to create users: `docker-compose run web rake users:create_users`

## Create transactions as merchant

You need to authorize your user before making requests to other endpoints
* Make `POST /auth/login` request with `email` and `password` params
* You will get JWT token
* Insert token into `Authorization` header

### Get List of Transactions

* `GET /transactions`

### Create Authorize Transaction

* `POST /transactions/authorize` with the following params: `customer_email`, `customer_phone`, `amount`
* After successfull request you will get `uuid` of the Auhorize transaction

### Create Charge Transaction

* `POST /transactions/charge` with the following params: `uuid` of authorize transaction, `amount`
* After successfull request you will get `uuid` of the Charge transaction

### Create Refund Transaction

* `POST /transactions/refund` with the following params: `uuid` of charge transaction, `amount`
* After successfull request you will get `uuid` of the Charge transaction
* It changes Charge Transaction's state to `refunded`

### Create Reversal Transaction

* `POST /transactions/reverse` with the following params: `uuid` of authorize transaction
* After successfull request you will get `uuid` of the reversal transaction
* It changes Authorize Transaction's state to `reversed`


## Admin Endpoints

* To get access to admin endpoints user's `admin` attribute should be `true`

## Transactions

* Endpoints return following attributes: `uuid`, `type`, `customer_email`, `customer_phone`, `status`, `amount`, `parent_transaction_uuid`, `merchant_id`

### Get List of Authorize transactions

* `GET /admin/transactions/authorize`

### Get List of Charge transactions

* `GET /admin/transactions/charge`

### Get List of Refund transactions

* `GET /admin/transactions/refund`

### Get List of Reversal transactions

* `GET /admin/transactions/reversal`

### Get transaction by UUID

* `GET /admin/transactions/{uuid}`

### Delete Transactions created one hour before. (It runs sidekiq background job to delete transactions. You need to run sidekiq)

* `DELETE /admin/del_old`

## Users

* Endpoints return following attributes: `id`, `email`, `name`, `description`, `status`, `admin`

### Get List of users:

* `GET /admin/users`

### Get user by ID:

* `GET /admin/{id}`

### Update user:

* `PUT /admin/update/{id}` with permitted params: `name`, `email`, `description`, `status`

### Delete user:

* `DELETE /admin/user/{id}` - it will not delete user if there are active transactions for the user which is going to be deleted

