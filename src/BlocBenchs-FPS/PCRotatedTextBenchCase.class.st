Class {
	#name : 'PCRotatedTextBenchCase',
	#superclass : 'PCTranslatingFiguresBenchCase',
	#category : 'BlocBenchs-FPS-Cases',
	#package : 'BlocBenchs-FPS',
	#tag : 'Cases'
}

{ #category : 'hook' }
PCRotatedTextBenchCase >> blTextFor: random [

	^ (BlRopedText string: (String loremIpsum: 90))
		  fontSize: 8;
		  fontName: 'Arial';
		  foreground: (Color random: random);
		  yourself
]

{ #category : 'accessing' }
PCRotatedTextBenchCase >> logicalExtent [

	^ 900 @ 500
]

{ #category : 'hook' }
PCRotatedTextBenchCase >> newFigureWith: random [
	
	^ BlTextElement new
		text: (self blTextFor: random);
"		padding: (BlInsets all: 2);"
		transformDo: [ :t | t topLeftOrigin; rotateBy: 60 ];
		yourself

]

{ #category : 'accessing' }
PCRotatedTextBenchCase >> numberOfFigures [

	^ 100
]

{ #category : 'hook' }
PCRotatedTextBenchCase >> offsetBetweenFigures [

	^ 7 @ 0
]
