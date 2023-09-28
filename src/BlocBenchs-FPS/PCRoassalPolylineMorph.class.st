Class {
	#name : 'PCRoassalPolylineMorph',
	#superclass : 'PCRoassalTranslatingFiguresMorph',
	#category : 'BlocBenchs-FPS-RawMorph-Old',
	#package : 'BlocBenchs-FPS',
	#tag : 'RawMorph-Old'
}

{ #category : 'instance creation' }
PCRoassalPolylineMorph >> newShape: index [

	| offset translatedPoints |
	offset := case figureOffset + (index * case offsetBetweenFigures).
	translatedPoints := case vertices collect: [ :each | each + offset ].
	"Didn't find a better way to translate the shape"

	^ RSPolyline new 
		controlPoints: translatedPoints;
		noPaint;
		border: (RSBorder new
			 color: (Color random: random);
			 width: case borderWidth);
		yourself

]
