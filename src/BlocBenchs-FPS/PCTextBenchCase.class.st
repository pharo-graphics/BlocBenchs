Class {
	#name : #PCTextBenchCase,
	#superclass : #PCTranslatingFiguresBenchCase,
	#category : #'BlocBenchs-FPS-Cases'
}

{ #category : #hook }
PCTextBenchCase >> blTextFor: random [

	^ (BlRopedText string: (String loremIpsum: 150))
		  fontSize: 8;
		  fontName: 'Source Code Pro';
		  foreground: (Color random: random) muchDarker;
		  yourself
]

{ #category : #accessing }
PCTextBenchCase >> logicalExtent [

	^ 900 @ 900
]

{ #category : #hook }
PCTextBenchCase >> newFigureWith: random [
	
	^ BlTextElement new
		text: (self blTextFor: random);
		yourself

]

{ #category : #accessing }
PCTextBenchCase >> numberOfFigures [

	^ 100
]

{ #category : #hook }
PCTextBenchCase >> offsetBetweenFigures [

	^ 0 @ 9
]

{ #category : #accessing }
PCTextBenchCase >> targetTranslation [

	^ 0 @ 100
]
