Class {
	#name : #PCTextBenchCase,
	#superclass : #PCTranslatingFiguresBenchCase,
	#category : #'BlocBenchs-FPS-Cases'
}

{ #category : #hook }
PCTextBenchCase >> blTextFor: random [

	^ (BlRopedText string: (String loremIpsum: 90))
		  fontSize: 8;
		  fontName: 'Arial';
		  foreground: (Color random: random);
		  yourself
]

{ #category : #hook }
PCTextBenchCase >> horizontalSeparation [

	^ 7
]

{ #category : #hook }
PCTextBenchCase >> newFigureWith: random [
	
	^ BlTextElement new
		text: (self blTextFor: random);
"		padding: (BlInsets all: 2);"
		transformDo: [ :t | t topLeftOrigin; rotateBy: 60 ];
		yourself

]

{ #category : #accessing }
PCTextBenchCase >> numberOfFigures [

	^ 100
]

{ #category : #accessing }
PCTextBenchCase >> surfaceExtent [

	^ 900 @ 500
]
