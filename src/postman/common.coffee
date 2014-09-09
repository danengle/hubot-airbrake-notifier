# Description
#   A Postman Common class
Base = require "./base"
class Common extends Base
  notify: ->
    @robot.send {room: @room()}, @notice()

module.exports = Common
