should = require('chai').should()
{setForPlay, defeat, getPairs, getTrips, getQuads,
  getTripWithKickers, getQuadWithKickers, getStraight, getTrump} = require '../rule.coffee'

describe 'setForPlay', ->
  it 'two cards', ->
    hand = ['J', 2]
    ret = setForPlay(hand)
    ret[0].should.be.equal('2')
    ret[1].should.be.equal('J')
  it 'pair cards', ->
    hand = ['J', 'J', 2]
    ret = setForPlay(hand)
    ret[0].should.be.equal('2')
    ret[1].should.be.equal('J')
    ret[2].should.be.equal('JJ')
  it.skip '4 with 2', ->
    hand = [3, 3, 'J', 'J', 3, 3]
    ret = setForPlay(hand, [2])
    ret[0].should.be.equal('3')
    ret[1].should.be.equal('J')
    ret[2].should.be.equal('33')
    ret[3].should.be.equal('JJ')
    ret[4].should.be.equal('333')
    ret[5].should.be.equal('3333')
    ret[6].should.be.equal('333J')
    ret[7].should.be.equal('3333JJ')
  it.skip 'straingt', ->
    hand = [3, 4, 5, 6, 7]
    ret = setForPlay(hand)
    ret[0].should.be.equal('3')
    ret[1].should.be.equal('4')
    ret[2].should.be.equal('5')
    ret[3].should.be.equal('6')
    ret[4].should.be.equal('7')
    ret[5].should.be.equal('34567')

describe 'getPairs', ->
  it 'should ok with no more than 3', ->
    sorted = [2, 4, 5, 5, 'J', 'J', 'Q', 'A', 'R']
    ret = getPairs(sorted)
    ret[0].should.be.equal('55')
    ret[1].should.be.equal('JJ')
  it 'should ok with more than 3', ->
    sorted = [2, 4, 5, 5, 5, 'J', 'J', 'J', 'Q', 'A', 'R']
    ret = getPairs(sorted)
    ret[0].should.be.equal('55')
    ret[1].should.be.equal('JJ')

describe 'getTrips', ->
  it 'should find nothing', ->
    sorted = [2, 4, 5, 5, 'J', 'J', 'Q', 'A', 'R']
    ret = getTrips(sorted)
    ret.length.should.be.equal(0)
  it 'should ok with two trips', ->
    sorted = [2, 4, 5, 5, 5, 'J', 'J', 'J', 'Q', 'A', 'R']
    ret = getTrips(sorted)
    ret[0].should.be.equal('555')
    ret[1].should.be.equal('JJJ')
  it 'should ok with two trips even there`s quads', ->
    sorted = [2, 4, 5, 5, 5, 'J', 'J', 'J', 'J', 'Q', 'A', 'R']
    ret = getTrips(sorted)
    ret[0].should.be.equal('555')
    ret[1].should.be.equal('JJJ')

describe 'getQuads', ->
  it 'should find nothing', ->
    sorted = [2, 4, 5, 5, 5, 'J', 'J', 'Q', 'A', 'R']
    ret = getQuads(sorted)
    ret.length.should.be.equal(0)
  it 'should ok with two quads', ->
    sorted = [2, 4, 5, 5, 5, 5, 'J', 'J', 'J', 'J', 'Q', 'A', 'R']
    ret = getQuads(sorted)
    ret[0].should.be.equal('5555')
    ret[1].should.be.equal('JJJJ')
  it 'should ok with two quads too', ->
    sorted = [2, 4, 5, 5, 5, 'J', 'J', 'J', 'J', 'Q', 'A', 'A', 'A', 'A', 'R']
    ret = getQuads(sorted)
    ret[0].should.be.equal('JJJJ')
    ret[1].should.be.equal('AAAA')

