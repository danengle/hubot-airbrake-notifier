# Description
#   A Postman base class
HUBOT_AIRBRAKE_SUBDOMAIN = process.env.HUBOT_AIRBRAKE_SUBDOMAIN || ""

class Base
  constructor: (@req, @robot) ->
    @json  = @req.body

  room: ->
    @req.params.room || ""

  error_id: ->
    @json.error.id

  error_message: ->
    @json.error.error_message

  error_class: ->
    @json.error.error_class

  environment: ->
    @json.error.environment

  project_name: ->
    @json.error.project.name

  request_url: ->
    @json.error.last_notice.request_url

  project_id: ->
    @json.error.project.id

  backtraces: ->
    @json.error.last_notice.backtrace.slice(0, 3)

  url: ->
    "https://#{HUBOT_AIRBRAKE_SUBDOMAIN}.airbrake.io/projects/#{@project_id()}/groups/#{@error_id()}"

  notice: ->
    "[Airbrake] New alert for #{@project_name()} (#{@environment()}): #{@error_class()} (#{@url()})"

module.exports = Base
