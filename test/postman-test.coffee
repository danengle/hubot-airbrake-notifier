chai = require 'chai'
sinon = require 'sinon'
chai.use require 'sinon-chai'
expect = chai.expect

process.env.HUBOT_AIRBRAKE_SUBDOMAIN = "test"
Postman = require '../src/postman'

json = require './fixture.json'

describe 'Postman', ->
  beforeEach ->
    @req =
      body: json
      params:
        room: "general"

  describe 'Common', ->
    beforeEach ->
      @robot =
        adapterName: "shell"
        send: sinon.spy()

      @postman = Postman.create(@req, @robot)

    it '#room', ->
      expect(@postman.room()).to.eq "general"

    it '#url', ->
      expect(@postman.url()).to.eq \
        "https://test.airbrake.io/projects/1055/groups/37463546"

    it "#pretext", ->
      expect(@postman.pretext()).to.eq \
        "[Airbrake] New alert for Airbrake: RuntimeError (37463546)"

    it "#text", ->
      expect(@postman.text()).to.eq \
        "RuntimeError: You threw an exception for testing"

    it "#file", ->
      expect(@postman.file()).to.eq \
        "[PROJECT_ROOT]/app/controllers/pages_controller.rb:35"

    it "#last_occurred_at", ->
      expect(@postman.last_occurred_at()).to.eq "2012-03-21T08:37:15Z"

    it "#message", ->
      expect(@postman.message()).to.eq """
        [Airbrake] New alert for Airbrake: RuntimeError (37463546)
        RuntimeError: You threw an exception for testing
        [PROJECT_ROOT]/app/controllers/pages_controller.rb:35
        https://test.airbrake.io/projects/1055/groups/37463546
        2012-03-21T08:37:15Z
      """

    it "#deliver", ->
      @postman.deliver()
      expect(@robot.send).to.have.been.calledWith(
        {room: @postman.room()}, @postman.message()
      )


  describe 'Slack', ->
    beforeEach ->
      @robot =
        adapterName: "slack"
        emit: sinon.spy()

      @postman = Postman.create(@req, @robot)

    it "#pretext", ->
      expect(@postman.pretext()).to.eq \
        "[Airbrake] New alert for Airbrake: RuntimeError (#{@postman.url()}|37463546)"

    it "#payload", ->
      expect(@postman.payload().message["room"]).to.eq "general"
      expect(@postman.payload().content["pretext"]).to.eq @postman.pretext()
      expect(@postman.payload().content["text"]).to.eq @postman.text()
      expect(@postman.payload().content["color"]).to.eq "danger"

    it "#deliver", ->
      @postman.deliver()
      expect(@robot.emit).to.have.been.calledWith(
        'slack-attachment', @postman.payload()
      )
