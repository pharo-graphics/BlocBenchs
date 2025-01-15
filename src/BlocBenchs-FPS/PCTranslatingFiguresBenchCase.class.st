Class {
	#name : #PCTranslatingFiguresBenchCase,
	#superclass : #PCBenchCase,
	#instVars : [
		'useSingleAnimation'
	],
	#category : #'BlocBenchs-FPS-Cases'
}

{ #category : #examples }
PCTranslatingFiguresBenchCase class >> exampleOpenFigureSamples [

	self allBenchCases do: [ :each |
		| sampleElement |
		sampleElement := each newSampleFigure.

		BlSpace new
			addChild: (sampleElement
				position: 50 asPoint;
				yourself);
			title: 'Sample: ', each label;
			extent: 400 asPoint;
			show ]

]
