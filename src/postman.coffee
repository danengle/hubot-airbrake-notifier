# Description
#   A Postman build and send message.

querystring = require('querystring')
HUBOT_AIRBRAKE_SUBDOMAIN = process.env.HUBOT_AIRBRAKE_SUBDOMAIN

class Base
  constructor: (req, robot) ->
    @query = querystring.parse(req._parsedUrl.query)
    @json  = req.body
    @robot = robot

  room: ->
    @query.room || ""

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
    "[Airbrake] \##{@json["error"]["id"]} New alert for #{@json["error"]["project"]["name"]}: #{@json["error"]["error_class"]}"

  message: ->
    """
    #{this.pretext()}
    #{this.text()}
    #{this.file()}
    #{this.url()}
    #{this.last_occurred_at()}
    """

  deliver: ->
    @robot.send {room: this.room()}, this.message()


class Slack extends Base
  pretext: ->
    "[Airbrake] #{this.url()}|\##{@json["error"]["id"]} New alert for #{@json["error"]["project"]["name"]}: #{@json["error"]["error_class"]}"

  message: ->
    message:
      room: this.room()
    content:
      pretext: this.pretext()
      text: this.text()
      color: "danger"
      fallback: ""
      fields: [
        {title: "File", value: this.file()}
        {title: "Last occurred at", value: this.last_occurred_at()}
      ]

  deliver: ->
    @robot.emit 'slack-attachment', this.message()


class Postman
  @create: (req, robot) ->
    if robot.adapterName == 'slack'
      new Slack(req, robot)
    else
      new Common(req, robot)


module.exports = Postman
