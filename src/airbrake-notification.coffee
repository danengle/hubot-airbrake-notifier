# Description
#   A hubot script that does the things
#
# Configuration:
#   HUBOT_AIRBRAKE_SUBDOMAIN
#
# Notes:
#   <optional notes required for the script>
#
# Author:
#   TAKAHASHI Kazunari[takahashi@1syo.net]
Postman = require "./postman"
module.exports = (robot) ->
  robot.router.post "/#{robot.name}/airbrake", (req, res) ->
    try
      postman = Postman.create(req, robot)
      postman.deliver()
      res.end "[Airbrake] Sending message"
    catch e
      res.end "[Airbrake] #{e}"
