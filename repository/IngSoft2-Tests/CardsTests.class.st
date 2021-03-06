Class {
	#name : #CardsTests,
	#superclass : #TestCase,
	#category : #'IngSoft2-Tests'
}

{ #category : #tests }
CardsTests >> testAccelerationCardAffectsAllPlayers [
	| game playerOne playerTwo sequenceOne sequenceTwo diceOne diceTwo spaces card |
	sequenceOne := CircularIterator contains: #(1 1 1 2 1 5 3 1 6).
	sequenceTwo := CircularIterator contains: #(1 1 1 2 2 4 1 1 6).
	diceOne := Dice faces: 10 ofType: (DeterministicType rolling: sequenceOne faces: 10).
	diceTwo := Dice faces: 12 ofType: (DeterministicType rolling: sequenceTwo faces: 12).
	playerOne := Player named: 'Carrot'.
	playerTwo := Player named: 'Nacho'.
	spaces := BoardTest createNoEffectSpacesCollection.
	game := Game
		playedBy:
			{playerOne.
			playerTwo}
		throwing:
			{diceOne.
			diceTwo}
		boardComposedBy: spaces
		totalLaps: 2.
	card := AccelerationCard ownedBy: playerOne.
	playerOne addNewCard: card.
	self assert: (game hasTheTurn: playerOne).
	game move: playerOne.
	self assert: (game gameStatus positionOf: playerOne) equals: 3.
	self assert: (game hasTheTurn: playerTwo).
	game move: playerTwo.
	self assert: (game gameStatus positionOf: playerTwo) equals: 3.
	self assert: (game hasTheTurn: playerOne).
	playerOne play: playerOne myCards first in: game.
	game move: playerOne.
	self assert: (game gameStatus positionOf: playerOne) equals: 6
]

{ #category : #tests }
CardsTests >> testCancellationCanBeDoneIfAtLeast1PermanentCardIsActive [
	| game playerOne playerTwo sequenceOne sequenceTwo diceOne diceTwo spaces card cancellationCard |
	sequenceOne := CircularIterator contains: #(1 1 1 2 1 5 3 1 6).
	sequenceTwo := CircularIterator contains: #(1 1 1 2 2 4 1 1 6).
	diceOne := Dice faces: 10 ofType: (DeterministicType rolling: sequenceOne faces: 10).
	diceTwo := Dice faces: 12 ofType: (DeterministicType rolling: sequenceTwo faces: 12).
	playerOne := Player named: 'Carrot'.
	playerTwo := Player named: 'Nacho'.
	spaces := BoardTest createNoEffectSpacesCollection.
	game := Game
		playedBy:
			{playerOne.
			playerTwo}
		throwing:
			{diceOne.
			diceTwo}
		boardComposedBy: spaces
		totalLaps: 2.
	card := SpeedCard ownedBy: playerOne.
	cancellationCard := CancellationCard ownedBy: playerTwo.
	playerOne addNewCard: card.
	playerTwo addNewCard: cancellationCard.
	self
		should: [ playerTwo play: cancellationCard in: game cancelling: card ]
			raise: AssertionFailure
			withExceptionDo: [ :signal | 
			self
				assert: signal messageText
				equals: 'You cannot play a canceling card when there are no active cards.' ];
		assert: (game hasTheTurn: playerOne).
	game move: playerOne.
	self assert: (game gameStatus positionOf: playerOne) equals: 3.
	self assert: (game hasTheTurn: playerTwo).
	game move: playerTwo.
	self assert: (game gameStatus positionOf: playerTwo) equals: 3.
	self assert: (game hasTheTurn: playerOne).
	playerOne play: card in: game affecting: playerTwo.
	playerTwo play: cancellationCard in: game cancelling: card.
	game move: playerOne.
	self assert: (game gameStatus positionOf: playerOne) equals: 5.
	self assert: (game hasTheTurn: playerTwo).
	game move: playerTwo.
	self assert: (game gameStatus positionOf: playerTwo) equals: 7
]

{ #category : #tests }
CardsTests >> testCancellationCanBeDoneOnlyWithTheRightCard [
	| game playerOne playerTwo sequenceOne sequenceTwo diceOne diceTwo spaces acellerationCard speedUpCard |
	sequenceOne := CircularIterator contains: #(1 1 1 2 1 5 3 1 6).
	sequenceTwo := CircularIterator contains: #(1 1 1 2 2 4 1 1 6).
	diceOne := Dice faces: 10 ofType: (DeterministicType rolling: sequenceOne faces: 10).
	diceTwo := Dice faces: 12 ofType: (DeterministicType rolling: sequenceTwo faces: 12).
	playerOne := Player named: 'Carrot'.
	playerTwo := Player named: 'Nacho'.
	spaces := BoardTest createNoEffectSpacesCollection.
	game := Game
		playedBy:
			{playerOne.
			playerTwo}
		throwing:
			{diceOne.
			diceTwo}
		boardComposedBy: spaces
		totalLaps: 2.
	acellerationCard := AccelerationCard ownedBy: playerOne.
	playerOne addNewCard: acellerationCard.
	speedUpCard := SpeedCard ownedBy: playerTwo.
	playerTwo addNewCard: speedUpCard.
	self assert: (game hasTheTurn: playerOne).
	playerOne play: acellerationCard in: game.
	game move: playerOne.
	self
		assert: (game gameStatus positionOf: playerOne) equals: 4;
		assert: (game hasTheTurn: playerTwo);
		should: [ playerTwo play: speedUpCard in: game cancelling: acellerationCard ]
			raise: AssertionFailure
			withExceptionDo:
		 [ :signal | self assert: signal messageText equals: 'This card cannot cancel another card' ].
	game move: playerTwo.
	self assert: (game gameStatus positionOf: playerTwo) equals: 4
]

{ #category : #tests }
CardsTests >> testCancellationCardAffectsAnotherCard [
	| game playerOne playerTwo sequenceOne sequenceTwo diceOne diceTwo spaces card cancellationCard |
	sequenceOne := CircularIterator contains: #(1 1 1 2 1 5 3 1 6).
	sequenceTwo := CircularIterator contains: #(1 1 1 2 2 4 1 1 6).
	diceOne := Dice faces: 10 ofType: (DeterministicType rolling: sequenceOne faces: 10).
	diceTwo := Dice faces: 12 ofType: (DeterministicType rolling: sequenceTwo faces: 12).
	playerOne := Player named: 'Carrot'.
	playerTwo := Player named: 'Nacho'.
	spaces := BoardTest createNoEffectSpacesCollection.
	game := Game
		playedBy:
			{playerOne.
			playerTwo}
		throwing:
			{diceOne.
			diceTwo}
		boardComposedBy: spaces
		totalLaps: 2.
	card := SpeedCard ownedBy: playerOne.
	cancellationCard := CancellationCard ownedBy: playerTwo.
	playerOne addNewCard: card.
	playerTwo addNewCard: cancellationCard.
	self assert: (game hasTheTurn: playerOne).
	game move: playerOne.
	self assert: (game gameStatus positionOf: playerOne) equals: 3.
	self assert: (game hasTheTurn: playerTwo).
	game move: playerTwo.
	self assert: (game gameStatus positionOf: playerTwo) equals: 3.
	self assert: (game hasTheTurn: playerOne).
	playerOne play: playerOne myCards first in: game affecting: playerTwo.
	playerTwo
		play: (playerTwo myCards first)
		in: game
		cancelling: (game activeCardsInfo first card).
	game move: playerOne.
	self assert: (game gameStatus positionOf: playerOne) equals: 5.
	self assert: (game hasTheTurn: playerTwo).
	game move: playerTwo.
	self assert: (game gameStatus positionOf: playerTwo) equals: 7
]

{ #category : #tests }
CardsTests >> testOverloadCardAffectsAPlayer [
	| game playerOne playerTwo sequenceOne sequenceTwo diceOne diceTwo spaces card |
	sequenceOne := CircularIterator contains: #(1 1 1 2 1 5 3 1 6).
	sequenceTwo := CircularIterator contains: #(1 1 1 2 2 4 1 1 6).
	diceOne := Dice faces: 10 ofType: (DeterministicType rolling: sequenceOne faces: 10).
	diceTwo := Dice faces: 12 ofType: (DeterministicType rolling: sequenceTwo faces: 12).
	playerOne := Player named: 'Carrot'.
	playerTwo := Player named: 'Nacho'.
	spaces := BoardTest createNoEffectSpacesCollection.
	game := Game
		playedBy:
			{playerOne.
			playerTwo}
		throwing:
			{diceOne.
			diceTwo}
		boardComposedBy: spaces
		totalLaps: 2.
	card := OverloadCard ownedBy: playerOne.
	playerOne addNewCard: card.
	self assert: (game hasTheTurn: playerOne).
	game move: playerOne.
	self assert: (game gameStatus positionOf: playerOne) equals: 3.
	self assert: (game hasTheTurn: playerTwo).
	game move: playerTwo.
	self assert: (game gameStatus positionOf: playerTwo) equals: 3.
	self assert: (game hasTheTurn: playerOne).
	playerOne play: playerOne myCards first in: game affecting: playerTwo.
	game move: playerOne.
	self assert: (game gameStatus positionOf: playerOne) equals: 5.
	self assert: (game hasTheTurn: playerTwo).
	game move: playerTwo.
	self assert: (game gameStatus positionOf: playerTwo) equals: 5
]

{ #category : #tests }
CardsTests >> testPermanentCardCanBeUsedOnlyOnPlayerTurn [
	| game playerOne playerTwo sequenceOne sequenceTwo diceOne diceTwo spaces card |
	sequenceOne := CircularIterator contains: #(1 1 1 2 1 5 3 1 6).
	sequenceTwo := CircularIterator contains: #(1 1 1 2 2 4 1 1 6).
	diceOne := Dice faces: 10 ofType: (DeterministicType rolling: sequenceOne faces: 10).
	diceTwo := Dice faces: 12 ofType: (DeterministicType rolling: sequenceTwo faces: 12).
	playerOne := Player named: 'Carrot'.
	playerTwo := Player named: 'Nacho'.
	spaces := BoardTest createNoEffectSpacesCollection.
	game := Game playedBy: {playerOne.playerTwo} throwing:{diceOne.diceTwo} boardComposedBy: spaces totalLaps: 2.
	
	card := SpeedCard ownedBy: playerOne.
	playerOne addNewCard: card.
	
	self assert: (game hasTheTurn: playerOne).
	game move: playerOne.
	self
		assert: (game gameStatus positionOf: playerOne) equals: 3;
		assert: (game hasTheTurn: playerTwo);
		should: [ playerOne play: card in: game affecting: playerTwo ]
			raise: AssertionFailure
			withExceptionDo: [ :signal | self assert: signal messageText equals: 'You cannot play a permanent card right now' ].
	
	card := AccelerationCard ownedBy: playerOne.
	playerOne addNewCard: card.
	
	self
		assert: (game gameStatus positionOf: playerOne) equals: 3;
		assert: (game hasTheTurn: playerTwo);
		should: [ playerOne play: card in: game affecting: playerTwo ]
			raise: AssertionFailure
			withExceptionDo: [ :signal | self assert: signal messageText equals: 'You cannot play a permanent card right now' ].
			
	card := OverloadCard ownedBy: playerOne.
	playerOne addNewCard: card.
	
	self
		assert: (game gameStatus positionOf: playerOne) equals: 3;
		assert: (game hasTheTurn: playerTwo);
		should: [ playerOne play: card in: game affecting: playerTwo ]
			raise: AssertionFailure
			withExceptionDo: [ :signal | self assert: signal messageText equals: 'You cannot play a permanent card right now' ].
]

{ #category : #tests }
CardsTests >> testRedoAccelerationCard [
	| game playerOne playerTwo sequenceOne sequenceTwo diceOne diceTwo spaces card redoCard |
	sequenceOne := CircularIterator contains: #(1 1 1 2 1 5 3 1 6).
	sequenceTwo := CircularIterator contains: #(1 1 1 2 2 4 1 1 6).
	diceOne := Dice faces: 10 ofType: (DeterministicType rolling: sequenceOne faces: 10).
	diceTwo := Dice faces: 12 ofType: (DeterministicType rolling: sequenceTwo faces: 12).
	playerOne := Player named: 'Carrot'.
	playerTwo := Player named: 'Nacho'.
	spaces := BoardTest createNoEffectSpacesCollection.
	game := Game
		playedBy:
			{playerOne.
			playerTwo}
		throwing:
			{diceOne.
			diceTwo}
		boardComposedBy: spaces
		totalLaps: 2.
	redoCard := RedoCard ownedBy: playerOne.
	playerOne addNewCard: redoCard.
	card := AccelerationCard ownedBy: playerOne.
	playerOne addNewCard: card.
	self assert: (game hasTheTurn: playerOne).
	game move: playerOne.
	self assert: (game gameStatus positionOf: playerOne) equals: 3.
	self assert: (game hasTheTurn: playerTwo).
	game move: playerTwo.
	self assert: (game gameStatus positionOf: playerTwo) equals: 3.
	self assert: (game hasTheTurn: playerOne).
	playerOne play: playerOne myCards first in: game.
	game move: playerOne.
	playerOne play: playerOne myCards first in: game.
	self assert: (game gameStatus positionOf: playerOne) equals: 6.
	self assert: (game hasTheTurn: playerTwo).
	game move: playerTwo.
	self assert: (game gameStatus positionOf: playerTwo) equals: 1
]

{ #category : #tests }
CardsTests >> testRedoCancellationCard [
	| game playerOne playerTwo sequenceOne sequenceTwo diceOne diceTwo spaces cancellingCard redoCard speedCard overloadCard |
	sequenceOne := CircularIterator contains: #(1 1 1 2 1 5 3 1 6).
	sequenceTwo := CircularIterator contains: #(1 1 1 2 2 4 1 1 6).
	diceOne := Dice faces: 10 ofType: (DeterministicType rolling: sequenceOne faces: 10).
	diceTwo := Dice faces: 12 ofType: (DeterministicType rolling: sequenceTwo faces: 12).
	playerOne := Player named: 'Carrot'.
	playerTwo := Player named: 'Nacho'.
	spaces := {BoardTest createNoEffectSpacesCollection.
	SpeedUpSpace new} flattened.
	game := Game
		playedBy:
			{playerOne.
			playerTwo}
		throwing:
			{diceOne.
			diceTwo}
		boardComposedBy: spaces
		totalLaps: 2.
	redoCard := RedoCard ownedBy: playerOne.
	playerOne addNewCard: redoCard.
	speedCard := SpeedCard ownedBy: playerOne.
	playerOne addNewCard: speedCard.
	cancellingCard := CancellationCard ownedBy: playerTwo.
	playerTwo addNewCard: cancellingCard.
	overloadCard := OverloadCard ownedBy: playerTwo.
	playerTwo addNewCard: overloadCard.
	self assert: (game hasTheTurn: playerOne).
	playerOne play: playerOne myCards first in: game affecting: playerTwo.
	game move: playerOne.
	self assert: (game gameStatus positionOf: playerOne) equals: 3.
	self assert: (game hasTheTurn: playerTwo).
	playerTwo play: playerTwo myCards first in: game affecting: playerOne.
	game move: playerTwo.
	self assert: (game gameStatus positionOf: playerTwo) equals: 4.
	self assert: (game hasTheTurn: playerOne).
	playerTwo
		play: playerTwo myCards first
		in: game
		cancelling: game activeCardsInfo first card.
	game move: playerOne.
	playerOne
		play: playerOne myCards first
		in: game
		cancelling: game activeCardsInfo first card.
	self assert: (game gameStatus positionOf: playerOne) equals: 3.
	self assert: (game hasTheTurn: playerTwo).
	game move: playerTwo.
	self assert: (game gameStatus positionOf: playerTwo) equals: 8.
	self assert: (game hasTheTurn: playerOne).
	game move: playerOne.
	self assert: (game gameStatus positionOf: playerOne) equals: 6
]

{ #category : #tests }
CardsTests >> testRedoOnlyCanBeUsedIfAnotherCardWasPlayed [
	| game playerOne playerTwo sequenceOne sequenceTwo diceOne diceTwo spaces redoCard |
	sequenceOne := CircularIterator contains: #(1 1 1 2 1 5 3 1 6).
	sequenceTwo := CircularIterator contains: #(1 1 1 2 2 4 1 1 6).
	diceOne := Dice faces: 10 ofType: (DeterministicType rolling: sequenceOne faces: 10).
	diceTwo := Dice faces: 12 ofType: (DeterministicType rolling: sequenceTwo faces: 12).
	playerOne := Player named: 'Carrot'.
	playerTwo := Player named: 'Nacho'.
	spaces := BoardTest createNoEffectSpacesCollection.
	game := Game
		playedBy:
			{playerOne.
			playerTwo}
		throwing:
			{diceOne.
			diceTwo}
		boardComposedBy: spaces
		totalLaps: 2.
	redoCard := RedoCard ownedBy: playerOne.
	playerOne addNewCard: redoCard.
	self
		should: [ playerOne play: redoCard in: game affecting: playerTwo ]
		raise: AssertionFailure
		withExceptionDo:
			[ :signal | self assert: signal messageText equals: 'Redo can be used if a Card was Used' ]
]

{ #category : #tests }
CardsTests >> testRedoOveloadCard [
	| game playerOne playerTwo sequenceOne sequenceTwo diceOne diceTwo spaces card redoCard |
	sequenceOne := CircularIterator contains: #(1 1 1 2 1 5 3 1 6).
	sequenceTwo := CircularIterator contains: #(1 1 1 2 2 4 1 1 6).
	diceOne := Dice faces: 10 ofType: (DeterministicType rolling: sequenceOne faces: 10).
	diceTwo := Dice faces: 12 ofType: (DeterministicType rolling: sequenceTwo faces: 12).
	playerOne := Player named: 'Carrot'.
	playerTwo := Player named: 'Nacho'.
	spaces := BoardTest createNoEffectSpacesCollection.
	game := Game
		playedBy:
			{playerOne.
			playerTwo}
		throwing:
			{diceOne.
			diceTwo}
		boardComposedBy: spaces
		totalLaps: 2.
	redoCard := RedoCard ownedBy: playerOne.
	playerOne addNewCard: redoCard.
	card := OverloadCard ownedBy: playerOne.
	playerOne addNewCard: card.
	self assert: (game hasTheTurn: playerOne).
	game move: playerOne.
	self assert: (game gameStatus positionOf: playerOne) equals: 3.
	self assert: (game hasTheTurn: playerTwo).
	game move: playerTwo.
	self assert: (game gameStatus positionOf: playerTwo) equals: 3.
	self assert: (game hasTheTurn: playerOne).
	playerOne play: playerOne myCards first in: game affecting: playerTwo.
	game move: playerOne.
	playerOne play: playerOne myCards first in: game affecting: playerTwo.
	self assert: (game gameStatus positionOf: playerOne) equals: 5.
	self assert: (game hasTheTurn: playerTwo).
	game move: playerTwo.
	self assert: (game gameStatus positionOf: playerTwo) equals: 3
]

{ #category : #tests }
CardsTests >> testRedoRedoAccelerationCard [
	| game playerOne playerTwo sequenceOne sequenceTwo diceOne diceTwo spaces card redoCard anotherRedo |
	sequenceOne := CircularIterator contains: #(1 1 1 2 1 5 3 1 6).
	sequenceTwo := CircularIterator contains: #(1 1 1 2 2 4 1 1 6).
	diceOne := Dice faces: 10 ofType: (DeterministicType rolling: sequenceOne faces: 10).
	diceTwo := Dice faces: 12 ofType: (DeterministicType rolling: sequenceTwo faces: 12).
	playerOne := Player named: 'Carrot'.
	playerTwo := Player named: 'Nacho'.
	spaces := BoardTest createNoEffectSpacesCollection.
	game := Game
		playedBy:
			{playerOne.
			playerTwo}
		throwing:
			{diceOne.
			diceTwo}
		boardComposedBy: spaces
		totalLaps: 2.
	redoCard := RedoCard ownedBy: playerOne.
	anotherRedo := RedoCard ownedBy: playerOne.
	playerOne addNewCard: redoCard.
	playerOne addNewCard: anotherRedo.
	card := AccelerationCard ownedBy: playerOne.
	playerOne addNewCard: card.
	self assert: (game hasTheTurn: playerOne).
	playerOne play: card in: game.
	playerOne play: redoCard  in:  game.
	playerOne play: anotherRedo in: game.
	game move: playerOne.
	self assert: (game gameStatus positionOf: playerOne) equals: 6.
	
]

{ #category : #tests }
CardsTests >> testRedoRedoRepeatCard [
	| game playerOne playerTwo sequenceOne sequenceTwo diceOne diceTwo spaces card redoCard anotherRedoCard|
	sequenceOne := CircularIterator contains: #(7 1 1 2 1 5 3 1 6).
	sequenceTwo := CircularIterator contains: #(1 1 1 2 2 4 1 1 6).
	diceOne := Dice faces: 10 ofType: (DeterministicType rolling: sequenceOne faces: 10).
	diceTwo := Dice faces: 12 ofType: (DeterministicType rolling: sequenceTwo faces: 12).
	playerOne := Player named: 'Carrot'.
	playerTwo := Player named: 'Nacho'.
	spaces := {BoardTest createNoEffectSpacesCollection.
	SpeedUpSpace new} flattened.
	game := Game
		playedBy:
			{playerOne.
			playerTwo}
		throwing:
			{diceOne.
			diceTwo}
		boardComposedBy: spaces
		totalLaps: 2.
	redoCard := RedoCard ownedBy: playerOne.
	anotherRedoCard := RedoCard ownedBy: playerOne.
	playerOne addNewCard: redoCard.
	playerOne addNewCard: anotherRedoCard.
	card := RepeatCard ownedBy: playerOne.
	playerOne addNewCard: card.
	
	self assert: (game hasTheTurn: playerOne).
	game move: playerOne.
	self assert: (game gameStatus positionOf: playerOne) equals: 4.
	playerOne play: card in: game affecting: playerOne.
	self assert: (game gameStatus positionOf: playerOne) equals: 8.
	playerOne play: redoCard in: game affecting: playerOne.
	self assert: (game gameStatus positionOf: playerOne) equals: 3.
	playerOne play:anotherRedoCard in:game affecting: playerOne .
	self assert: (game gameStatus positionOf: playerOne) equals: 7.
	
]

{ #category : #tests }
CardsTests >> testRedoRepeatCard [
	| game playerOne playerTwo sequenceOne sequenceTwo diceOne diceTwo spaces card redoCard |
	sequenceOne := CircularIterator contains: #(7 1 1 2 1 5 3 1 6).
	sequenceTwo := CircularIterator contains: #(1 1 1 2 2 4 1 1 6).
	diceOne := Dice faces: 10 ofType: (DeterministicType rolling: sequenceOne faces: 10).
	diceTwo := Dice faces: 12 ofType: (DeterministicType rolling: sequenceTwo faces: 12).
	playerOne := Player named: 'Carrot'.
	playerTwo := Player named: 'Nacho'.
	spaces := {BoardTest createNoEffectSpacesCollection.
	SpeedUpSpace new} flattened.
	game := Game
		playedBy:
			{playerOne.
			playerTwo}
		throwing:
			{diceOne.
			diceTwo}
		boardComposedBy: spaces
		totalLaps: 2.
	redoCard := RedoCard ownedBy: playerOne.
	playerOne addNewCard: redoCard.
	card := RepeatCard ownedBy: playerOne.
	playerOne addNewCard: card.
	self assert: (game hasTheTurn: playerOne).
	game move: playerOne.
	self assert: (game gameStatus positionOf: playerOne) equals: 4.
	playerOne play: card in: game affecting: playerOne.
	self assert: (game gameStatus positionOf: playerOne) equals: 8.
	playerOne play: redoCard in: game affecting: playerOne.
	self assert: (game gameStatus positionOf: playerOne) equals: 3.
	
]

{ #category : #tests }
CardsTests >> testRedoSpeedCard [
	| game playerOne playerTwo sequenceOne sequenceTwo diceOne diceTwo spaces card redoCard |
	sequenceOne := CircularIterator contains: #(1 1 1 2 1 5 3 1 6).
	sequenceTwo := CircularIterator contains: #(1 1 1 2 2 4 1 1 6).
	diceOne := Dice faces: 10 ofType: (DeterministicType rolling: sequenceOne faces: 10).
	diceTwo := Dice faces: 12 ofType: (DeterministicType rolling: sequenceTwo faces: 12).
	playerOne := Player named: 'Carrot'.
	playerTwo := Player named: 'Nacho'.
	spaces := BoardTest createNoEffectSpacesCollection.
	game := Game
		playedBy:
			{playerOne.
			playerTwo}
		throwing:
			{diceOne.
			diceTwo}
		boardComposedBy: spaces
		totalLaps: 2.
	redoCard := RedoCard ownedBy: playerOne.
	playerOne addNewCard: redoCard.
	card := SpeedCard ownedBy: playerOne.
	playerOne addNewCard: card.
	self assert: (game hasTheTurn: playerOne).
	game move: playerOne.
	self assert: (game gameStatus positionOf: playerOne) equals: 3.
	self assert: (game hasTheTurn: playerTwo).
	game move: playerTwo.
	self assert: (game gameStatus positionOf: playerTwo) equals: 3.
	self assert: (game hasTheTurn: playerOne).
	playerOne play: playerOne myCards first in: game affecting: playerTwo.
	game move: playerOne.
	playerOne play: playerOne myCards first in: game affecting: playerTwo.
	self assert: (game gameStatus positionOf: playerOne) equals: 5.
	self assert: (game hasTheTurn: playerTwo).
	game move: playerTwo.
	self assert: (game gameStatus positionOf: playerTwo) equals: 1
]

{ #category : #tests }
CardsTests >> testRepeatCardAffectsAPlayer [
	| game playerOne playerTwo sequenceOne sequenceTwo diceOne diceTwo spaces card |
	sequenceOne := CircularIterator contains: #(7 1 1 2 1 5 3 1 6).
	sequenceTwo := CircularIterator contains: #(1 1 1 2 2 4 1 1 6).
	diceOne := Dice faces: 10 ofType: (DeterministicType rolling: sequenceOne faces: 10).
	diceTwo := Dice faces: 12 ofType: (DeterministicType rolling: sequenceTwo faces: 12).
	playerOne := Player named: 'Carrot'.
	playerTwo := Player named: 'Nacho'.
	spaces := {BoardTest createNoEffectSpacesCollection.
	SpeedUpSpace new} flattened.
	game := Game
		playedBy:
			{playerOne.
			playerTwo}
		throwing:
			{diceOne.
			diceTwo}
		boardComposedBy: spaces
		totalLaps: 2.
	card := RepeatCard ownedBy: playerTwo.
	playerTwo addNewCard: card.
	self assert: (game hasTheTurn: playerOne).
	game move: playerOne.
	self assert: (game gameStatus positionOf: playerOne) equals: 4.
	playerTwo play: card in: game affecting: playerOne.
	self assert: (game gameStatus positionOf: playerOne) equals: 8
]

{ #category : #tests }
CardsTests >> testRepeatCardAffectsAPlayerOnlyIfSpaceHasAnEffect [
	| game playerOne playerTwo sequenceOne sequenceTwo diceOne diceTwo spaces card |
	sequenceOne := CircularIterator contains: #(1 1 1 2 1 5 3 1 6).
	sequenceTwo := CircularIterator contains: #(1 1 1 2 2 4 1 1 6).
	diceOne := Dice faces: 10 ofType: (DeterministicType rolling: sequenceOne faces: 10).
	diceTwo := Dice faces: 12 ofType: (DeterministicType rolling: sequenceTwo faces: 12).
	playerOne := Player named: 'Carrot'.
	playerTwo := Player named: 'Nacho'.
	spaces := {BoardTest createNoEffectSpacesCollection.
	SpeedUpSpace new} flattened.
	game := Game
		playedBy:
			{playerOne.
			playerTwo}
		throwing:
			{diceOne.
			diceTwo}
		boardComposedBy: spaces
		totalLaps: 2.
	card := RepeatCard ownedBy: playerTwo.
	playerTwo addNewCard: card.
	self assert: (game hasTheTurn: playerOne).
	game move: playerOne.
	self assert: (game gameStatus positionOf: playerOne) equals: 3.
	playerTwo play: card in: game affecting: playerOne.
	self assert: (game gameStatus positionOf: playerOne) equals: 3
	
]

{ #category : #tests }
CardsTests >> testRepeatCardOnlyAffectsAPlayerIfDicesWereRolled [
	| game playerOne playerTwo sequenceOne sequenceTwo diceOne diceTwo spaces card |
	sequenceOne := CircularIterator contains: #(7 1 1 2 1 5 3 1 6).
	sequenceTwo := CircularIterator contains: #(1 1 1 2 2 4 1 1 6).
	diceOne := Dice faces: 10 ofType: (DeterministicType rolling: sequenceOne faces: 10).
	diceTwo := Dice faces: 12 ofType: (DeterministicType rolling: sequenceTwo faces: 12).
	playerOne := Player named: 'Carrot'.
	playerTwo := Player named: 'Nacho'.
	spaces := {BoardTest createNoEffectSpacesCollection.
	SpeedUpSpace new} flattened.
	game := Game
		playedBy:
			{playerOne.
			playerTwo}
		throwing:
			{diceOne.
			diceTwo}
		boardComposedBy: spaces
		totalLaps: 2.
	card := RepeatCard ownedBy: playerOne.
	playerOne addNewCard: card.
	
	self assert: (game hasTheTurn: playerOne).
	game move: playerOne.
	self assert: (game gameStatus positionOf: playerOne) equals: 4.
	playerOne play: card in: game affecting: playerTwo.
	self assert: (game hasTheTurn: playerTwo).
	game move: playerTwo.
	self assert: (game gameStatus positionOf: playerTwo) equals: 3
]

{ #category : #tests }
CardsTests >> testSpeedCardAffectsAPlayer [
	| game playerOne playerTwo sequenceOne sequenceTwo diceOne diceTwo spaces card |
	sequenceOne := CircularIterator contains: #(1 1 1 2 1 5 3 1 6).
	sequenceTwo := CircularIterator contains: #(1 1 1 2 2 4 1 1 6).
	diceOne := Dice faces: 10 ofType: (DeterministicType rolling: sequenceOne faces: 10).
	diceTwo := Dice faces: 12 ofType: (DeterministicType rolling: sequenceTwo faces: 12).
	playerOne := Player named: 'Carrot'.
	playerTwo := Player named: 'Nacho'.
	spaces := BoardTest createNoEffectSpacesCollection.
	game := Game
		playedBy:
			{playerOne.
			playerTwo}
		throwing:
			{diceOne.
			diceTwo}
		boardComposedBy: spaces
		totalLaps: 2.
	card := SpeedCard ownedBy: playerOne.
	playerOne addNewCard: card.
	self assert: (game hasTheTurn: playerOne).
	game move: playerOne.
	self assert: (game gameStatus positionOf: playerOne) equals: 3.
	self assert: (game hasTheTurn: playerTwo).
	game move: playerTwo.
	self assert: (game gameStatus positionOf: playerTwo) equals: 3.
	self assert: (game hasTheTurn: playerOne).
	playerOne play: playerOne myCards first in: game affecting: playerTwo.
	game move: playerOne.
	self assert: (game gameStatus positionOf: playerOne) equals: 5.
	self assert: (game hasTheTurn: playerTwo).
	game move: playerTwo.
	self assert: (game gameStatus positionOf: playerTwo) equals: 8
]
