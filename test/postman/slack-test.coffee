chai = require 'chai'
sinon = require 'sinon'
chai.use require 'sinon-chai'
expect = chai.expect

process.env.HUBOT_AIRBRAKE_SUBDOMAIN = "test"
json = require '../fixture/valid.json'
Slack = require '../../src/postman/slack'

describe 'Slack', ->
  beforeEach ->
    @req = { body: json, params: { room: "general" } }
    @robot = { emit: sinon.spy() }
    @postman = new Slack(@req, @robot)

  it '#notify', ->
    @postman.notify()
    expect(@robot.emit).to.have.been.calledWith(
      'slack-attachment', @postman.payload()
    )

  it '#pretext', ->
    expect(@postman.pretext()).to.eq """
      [Airbrake] New alert for Airbrake (production): https://test.airbrake.io/projects/1055/groups/37463546|RuntimeError
    """

  it '#fields', ->
    expect(@postman.fields()).to.eql [
      {value: "Errors on http://airbrake.io:445/pages/exception_test"},
      {title: "RuntimeError: You threw an exception for testing"},
      {value: "» app/controllers/pages_controller.rb:35:in 'exception_tester'"},
      {value: "» app/middleware/conditional_heroku_nav.rb:19:in '_call'"},
      {value: "» app/middleware/conditional_heroku_nav.rb:11:in 'call_without_newrelic'"}
    ]

  it '#text', ->
    expect(@postman.text()).to.eq """
      Errors on http://airbrake.io:445/pages/exception_test
    """

  it '#payload', ->
    expect(@postman.payload().message.room).to.eq "general"
    expect(@postman.payload().content.pretext).to.eq @postman.pretext()
    expect(@postman.payload().content.fallback).to.eq @postman.notice()
    expect(@postman.payload().content.text).to.eq ""
