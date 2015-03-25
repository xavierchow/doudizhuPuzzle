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

describe 't:2, 2, A vs l: 5, 5', ->
  t =
    hand: [2, 2, 'A']
    id: 't'
  l =
    hand: [5, 5]
    id: 'l'
  it 't should win with one', ->
    ret = explore t, l, null
    ret.length.should.be.equal(2)
    ret[0].join('').should.be.equal('tAt22')
    ret[1].join('').should.be.equal('t2l5tAt2')

describe.only 'final', ->
  t =
    hand: [3,3,3,'T','T','A','A','A']
    #hand: [3,3,3,3,4,5,6,7,'T','T','A','A','A']
    id: 't'
  l =
    hand: [9,9,9,'J','J','R']
    #hand: [9,9,9,'J','J','R','B']
    id: 'l'
  it 't should win with one', ->
    ret = explore l, t, null
    ret.length.should.be.equal(4)

