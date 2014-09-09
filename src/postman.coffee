# Description
#   A Postman build and send message.

HUBOT_AIRBRAKE_SUBDOMAIN = process.env.HUBOT_AIRBRAKE_SUBDOMAIN

class Base
  constructor: (req, robot) ->
    @_room = req.params.room
    @json  = req.body
    @robot = robot

  room: ->
    @_room || ""

  url: ->
    "https://#{HUBOT_AIRBRAKE_SUBDOMAIN}.airbrake.io/projects/#{@json["error"]["project"]["id"]}/groups/#{@json["error"]["id"]}"

  subject: ->
    "[Airbrake] New alert for #{@json["error"]["project"]["name"]}: #{@json["error"]["error_class"]} (#{@json["error"]["id"]})"

  text: ->
    @json["error"]["error_message"]

  file: ->
    "#{@json["error"]["file"]}:#{@json["error"]["line_number"]}"

  last_occurred_at: ->
    @json["error"]["last_occurred_at"]

  message: ->
    """
    #{@subject()}
    » #{@text()}
    » #{@file()}
    » #{@url()}
    » #{@last_occurred_at()}
    """


class Common extends Base
  deliver: ->
    @robot.send {room: @room()}, @message()


class Slack extends Base
  pretext: ->
    "[Airbrake] New alert for #{@json["error"]["project"]["name"]}: #{@json["error"]["error_class"]} (#{@url()}|#{@json["error"]["id"]})"

  payload: ->
    message:
      room: @room()
    content:
      pretext: @pretext()
      text: ""
      color: "danger"
      fallback: @message()
      fields: [
        {title: @text(), value: @file()}
        {title: "", value: @last_occurred_at()}
      ]

  deliver: ->
    @robot.emit 'slack-attachment', @payload()


class Postman
  @create: (req, robot) ->
    if robot.adapterName == 'slack'
      new Slack(req, robot)
    else
      new Common(req, robot)


module.exports = Postman
