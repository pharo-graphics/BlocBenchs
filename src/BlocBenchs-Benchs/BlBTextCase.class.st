Class {
	#name : #BlBTextCase,
	#superclass : #BlBAbstractTranslatingFiguresCase,
	#category : #'BlocBenchs-Benchs-Bloc'
}

{ #category : #hook }
BlBTextCase >> blTextFor: random [

	^ (BlRopedText string: (String loremIpsum: 170))
		  fontSize: 8;
		  fontName: 'Source Sans Pro';
		  foreground: (Color random: random) darker;
		  yourself
]

{ #category : #accessing }
BlBTextCase >> logicalExtent [

	^ 900 @ 900
]

{ #category : #hook }
BlBTextCase >> newFigureWith: random [
	
	^ BlTextElement new
		text: (self blTextFor: random);
		yourself

]

{ #category : #accessing }
BlBTextCase >> numberOfFigures [

	^ 100
]

{ #category : #hook }
BlBTextCase >> offsetBetweenFigures [

	^ 0 @ 4
]

{ #category : #accessing }
BlBTextCase >> targetTranslation [

	^ 0 @ 100
]
