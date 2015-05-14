# Description 
#  TravisCI to Slack

module.exports = (robot) ->
    robot.router.post "/notification/travis", (req, res) ->
        data = if req.body.payload? then JSON.parse req.body.payload else req.body
        
        if data.status_message != "Passed" or data.branch != "master"
            return
        robot.messageRoom "ci", "ビルドが終わったよ！"
