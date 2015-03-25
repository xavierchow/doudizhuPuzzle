_ = require 'lodash'
map =
  'T': 10
  'J': 11
  'Q': 12
  'K': 13
  'A': 14
  'B': 15
  'R': 16

cast2point = (arrayWithString) ->
  if not _.isArray(arrayWithString)
    arrayWithString = [arrayWithString]
  _.map arrayWithString, (s) ->
    return s if not _.isString(s)
    return map[s] || parseInt(s, 10)

cast2char = (arrayWithInt) ->
  _.map arrayWithInt, (n) ->
    return n if _.isString(n)
    return n.toString()

isTrump = (p) ->
  return true if p is 'BR'
  if p.length is 4 and p[0] is p[3]
    return true
  return false

isSameType = (p, f) ->
  if p.length isnt f.length
    return false
  if p.length is 4
    pType = if p[0] isnt p[3] then '3with1' else '4'
    fType = if f[0] isnt f[3] then '3with1' else '4'
    return pType is fType
  return true

defeat = (playing, face) ->
  if not isSameType(playing, face) and not isTrump(playing)
    return false
  if isTrump(playing) and not isTrump(face)
    return true
  if isTrump(playing)
    if playing is 'BR'
      return true
    if face is 'BR'
      return false
    return cast2point(playing[0])[0] > cast2point(face[0])[0]
  return cast2point(playing[0])[0] > cast2point(face[0])[0]

###
#the face param really good here FIXME
###
setForPlay = (hand, face) ->
  sorted = _.sortBy hand, (n) ->
    if _.isString(n)
      return map[n]
    return n
  sorted = cast2char(sorted)
  unmarched = _.uniq sorted
  pairs =  getPairs(sorted)
  trips = getTrips(sorted)
  quads = getQuads(sorted)
  tripWithKickers = getTripWithKickers(sorted)
  quadWithKickers = getQuadWithKickers(sorted)
  straight = getStraight(sorted)
  trump = getTrump(sorted)
  all = trump.concat straight, quadWithKickers, tripWithKickers, quads, trips, pairs, unmarched
  if face?
    _.filter(all, (n) ->
      return defeat(n, face)
    )
  else
    if hand.length is 6 and quadWithKickers.length isnt 0
      return quadWithKickers
    if hand.length is 5 and straight.length isnt 0
      return straight
    if hand.length is 4
      return quads if quads.length isnt 0
      return tripWithKickers if tripWithKickers.length isnt 0
    if hand.length is 3 and trips.length isnt 0
      return trips
    if hand.length is 2
      return pairs if pairs.length isnt 0
      return trump if trump.length isnt 0
    return all


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
  ret = []
  # red joker with black joker is the biggest trump
  if _.indexOf(sorted, 'B') > -1 and _.indexOf(sorted, 'R') > -1
    ret.push 'BR'
  return ret
  
exports.setForPlay = setForPlay
exports.getPairs = getPairs
exports.getTrips = getTrips
exports.getQuads = getQuads
exports.getTripWithKickers = getTripWithKickers
exports.getQuadWithKickers = getQuadWithKickers
exports.getStraight = getStraight
exports.getTrump = getTrump
exports.defeat = defeat
exports.cast2char = cast2char
