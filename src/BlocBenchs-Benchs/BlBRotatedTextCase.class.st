Class {
	#name : #BlBRotatedTextCase,
	#superclass : #BlBAbstractTranslatingFiguresCase,
	#category : #'BlocBenchs-Benchs-Bloc'
}

{ #category : #hook }
BlBRotatedTextCase >> blTextFor: random [

	^ (BlRopedText string: (String loremIpsum: 90))
		  fontSize: 8;
		  fontName: 'Arial';
		  foreground: (Color random: random);
		  yourself
]

{ #category : #accessing }
BlBRotatedTextCase >> logicalExtent [

	^ 900 @ 500
]

{ #category : #hook }
BlBRotatedTextCase >> newFigureWith: random [
	
	^ BlTextElement new
		text: (self blTextFor: random);
"		padding: (BlInsets all: 2);"
		transformDo: [ :t | t topLeftOrigin; rotateBy: 60 ];
		yourself

]

{ #category : #accessing }
BlBRotatedTextCase >> numberOfFigures [

	^ 100
]

{ #category : #hook }
BlBRotatedTextCase >> offsetBetweenFigures [

	^ 7 @ 0
]
