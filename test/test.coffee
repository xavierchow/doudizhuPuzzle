should = require('chai').should()
{explore} = require '../index.coffee'
describe 't: 2, 3 vs l:5', ->
  t =
    hand: [2, 3]
    id: 't'
  l =
    hand: [5]
    id: 'l'
  it 't should not win', ->
    ret = explore t, l, null
    ret.length.should.be.equal(0)

describe 't:2, 6 vs l: 5', ->
  t =
    hand: [2, 6]
    id: 't'
  l =
    hand: [5]
    id: 'l'
  it 't should win with one', ->
    ret = explore t, l, null
    ret.length.should.be.equal(1)
    ret[0].join('').should.be.equal('t6t2')

describe 't: 2, 9 vs l: 5, 7', ->
  t =
    hand: [2, 9]
    id: 't'
  l =
    hand: [5, 7]
    id: 'l'
  it 't should win with 3 case', ->
    ret = explore t, l, null
    ret.length.should.be.equal(3)
    ret[0].join('').should.be.equal('t2l5t9')
    ret[1].join('').should.be.equal('t2l7t9')
    ret[2].join('').should.be.equal('t9lpt2')
    ret[3].join('').should.be.equal('t9t2')

describe.only 't: 2, 3 vs l: 1, 2, 5', ->
  t =
    hand: [2, 3]
    id: 't'
  l =
    hand: [1, 2, 5]
    id: 'l'
  it 't should win with 1 case', ->
    ret = explore t, l, null
    ret.length.should.be.equal(3)
    ret[0].join('').should.be.equal('t2l5l1t3')
    ret[1].join('').should.be.equal('t2l5l2t3')
    ret[2].join('').should.be.equal('t2lpt3')

