should = require('chai').should()
{explore} = require '../index.coffee'
describe 't: 2, 2, 3 vs l:5', ->
  t =
    hand: [2, 2, 3]
    id: 't'
  l =
    hand: [5]
    id: 'l'
  it 't should win', ->
    ret = explore t, l, null
    ret.length.should.be.equal(1)

describe.only 't:2, 2, A vs l: 5, 5', ->
  t =
    hand: [2, 2, 'A']
    id: 't'
  l =
    hand: [5, 5]
    id: 'l'
  it 't should win with one', ->
    ret = explore t, l, null
    ret.length.should.be.equal(2)
    ret[0].join('').should.be.equal('tAt22tw')
    ret[1].join('').should.be.equal('t2l5tAt2tw')

describe 'final', ->
  t =
    hand: [3,3,3,'T', 'T','A','A','A','A']
    #hand: [3,3,3,3,4,5,6,7,'T','T','A','A','A','A']
    id: 't'
  l =
    hand: [9,9,9,'J','J', 'B', 'R']
    id: 'l'
  it 't should win with one', ->
    ret = explore t, l, null
    ret.length.should.be.equal(4)
    ret[0].join('').should.be.equal('t5lJt8888tw')

