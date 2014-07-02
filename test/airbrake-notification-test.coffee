Robot = require("hubot/src/robot")

chai = require 'chai'
sinon = require 'sinon'
chai.use require 'sinon-chai'
expect = chai.expect
request = require 'supertest'

json = require './fixture.json'

describe 'airbrake-notification', ->
  robot = null
  beforeEach (done) ->
    robot = new Robot null, 'mock-adapter', yes, 'hubot'
    robot.adapter.on 'connected', ->
      require("../src/airbrake-notification")(robot)
      adapter = @robot.adapter
      done()
    robot.run()

  it 'should return 200', (done) ->
    request(robot.router)
      .post('/hubot/airbrake?room=general')
      .send(json)
      .set('Accept','application/json')
      .expect(200)
      .end (err, res) ->
        throw err if err
        done()

  afterEach ->
    robot.server.close()
    robot.shutdown()
