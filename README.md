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

1. Create payment methods '/payment_methods'
allows you to associate a credit card to an existing customer, it should be noted that said card
must be previously tokenized in the payment gateway

Request:
{
    "rider_id": 1, //id from rider in table Rier
    "token": "tok_test_44055_1299E713fbe3eae91A2eE811a0d5410f", // token from credit card
    "type": "card" // type of card, may be nequi too.
}

Response:
{
    "payment_method_id": 56043,
    "message": "payment method created"
}


gemas
	sinatra
	sequel
	sequel_enum
	httpparty
  time
  time_difference

correr las migraciones
	sequel -m db/migrations sqlite://db/rides.db

correr los seeds
	rake db:seeds

para iniciallizar la aplicacion
  $rackup ./config/config.ru

