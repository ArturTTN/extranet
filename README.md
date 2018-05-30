# Extranet

Ubmrella Application for using Sabre/Amadeus GDS create session/ create tokens/ search webservices.

## Requirments
Elixir ~> 1.6.0


## Usage

Basic operations:

Start apps separetly

- first app
  cd /apps/api && iex --sname api2@localhost -S mix
  run command Api.stream([%{ "driver": "", "ipcc": "", "username": "", "password": "" }])
- second app
  cd /apps/sabre && iex --sname sabre@localhost -S mix
  watch output