describe 'getTripWithKickers', ->
  it 'should find nothing when only one trip', ->
    sorted = [5, 5, 5]
    ret = getTripWithKickers(sorted)
    ret.length.should.be.equal(0)
  it 'should ok with two trip with kicker', ->
    sorted = [4, 5, 5, 5, 'J', 'J']
    ret = getTripWithKickers(sorted)
    ret[0].should.be.equal('5554')
    ret[1].should.be.equal('555J')
  it 'should ok with two trip with kicker when trip is ten', ->
    sorted = [4, 'T', 'T', 'T', 'J', 'J']
    ret = getTripWithKickers(sorted)
    ret[0].should.be.equal('TTT4')
    ret[1].should.be.equal('TTTJ')
  it 'should ok with two trips even there`s quads', ->
    sorted = [2, 5, 5, 5, 'J', 'J', 'J', 'J']
    ret = getTripWithKickers(sorted)
    ret[0].should.be.equal('5552')
    ret[1].should.be.equal('555J')
    ret[2].should.be.equal('JJJ2')
    ret[3].should.be.equal('JJJ5')

describe 'getQuadWithKickers', ->
  it 'should find nothing when only one quad', ->
    sorted = [5, 5, 5, 5]
    ret = getQuadWithKickers(sorted)
    ret.length.should.be.equal(0)
  it 'should find nothing when quad with single', ->
    sorted = [5, 5, 5, 5, 'J']
    ret = getQuadWithKickers(sorted)
    ret.length.should.be.equal(0)
  it 'should ok with two quad with trip', ->
    sorted = [5, 5, 5, 5, 'J', 'J', 'J']
    ret = getQuadWithKickers(sorted)
    ret[0].should.be.equal('5555JJ')
  it 'should ok with two quads', ->
    sorted = [5, 5, 5, 5, 'J', 'J', 'J', 'J', 'A']
    ret = getQuadWithKickers(sorted)
    ret[0].should.be.equal('5555JJ')
    ret[1].should.be.equal('JJJJ55')
  it 'should ok with two quads with one pair', ->
    sorted = [5, 5, 5, 5, 'J', 'J', 'J', 'J', 'A', 'A']
    ret = getQuadWithKickers(sorted)
    ret[0].should.be.equal('5555JJ')
    ret[1].should.be.equal('5555AA')
    ret[2].should.be.equal('JJJJ55')
    ret[3].should.be.equal('JJJJAA')

describe 'getStraight', ->
  it 'should find nothing when less than five', ->
    sorted = [2, 3, 4, 5]
    ret = getStraight(sorted)
    ret.length.should.be.equal(0)
  it 'should find one', ->
    sorted = [2, 3, 4, 5, 6]
    ret = getStraight(sorted)
    ret.length.should.be.equal(1)
    ret[0].should.be.equal('23456')
  it 'should find two', ->
    sorted = [2, 3, 4, 5, 6, 6, 7]
    ret = getStraight(sorted)
    ret.length.should.be.equal(2)
    ret[0].should.be.equal('23456')
    ret[1].should.be.equal('34567')
  it 'should find two too', ->
    sorted = [2, 3, 4, 5, 6, 6, 8, 'T', 'J', 'Q', 'K', 'A']
    ret = getStraight(sorted)
    ret.length.should.be.equal(2)
    ret[0].should.be.equal('23456')
    ret[1].should.be.equal('TJQKA')
describe 'getTrump', ->
  it 'should find nothing', ->
    sorted = [4, 4, 4, 5]
    ret = getTrump(sorted)
    ret.length.should.be.equal(0)
  it 'should find one', ->
    sorted = [4, 4, 4, 5, 'B', 'R']
    ret = getTrump(sorted)
    ret.length.should.be.equal(1)
    ret[0].should.be.equal('BR')
  it 'should find two', ->
    sorted = [4, 4, 4, 4, 'J','J','J','J','B','R' ]
    ret = getTrump(sorted)
    ret.length.should.be.equal(1)
    ret[0].should.be.equal('BR')
describe 'defeat', ->
  it 'quad should not be defeated by fullhouse', ->
    sorted = [4, 4, 4, 5]
    ret = defeat('999B', '3333')
    ret.should.not.be.ok

