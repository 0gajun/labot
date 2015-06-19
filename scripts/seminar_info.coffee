# Descripion:
#   show today's seminar information
#
# Commands:
#   hubot Seminar

https = require "https"
cron = require('cron').CronJob
url = "https://script.google.com/macros/s/AKfycbx8q9tw9WotXTRKQNjnb6BzlkyHBzDSpmgCQwt3yNepze4wpAU/exec"

module.exports = (robot) ->
  # レスポンス用
  robot.respond /Seminar/i, (res) ->
    request res, false
  
  # Webhook用. 現在使用していない
  robot.router.post "/notification/seminar", (req, res) ->
    data = if req.body.payload? then JSON.parse req.body.payload else req.body
    notifyMsg robot, data
    res.end "OK"

  # 月曜9時に通知するCron
  cronjobMon = new cron(
    cronTime: "0 0 9 * * 1"
    start: true
    timeZone: "Asia/Tokyo"
    onTick: -> 
      request robot, true
  )

  # 金曜12時に通知するCron
  cronjobFri = new cron(
    cronTime: "0 0 12 * * 5"
    start: true
    timeZone: "Asia/Tokyo"
    onTick: ->
      request robot, true
  )

request = (r, isCron) ->
  https.get url, (response) ->
    redirUrl = response.headers.location
    redir r, redirUrl, isCron

# GoogleAppScriptでデプロイしており，対象URLにアクセスすると
# status 302で戻ってくるのでリダイレクトしなくてはならない
redir = (r, redirUrl, isCron) ->
  https.get redirUrl, (response) ->
    response.setEncoding 'utf8'
    response.on 'data', (body) ->
      json = JSON.parse(body)
      if isCron 
        notifyMsg r, json
      else
        replyMsg r, json

replyMsg = (res, json) ->
  res.send buildMsg json

notifyMsg = (robot, json) ->
  robot.messageRoom "general", buildMsg json

buildMsg = (json) ->
  if (json.title == "")
    return "本日のセミナーはありません"
  msg = "@channel: 本日のセミナー情報です\n" + json.title + "\n"
  msg += "場所:" + json.place + "\n"
  msg += "時間:" + json.start_time + "~" + json.end_time + "\n"
  return msg
