# hubot-airbrake-notification
[![Build Status](https://travis-ci.org/1syo/hubot-airbrake-notification.svg?branch=master)](https://travis-ci.org/1syo/hubot-airbrake-notification)
[![Coverage Status](https://coveralls.io/repos/1syo/hubot-airbrake-notification/badge.png)](https://coveralls.io/r/1syo/hubot-airbrake-notification)
[![Dependencies Status](https://david-dm.org/1syo/hubot-airbrake-notification.png)](https://david-dm.org/1syo/hubot-airbrake-notification)

A hubot script that notify to every time a new error occurs in Airbrake

See [`src/airbrake-notification.coffee`](src/airbrake-notification.coffee) for full documentation.

## Installation

Add **hubot-airbrake-notification** to your package.json:

```json
{
  "dependencies": {
    "hubot-airbrake-notification": "1syo/hubot-airbrake-notification"
  }
}
```

Then add **hubot-airbrake-notification** to your `external-scripts.json`:

```json
["hubot-airbrake-notification"]
```

Set HUBOT_AIRBRAKE_SUBDOMAIN

```
export HUBOT_AIRBRAKE_SUBDOMAIN=YOUR_SUBDOMAIN_HEARE
```
