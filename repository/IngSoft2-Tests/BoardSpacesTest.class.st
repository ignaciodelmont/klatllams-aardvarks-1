Class {
	#name : #BoardSpacesTest,
	#superclass : #TestCase,
	#category : #'IngSoft2-Tests'
}

{ #category : #tests }
BoardSpacesTest >> testAMoonWalkSpaceCanHaveABackwardsValueRandom [
	self assert: ((1 to: 10) includes: MoonWalkSpace generateValidBackwardsValue).
]

{ #category : #tests }
BoardSpacesTest >> testAMoonWalkSpaceCannotHaveABackwardsValueLessThan1OrMoreThan10 [
	self
		should: [ MoonWalkSpace backwardsValue: 0 ] raise: AssertionFailure;
		should: [ MoonWalkSpace backwardsValue: 11 ] raise: AssertionFailure
]

{ #category : #tests }
BoardSpacesTest >> testAMoonWalkSpaceWithBackwardsValue4MovesPlayerBackwardsBy4 [
	| board spaces |
	spaces := {NoEffectSpace new.
	NoEffectSpace new.
	NoEffectSpace new.
	NoEffectSpace new.
	NoEffectSpace new.
	(MoonWalkSpace backwardsValue: 4)}.
	board := Board playedBy: #('hector' 'ignacio') composedBy: spaces.
	board moveAndAffect: 'hector' by: 4.
	board moveAndAffect: 'ignacio' by: 5.
	self assert: (board gameStatus positionOf: 'hector') equals: 1.
]

{ #category : #tests }
BoardSpacesTest >> testANoEffectSpaceCannotChangeAPlayerPosition [
	| board spaces |
	spaces := BoardTest createNoEffectSpacesCollection  	.
	board := Board playedBy: #('hector' 'ignacio') composedBy: spaces.
	board moveAndAffect: 'hector' by: 5.
   self assert: (board gameStatus positionOf: 'hector') equals: 6
]

{ #category : #tests }
BoardSpacesTest >> testAtomicBombSpaceAndMoveEveryOneToInitialPosition [
	| board spaces |
	spaces := {NoEffectSpace new.
	NoEffectSpace new.
	NoEffectSpace new.
	NoEffectSpace new.
	NoEffectSpace new.
	AtomicBombSpace new}.
	board := Board playedBy: #('hector' 'ignacio') composedBy: spaces.
	board moveAndAffect: 'hector' by: 4.
	board moveAndAffect: 'ignacio' by: 5.
	self
		assert: (board gameStatus positionOf: 'hector') equals: 1;
		assert: (board gameStatus positionOf: 'ignacio') equals: 1
]

{ #category : #tests }
BoardSpacesTest >> testCardSpaceAssignsACardToAPlayer [
	| spaces players board card |
	spaces := {CardSpace new.
	CardSpace new.
	CardSpace new.
	CardSpace new.
	CardSpace new.
	CardSpace new} asOrderedCollection.
	players := {Player named: 'Carrot' . Player named: 'Nacho'} asOrderedCollection .
	board := Board playedBy: players composedBy: spaces.
	(spaces first) affect: players first on: board.
	card := (players first) myCards first.
	self assert: (card owner) equals: (players first)
	
]

{ #category : #tests }
BoardSpacesTest >> testJailSpaceSendsPlayerToJail [
   | spaces players board card nacho carrot|
	spaces := {CardSpace new.
	CardSpace new.
	CardSpace new.
	CardSpace new.
	CardSpace new.
	JailSpace new} asOrderedCollection.
	carrot := Player named: 'Carrot'.
	nacho := Player named: 'Nacho'.
	players := {carrot. nacho} asOrderedCollection .
	board := Board playedBy: players composedBy: spaces.
	board moveAndAffect: carrot by: 3.
	board moveAndAffect: nacho by: 5.  
	self
		assert: (board playersInJail includes: nacho).
	
	board moveAndAffect: carrot by: 2.
	board moveAndAffect: nacho by: 3.
	
   self 
		assert: (board playersInJail includes: nacho);
		assert: (board playersInJail includes: carrot);
		assert: (board gameStatus positionOf: nacho ) equals: 6;
		assert: (board gameStatus positionOf: carrot ) equals: 6.
]

{ #category : #tests }
BoardSpacesTest >> testJailSpaceSendsPlayerToJailAndPlayerIsReleasedWithMaxRoll [
	| game playerOne playerTwo sequenceOne  diceOne spaces |
	sequenceOne := CircularIterator contains: #(1 1 1 2 10 5 3 1 6).
	diceOne := Dice
		faces: 10
		ofType: (DeterministicType rolling: sequenceOne faces: 10).

	playerOne := Player named: 'Carrot'.
	playerTwo := Player named: 'Nacho'.
	spaces := {
	NoEffectSpace new.
	JailSpace new.
	NoEffectSpace new.
	NoEffectSpace new.
	NoEffectSpace new.
	NoEffectSpace new.
	NoEffectSpace new}.
	
	game := Game playedBy: {playerOne.playerTwo} throwing: {diceOne} 
				boardComposedBy: spaces 
	   		   totalLaps: 2.
	


	game move: playerOne.
	self assert: (game gameStatus positionOf: playerOne) equals: 2.
	self assert: (game playerIsInJail: playerOne).

	game move: playerTwo.
	self assert: (game gameStatus positionOf: playerTwo) equals: 2.
	self assert: (game playerIsInJail: playerTwo).
	
	game move: playerOne.
	self assert: (game gameStatus positionOf: playerOne) equals: 2.
	self assert: (game playerIsInJail: playerOne).
	
	game move: playerTwo.
	self assert: (game gameStatus positionOf: playerTwo) equals: 2.
	self assert: (game playerIsInJail: playerTwo).
	
	"Player One roll is maximum so it's released from Jail and moves"
	game move: playerOne.
	self deny: (game playerIsInJail: playerOne).
	self assert: (game gameStatus positionOf: playerOne) equals: 5.

]

{ #category : #tests }
BoardSpacesTest >> testSpeedUpHoleSpaceAndMoveAPlayerForwardsBy4 [
	| board spaces |
	spaces := {NoEffectSpace new.
	NoEffectSpace new.
	NoEffectSpace new.
	NoEffectSpace new.
	NoEffectSpace new.
	SpeedUpSpace new}.
	board := Board playedBy: #('hector' 'ignacio') composedBy: spaces.
	board moveAndAffect: 'hector' by: 4.
	board moveAndAffect: 'ignacio' by: 5.
	self
		assert: (board gameStatus positionOf: 'hector') equals: 5;
		assert: (board gameStatus positionOf: 'ignacio') equals: 4
]

{ #category : #tests }
BoardSpacesTest >> testWarmHoleSpaceAndMoveAPlayerBackwardsBy4 [
	| board spaces |
	spaces := {NoEffectSpace new.
	NoEffectSpace new.
	NoEffectSpace new.
	NoEffectSpace new.
	NoEffectSpace new.
	WormHoleSpace new}.
	board := Board playedBy: #('hector' 'ignacio') composedBy: spaces.
	board moveAndAffect: 'hector' by: 4.
	board moveAndAffect: 'ignacio' by: 5.
	self
		assert: (board gameStatus positionOf: 'hector') equals: 5;
		assert: (board gameStatus positionOf: 'ignacio') equals: 2
]
