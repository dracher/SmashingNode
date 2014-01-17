net = require('net')

count = 0
users = {}



server = net.createServer((conn) ->
  conn.setEncoding('utf8')
  nickname = null

  broadcast = (msg, exceptMyself) ->
    for u of users
      if !exceptMyself or u != nickname
        users[u].write(msg)

  conn.write(
    "\n > welcome to node-chat!" +
    "\n > " + count + ' other people are connected at this time.' +
    "\n > please write you name and press enter: "
  )

  count++

  conn.on('close', ()->
    broadcast("#{nickname} left the room\n", true)
    count--
    delete users[nickname]
    return
  )

  conn.on('data', (data)->
    data = data.replace('\r\n', '')
    if !nickname
      if users[data]
        conn.write('nick name already in use, try again: ')
        return
      else
        nickname = data
        users[nickname] = conn

        broadcast("#{nickname} join the room\n", true)
    else
      for u of users
        if u != nickname
          users[u].write("#{nickname}: #{data}\n")
    return
  )

  return
)

server.listen(3000, ()->
  console.log("server listening on *:3000")
  return
)