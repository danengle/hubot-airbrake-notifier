chai = require 'chai'
expect = chai.expect

process.env.HUBOT_AIRBRAKE_SUBDOMAIN = "test"
json = require '../fixture/valid.json'
Base = require '../../src/postman/base'

describe 'Base', ->
  beforeEach ->
    @req = { body: json, params: { room: "general" } }
    @postman = new Base(@req, {})

  it '#room', ->
    expect(@postman.room()).to.eq "general"

  it '#error_id', ->
    expect(@postman.error_id()).to.eq 37463546

  it '#error_class', ->
    expect(@postman.error_class()).to.eq 'RuntimeError'

  it '#environment', ->
    expect(@postman.environment()).to.eq 'production'

  it '#project_name', ->
    expect(@postman.project_name()).to.eq 'Airbrake'

  it '#request_url', ->
    expect(@postman.request_url()).to.eq 'http://airbrake.io:445/pages/exception_test'

  it '#project_id', ->
    expect(@postman.project_id()).to.eq 1055

  it '#backtraces', ->
    expect(@postman.backtraces()).to.eql [
      '[PROJECT_ROOT]/app/controllers/pages_controller.rb:35:in \'exception_tester\'',
      '[PROJECT_ROOT]/app/middleware/conditional_heroku_nav.rb:19:in \'_call\'',
      '[PROJECT_ROOT]/app/middleware/conditional_heroku_nav.rb:11:in \'call_without_newrelic\''
    ]

  it '#url', ->
    expect(@postman.url()).to.eq """
      https://test.airbrake.io/projects/1055/groups/37463546
    """

  it "#notice", ->
    expect(@postman.notice()).to.eq """
      [Airbrake] New alert for Airbrake (production): RuntimeError (https://test.airbrake.io/projects/1055/groups/37463546)
    """
