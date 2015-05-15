http = require "http"

setTimeout(() -> http.get "http://sslab-hubot.herokuapp.com/notification/start",
                          (res) -> ,
           1000)

module.exports = (robot) ->
    robot.router.get "/notification/start", (req, res) ->
        robot.messageRoom "ci", "起動したよ！"
