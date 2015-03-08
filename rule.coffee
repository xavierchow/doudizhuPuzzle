_ = require 'lodash'
map =
  'T': 10
  'J': 11
  'Q': 12
  'K': 13
  'A': 14
  'B': 15
  'R': 16

setForPlay = (hand) ->
  sorted = _.sortBy hand, (n) ->
    if _.isString(n)
      return map[n]
    return n
  sorted = cast2char(sorted)
  unmarched = _.uniq sorted
  pairs =  getPair(sorted)
  trips = getTrips(sorted)
  quads = getQuads(sorted)
  return

cast2point = (arrayWithString) ->
  _.map arrayWithString, (s) ->
    return s if not _.isString(s)
    return map[s] || parseInt(s, 10)

cast2char = (arrayWithInt) ->
  _.map arrayWithInt, (n) ->
    return n if _.isString(n)
    return n.toString()

getPairs = (sorted) ->
  return getNOfAKind(sorted, 2)

getTrips = (sorted) ->
  return getNOfAKind(sorted, 3)

getQuads = (sorted) ->
  return getNOfAKind(sorted, 4)

getNOfAKind = (sorted, n) ->
  result = []
  prefix = n - 1
  for e, i in sorted
    continue if i < prefix
    val = Array(n + 1).join("#{e}")
    if e is sorted[i-prefix] and _.indexOf(result, val) is -1
      result.push val
  return result

#e.g three J with one 9
getTripWithKickers = (sorted) ->
  sorted = cast2char(sorted)
  trips = getTrips(sorted)
  result = []
  for t in trips
    uniqed = _.uniq sorted
    kickers = _.filter uniqed, (n) ->
      return n isnt t[0]
    for k in kickers
      result.push "#{t}#{k}"
  return result

#e.g four J with two 9
getQuadWithKickers = (sorted) ->
  sorted = cast2char(sorted)
  quads = getQuads(sorted)
  pairs = getPairs(sorted)
  result = []
  for q in quads
    kickers = _.filter pairs, (n) ->
      return n[0] isnt q[0]
    for k in kickers
      result.push "#{q}#{k}"
  return result

getStraight = (sorted) ->
  result = []
  u = _.uniq sorted
  if u.length < 5
    return result
  points = cast2point(u)#points for checking straight
  for n, i in u
    if i+4 > u.length-1
      break
    if points[i+4] - points[i] is 4
      result.push "#{n}#{u[i+1]}#{u[i+2]}#{u[i+3]}#{u[i+4]}"
  return result

getTrump = (sorted) ->
  quads = getQuads(sorted)
  # red joker with black joker is the biggest trump
  if _.indexOf(sorted, 'B') > -1 and _.indexOf(sorted, 'R') > -1
    quads.push 'BR'
  return quads
  
exports.setForPlay = setForPlay
exports.getPairs = getPairs
exports.getTrips = getTrips
exports.getQuads = getQuads
exports.getTripWithKickers = getTripWithKickers
exports.getQuadWithKickers = getQuadWithKickers
exports.getStraight = getStraight
exports.getTrump = getTrump
