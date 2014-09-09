Robot = require("hubot/src/robot")

chai = require 'chai'
expect = chai.expect
request = require 'supertest'

valid_json = require './fixture/valid.json'
invalid_json = require './fixture/invalid.json'

describe 'airbrake-notifier', ->
  robot = null
  beforeEach (done) ->
    robot = new Robot null, 'mock-adapter', yes, 'hubot'
    robot.adapter.on 'connected', ->
      require("../src/airbrake-notifier")(robot)
      adapter = @robot.adapter
      done()
    robot.run()

  it 'should be valid', (done) ->
    request(robot.router)
      .post('/hubot/airbrake/general')
      .send(valid_json)
      .set('Accept','application/json')
      .end (err, res) ->
        expect(res.text).to.eq "[Airbrake] Sending message"
        throw err if err
        done()

  it 'should be invalid', (done) ->
    request(robot.router)
      .post('/hubot/airbrake/general')
      .send(invalid_json)
      .set('Accept','application/json')
      .end (err, res) ->
        expect(res.text).to.eq "[Airbrake] TypeError: Cannot read property 'project' of undefined"
        throw err if err
        done()

  afterEach ->
    robot.server.close()
    robot.shutdown()
