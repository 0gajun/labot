# Descripion:
#   show today's seminar information
#
# Commands:
#   hubot Seminar

https = require "https"
url = "https://script.google.com/macros/s/AKfycbx8q9tw9WotXTRKQNjnb6BzlkyHBzDSpmgCQwt3yNepze4wpAU/exec"

module.exports = (robot) ->
  robot.respond /Seminar/i, (res) ->
    request res
  
  robot.router.post "/notification/seminar", (req, res) ->
    data = if req.body.payload? then JSON.parse req.body.payload else req.body
    notifyMsg robot, res, data
    res.end "OK"

request = (res) ->
  https.get url, (response) ->
    redirUrl = response.headers.location
    redir res, redirUrl

# GoogleAppScriptでデプロイしており，対象URLにアクセスすると
# status 302で戻ってくるのでリダイレクトしなくてはならない
redir = (res, redirUrl) ->
  https.get redirUrl, (response) ->
    response.setEncoding 'utf8'
    response.on 'data', (body) ->
      json = JSON.parse(body)
      replyMsg res, json

replyMsg = (res, json) ->
  res.send buildMsg json

notifyMsg = (robot, res, json) ->
  robot.messageRoom "global", buildMsg json

buildMsg = (json) ->
  if (json.title == "")
    return "本日のセミナーはありません"
  msg = "本日のセミナー情報です\n" + json.title + "\n"
  msg += "場所:" + json.place + "\n"
  msg += "時間:" + json.start_time + "~" + json.end_time + "\n"
  return msg
