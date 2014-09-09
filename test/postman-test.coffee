chai = require 'chai'
expect = chai.expect

process.env.HUBOT_AIRBRAKE_SUBDOMAIN = "test"
Slack = require '../src/postman/slack'
Common = require '../src/postman/common'
Postman = require '../src/postman'

describe 'Postman', ->
  describe '.create', ->
    it 'create with Common', ->
      @robot = { adapterName: 'shell' }
      @postman = Postman.create({}, @robot)
      expect(@postman).to.be.an.instanceof(Common)

    it 'create with Slack', ->
      @robot = { adapterName: 'slack' }
      @postman = Postman.create({}, @robot)
      expect(@postman).to.be.an.instanceof(Slack)
