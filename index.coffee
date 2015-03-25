_ = require 'lodash'
{setForPlay, cast2char} = require './rule'
debug = require('debug')('sys')

finalTrace = []
CHOOSE_PASS = 'p'
deduct = (hand, p) ->
  return hand if p is CHOOSE_PASS
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

  allPossibles = setForPlay(eh.hand, face)
  if face?
    allPossibles.push CHOOSE_PASS
  for p in allPossibles
    clonedEh = _.cloneDeep(eh)
    deduct(clonedEh.hand, p)
    node = {role: eh.id, play: p}
    if clonedEh.hand.length is 0
      node.winner = true
      path.push(node)
      return
    node.childPath = []
    path.push(node)
    if hasToPass(lh.hand, p)
      explore(clonedEh, lh, null, step + 1, node.childPath)
    else
      explore(lh, clonedEh, (if p is CHOOSE_PASS then null else p), step + 1, node.childPath)
    if step is 0
      finalTrace = []
      #debug('path: ' + JSON.stringify(path))
      markAllNodes(path)
      findWinTrace(path)
      if finalTrace.length > 0
        debug('final' + JSON.stringify(finalTrace))
        return finalTrace
  return []

findWinTrace = (path, trace) ->
  unless trace?
    trace = []
  earlyHand = if trace[0]? then trace[0][0] else path[0].role

  for n in path
    if n.role is earlyHand and n.inKeyPath or n.role isnt earlyHand and not n.inKeyPath
      clonedTrace = _.clone(trace)
      clonedTrace.push "#{n.role}#{n.play}"
      if n.childPath?
        findWinTrace(n.childPath, clonedTrace)
      else
        finalTrace.push clonedTrace
  return

markAllNodes = (path) ->
  for n in path
    inKeyPath(n)
    if n.childPath
      markAllNodes(n.childPath)

inKeyPath = (node) ->
  if isCertainlyWinNode(node)
    node.inKeyPath = true
    return true
  for c in node.childPath
    if inKeyPath(c)
      node.inKeyPath = c.role is node.role
      return node.inKeyPath
  if node.childPath[0].role is node.role
    node.inKeyPath = false
  else
    #if none of opponent children is inKeyPath, then current is opposte
    node.inKeyPath = true
  return node.inKeyPath

#FIXME algorithm too simple
isCertainlyWinNode = (node) ->
  return true if node.winner
  return false

hasToPass = (hand, face) ->
  return false if face is CHOOSE_PASS
  return setForPlay(hand, face).length is 0

exports.explore = explore
