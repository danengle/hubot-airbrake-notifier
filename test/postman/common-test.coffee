chai = require 'chai'
sinon = require 'sinon'
chai.use require 'sinon-chai'
expect = chai.expect

process.env.HUBOT_AIRBRAKE_SUBDOMAIN = "test"
json = require '../fixture/valid.json'
Common = require '../../src/postman/common'

describe 'Common', ->
  beforeEach ->
    @req = { body: json, params: { room: "general" } }
    @robot = { send: sinon.spy() }
    @postman = new Common(@req, @robot)

  it '#notify', ->
    @postman.notify()
    expect(@robot.send).to.have.been.calledWith(
      {room: @postman.room()}, @postman.notice()
    )
