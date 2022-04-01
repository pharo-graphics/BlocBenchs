Class {
	#name : #PCRoassalMorph,
	#superclass : #PCMorph,
	#instVars : [
		'roassalAthensMorph'
	],
	#category : #'BlocBenchs-FPS'
}

{ #category : #drawing }
PCRoassalMorph >> drawOnCairoCanvas [

	surface drawDuring: [ :aCairoCanvas | 
		roassalAthensMorph
			signalUpdate;
			drawOnAthensCanvas: aCairoCanvas ].
]
