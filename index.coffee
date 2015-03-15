_ = require 'lodash'
{setForPlay, cast2char} = require './rule'
tDebug = require('debug')('t')
lDebug = require('debug')('l')
sysDebug = require('debug')('sys')
debug = (obj) ->
  return tDebug if obj?.id is 't'
  return lDebug if obj?.id is 'l'
  return sysDebug

paths = []
traceToCertainlyWin = []
deduct = (hand, p) ->
  _.forEach(p, (v) ->
     i = _.indexOf(hand, v)
     hand.splice(i, 1)
  )
  return hand
explore = (eh, lh, face, step, path) ->
  if not step?
    step = 0
  if not path?
    path = []
    eh.hand = cast2char(eh.hand)
    lh.hand = cast2char(lh.hand)
  #if face?
  #  debug(eh)(indentSpaces(step) + "#{eh.id} at step#{step} choose pass")
  #  explore(lh, eh, null, step + 1)
  for p, i in setForPlay(eh.hand, face)
    #debug()("#{eh.id} start---->") if step is 0
    clonedEh = _.cloneDeep(eh)
    deduct(clonedEh.hand, p)
    #debug(eh)(indentSpaces(step) + "#{eh.id} at step#{step} played: #{p}")
    path.push "#{eh.id}#{p}"
    if clonedEh.hand.length is 0
      #debug()("#{clonedEh.id} wins")
      path.push "#{clonedEh.id}w"
      return true
    childPath = []
    path.push childPath
    if hasToPass(lh.hand, p)
      explore(clonedEh, lh, null, step + 1, childPath)
    else
      explore(lh, clonedEh, p, step + 1, childPath)
  if step is 0
    debug()('path:' + JSON.stringify(path))
    #make sure clear
    traceToCertainlyWin = []
    findCertainlyWinNodes(path)
    return findWinPath(traceToCertainlyWin)


findCertainlyWinNodes = (path, trace) ->
  unless _.isArray(path)
    return true
  if not trace?
    trace = []
  for node, i in path when i%2 is 0
    currentTrace = _.clone(trace)
    if isCertainlyWinNode(node, path[i+1])
      currentTrace.push(node)
      debug()('found: ' + JSON.stringify(currentTrace) + ' tail: ' + JSON.stringify(path[i+1]))
      traceToCertainlyWin.push {pathToWin: currentTrace, tail: path[i+1]}
    else
      currentTrace.push(node)
      findCertainlyWinNodes(path[i+1], currentTrace)
      
#FIXME algorithm too simple
isCertainlyWinNode = (current, array) ->
  prefix = current[0]
  if _.isString(array)
    return array is "#{prefix}w" #TODO definately win if string?
  rest =  _.flattenDeep(array)
  opposite = if prefix is 't' then 'l' else 't'
  return _.indexOf(rest, "#{opposite}w") is -1

isType = (node, type) ->
  return node[0] is type

indentSpaces = (howmany) ->
  return Array(howmany + 1).join(' ')

hasToPass = (hand, face) ->
  return setForPlay(hand, face).length is 0

flatten = (h, t)->
  result = []
  _flatten = (head, tail) ->
    if not _.isArray(tail)
      head.push tail
      result.push head
      return
    for n, i in tail when i%2 is 0
      newHead = _.clone(head)
      newHead.push n
      _flatten(newHead, tail[i+1])
  _flatten(h, t)
  return result

findWinPath = (traceToCertainlyWin) ->
  grouped = _.groupBy traceToCertainlyWin, (obj) ->
    return obj.pathToWin[0]
  #find shortest path of each cluster
  for root, cluster of grouped
    len = null
    for t in cluster
      if not len? or t.pathToWin.length < len
        len = t.pathToWin.length
        grouped[root] = flatten(t.pathToWin, t.tail)
      else if t.pathToWin.length is len
        grouped[root] = grouped[root].concat(flatten(t.pathToWin, t.tail))
  #simply to array
  result = null
  for s, arr of grouped
    if not result?
      result = arr
    else
      result = result.concat arr
  #filter lose path which begin with t but end with l
  result = _.filter result, (p) ->
    return p[0][0] is p[p.length-1][0]
  debug()(JSON.stringify(result))
  return result

exports.explore = explore
exports.findCertainlyWinNodes = findCertainlyWinNodes
