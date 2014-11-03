# Description
#   A hubot script to notify a Hall.com chatroom every time a new error occurs in Airbrake
#
# Dependencies:
#   danengle/hubot-hall, danengle/node-hall-client
#
# Configuration:
#   HALL_ROOM_API_KEY
#
# Commands:
#   None
#
# URLS:
#   POST /<hubot>/airbrake/<room>
#
# Notes:
#  https://help.airbrake.io/kb/integrations/webhooks
#
# Author:
#   Dan Engle

module.exports = (robot) ->
  robot.router.post "/#{robot.name}/airbrake/:room", (req, res) ->
    try
      error = req.body.error
      message_body = "<a href=\"https://catalinamarketing.airbrake.io/projects/#{error.project.id}\">#{error.error_message}</a>"
      message_body += "<br />Occured <b>#{error.times_occured}</b> time#{if error.times_occured == 1 then '' else 's'}"

      message =
        title:"[#{error.project.name}] #{error.environment} #{error.error_class}"
        picture: "https://s3.amazonaws.com/media.catalinamarketing.com/aibrakelogo.png"
        message: message_body

      robot.send message
      res.end "[Airbrake] message received"
    catch e
      res.end "[Airbrake] #{e}"
