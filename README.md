# demi-rides

Demi-rides is an application to register a rides from users registerd and drivers that
have already been verified. The person requesting the service (rider) must provide the current
location and destination using geographic coordinates (latitude and longitude).

With these data, the application will automatically assign the available driver in a matter of
seconds. When the driver arrives at his destination, he will terminate the service.
The application will calculate the amount defined according to the criteria of distance, time and
commission.

Demi-rides will verify if the client has a previously tokenized payment method and will proceed
to make the charge in the correspondant gateway.

Finally, the driver will be released and the transaction reference will be save for greater security.

The following endpoints allow this integration:

1. Create payment methods: **POST** '/payment_methods'

It allow to associate a credit card to an existing customer, it should be noted that said card
must be previously tokenized in the payment gateway

Request:

```js
{
    "rider_id": 1, //id from table Riders
    "token": "tok_test_44055_1299E713fbe3eae91A2eE811a0d5410f", // token from credit card
    "type": "card" // type of card, may be nequi too.
}
```

Response:

```js
{
    "payment_method_id": 56043,
    "message": "payment method created"
}
```

2. Create a ride: **POST** '/rides'

It allow to initialize a ride sending location from rider

Request:

```js
{
    "rider_id": 1,
    //initial point
    "initial_latitude": 4.811757436457297,
    "initial_longitude": -75.69131283645287,
    //arrival point
    "final_latitude": 4.8307444296552235,
    "final_longitude": -75.66706566842608
}
```

Response:

```js
{
    "ride_id": 10,
    "message": "Driver found, Say hello!! to driver_0"
}
```

3. Finish a ride: **PATCH** /rides/:ride_id/finish

It allow to end a ride the param [:ride_id] is the identifier from a ride.

Response:

```js
{
    "ride": 1,
    "transaction": "144055-1683922840-46966", //transaction reference from payment bridge
    "message": "transaction created in status PENDING"
}
```

## Install application

First at all, you need Ruby installed in your system, this app was developed in the local
environment with version 3.0.4. Then you must install the following gems, with the command
gem install:

- sinatra
- sequel
- sequel_enum
- httpparty
- time
- time_difference

Run the database migrations with the command:
  > sequel -m db/migrations sqlite://db/rides.db

To populate the database with dummy information run:
  > rake db:seeds

Finally to initialize the app run
  > $rackup ./config/config.ru

the server listen in local on <http://127.0.0.1:9292>
