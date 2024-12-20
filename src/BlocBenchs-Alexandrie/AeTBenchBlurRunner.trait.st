"
I have behavior for runners that explore blurring geometries.
"
Trait {
	#name : #AeTBenchBlurRunner,
	#category : #'BlocBenchs-Alexandrie-Blur'
}

{ #category : #running }
AeTBenchBlurRunner classSide >> benchAllVsGaussian [
	<script>

	| instance repeatCount benchResult |
	
	"Gaussian shadow serves as a baseline reference"
	instance := self new.
	benchResult := [ instance runGaussian ] benchFor: 1 second.

	'------' traceCr.
	instance traceCr.
	'## runGaussian' traceCr.
	'average ms: ' trace. benchResult period asMilliSeconds traceCr.
	'iterations: ' trace. benchResult iterations traceCr.	

	"Run same number of iterations but emulated"
	repeatCount := benchResult iterations.

	self runSelectorsWithoutGaussian do: [ :eachSelector |
		| allMs |
		'## ' trace.
		eachSelector traceCr.

		allMs := Array streamContents: [ :msStream |
			50 timesRepeat: [
				instance := self new.
				msStream nextPut: ([
					repeatCount timesRepeat: [
						instance perform: eachSelector ]
					] timeToRun asMilliSeconds / repeatCount) ] ].

		"Print collected ms nicely"
		MeanConfidenceIntervalPrinter new
			unitString: 'ms';
			fixedDecimalPlaces: 2;
			print: allMs on: Transcript.
		Transcript cr; flush ]
]

{ #category : #running }
AeTBenchBlurRunner classSide >> pixelDiffsVsGaussian [
	"Useful to check how well are the shadow emulations compared with our Gaussian blur filter"
	<script>

	^ (self pixelDiffsWith: #runGaussian) inspect
]

{ #category : #running }
AeTBenchBlurRunner classSide >> pixelDiffsWith: expectedSurfaceRunSelector [

	| expectedSurface expectedForm |
	expectedSurface := self new perform: expectedSurfaceRunSelector.
	expectedForm := expectedSurface asForm.
	
	^ (self runSelectors copyWithout: expectedSurfaceRunSelector)
		collect: [ :eachSelector |
			| actualSurface actualForm instance |
			instance := self new.
			actualSurface := instance perform: eachSelector.
			actualForm := actualSurface asForm.
			AePixelComparison
				expectedForm: expectedForm
				actualForm: actualForm
				label: (expectedSurfaceRunSelector, ' vs ', eachSelector) ]
]

{ #category : #accessing }
AeTBenchBlurRunner classSide >> runSelectors [

	^ (self selectors select: [ :each | each beginsWith: 'run' ]) sort
]

{ #category : #accessing }
AeTBenchBlurRunner classSide >> runSelectorsWithoutGaussian [

	^ self runSelectors copyWithout: #runGaussian
]

{ #category : #debugging }
AeTBenchBlurRunner >> allSurfaces [
	<script: 'self new allSurfaces inspect'>

	| dict |
	dict := OrderedDictionary new.

	self class runSelectors do: [ :eachSelector |
		dict
			at: eachSelector
			put: (self class new perform: eachSelector);
			yourself ].

	^ dict
]

{ #category : #initialization }
AeTBenchBlurRunner >> rampFunctionAt: x [
	"Evaluate 1.0 minus a sigmoid (logistic) function, with mu and sigma determined manually by try and error."

	^ 1.0 - (1.0 / (1.0 + (((x - 0.475) * -10.0) exp)))
]

{ #category : #initialization }
AeTBenchBlurRunner >> rampSize: rampSize stopsAndAlphasDo: aBlock [

	aBlock value: 0.0 value: 1.0.

	1 to: rampSize - 2 do: [ :i |
		| stop |
		stop := i / (rampSize - 1) asFloat.
		aBlock
			value: stop
			value: (self rampFunctionAt: stop) ].

	aBlock value: 1.0 value: 0.0
]

{ #category : #initialization }
AeTBenchBlurRunner >> shadowColor [

	^ Color blue alpha: 0.75
]

{ #category : #initialization }
AeTBenchBlurRunner >> shadowRampSize: anInteger [

	^ Array streamContents: [ :stream |
		self
			rampSize: anInteger
			stopsAndAlphasDo: [ :eachStop :eachAlpha |
				stream nextPut:
					(eachStop -> (self shadowColor alpha: eachAlpha)) ] ]
]
