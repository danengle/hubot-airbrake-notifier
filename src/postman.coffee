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

  pretext: ->
    ""

  text: ->
    @json["error"]["error_message"]

  file: ->
    "#{@json["error"]["file"]}:#{@json["error"]["line_number"]}"

  last_occurred_at: ->
    @json["error"]["last_occurred_at"]

  message: ->
    ""

  deliver: ->
    ""


class Common extends Base
  pretext: ->
    "[Airbrake] New alert for #{@json["error"]["project"]["name"]}: #{@json["error"]["error_class"]} (#{@json["error"]["id"]})"

  message: ->
    """
    #{@pretext()}
    #{@text()}
    #{@file()}
    #{@url()}
    #{@last_occurred_at()}
    """

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
      text: @text()
      color: "danger"
      fallback: ""
      fields: [
        {title: "File", value: @file()}
        {title: "Last occurred at", value: @last_occurred_at()}
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
