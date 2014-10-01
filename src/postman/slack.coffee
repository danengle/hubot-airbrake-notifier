# Description
#   A Postman Slack class
Base = require "./base"
_ = require 'underscore'

class Slack extends Base
  pretext: ->
    "[Airbrake] New alert for #{@project_name()} (#{@environment()}): #{@url()}|#{@error_class()}"

  text: ->
    if @request_url()
      "Errors on #{@request_url()}"
    else
      ""

  fields: ->
    results = [{value: @text()}, {title: @error_message()}]
    results.concat(_.map @backtraces(), (backtrace) -> { value: "» #{backtrace.replace(/\[[A-Z_]+\]\//,'')}" })

  payload: ->
    message:
      room: @room()
    content:
      pretext: @pretext()
      text: ""
      color: "danger"
      fallback: @notice()
      fields: @fields()

  notify: ->
    @robot.emit 'slack-attachment', @payload()

module.exports = Slack
