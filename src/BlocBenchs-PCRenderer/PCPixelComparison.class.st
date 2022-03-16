Class {
	#name : #PCPixelComparison,
	#superclass : #Object,
	#instVars : [
		'actualForm',
		'expectedForm',
		'label'
	],
	#category : #'BlocBenchs-PCRenderer-Tests'
}

{ #category : #'instance creation' }
PCPixelComparison class >> expectedForm: aForm actualForm: anotherForm label: aString [

	^ self new
		  expectedForm: aForm;
		  actualForm: anotherForm;
		  label: aString;
		  yourself
]

{ #category : #accessing }
PCPixelComparison >> actualForm [

	^ actualForm
]

{ #category : #accessing }
PCPixelComparison >> actualForm: aForm [

	actualForm := aForm
]

{ #category : #'accessing diff' }
PCPixelComparison >> actualVsExpectedMergedDiffForm [
	
	| actualDiffForm expectedDiffForm |
	actualDiffForm := Form extent: actualForm extent depth: actualForm depth.
	expectedDiffForm := Form extent: expectedForm extent depth: expectedForm depth.
	
	1 to: (actualForm width min: expectedForm width) do: [ :x |
		1 to: (actualForm height min: expectedForm height) do: [ :y |

			| currentPoint actualColor expectedColor |
			currentPoint := x@y - (1@1). "Weird: forms are 0-indexed"
			actualColor := actualForm colorAt: currentPoint.
			expectedColor := expectedForm colorAt: currentPoint.
			actualColor = expectedColor ifFalse: [
				actualDiffForm colorAt: currentPoint put: actualColor.
				expectedDiffForm colorAt: currentPoint put: expectedColor ]

			] ].
	
	^ self concatenatedForm: actualDiffForm and: expectedDiffForm

]

{ #category : #'accessing diff' }
PCPixelComparison >> actualVsExpectedMergedForm [

	^ self concatenatedForm: actualForm and: expectedForm
]

{ #category : #private }
PCPixelComparison >> concatenatedForm: aForm and: anotherForm [
	"Answer a Form with both forms separated by a transparent vertical 1-pixel line."

	| mergedForm |
	mergedForm := Form extent: (aForm width + anotherForm width + 1) @ (anotherForm height max: aForm height) depth: 32.
	mergedForm := mergedForm mergeWith: aForm at: 0@0.
	mergedForm := mergedForm mergeWith: anotherForm at: (aForm width + 1) @ 0.
	
	^ mergedForm

]

{ #category : #accessing }
PCPixelComparison >> expectedForm [

	^ expectedForm
]

{ #category : #accessing }
PCPixelComparison >> expectedForm: aForm [

	expectedForm := aForm
]

{ #category : #spec }
PCPixelComparison >> inspectionActualVsExpected: aBuilder [
	<inspectorPresentationOrder: 1 title: 'Actual/Expected'>

	^ aBuilder newMorph
		morph: (self actualVsExpectedMergedForm  magnifyBy:
			self inspectionMagnification) asMorph;
		yourself
]

{ #category : #spec }
PCPixelComparison >> inspectionActualVsExpectedDiff: aBuilder [
	<inspectorPresentationOrder: 2 title: 'Actual/Expected Diff'>

	^ aBuilder newMorph
		  morph: (self actualVsExpectedMergedDiffForm magnifyBy:
				self inspectionMagnification) asMorph;
		  yourself
]

{ #category : #spec }
PCPixelComparison >> inspectionMagnification [

	^ 3
]

{ #category : #testing }
PCPixelComparison >> isMatch [

	^ 0 = (expectedForm pixelCompare: (0@0 corner: expectedForm extent) with: actualForm at: 0@0).
]

{ #category : #accessing }
PCPixelComparison >> label: aString [ 
	
	label := aString
]

{ #category : #printing }
PCPixelComparison >> printOn: aStream [

	super printOn: aStream.
	aStream
		nextPut: $(;
		nextPutAll: label;
		space;
		nextPutAll: (self isMatch ifTrue: [ 'match' ] ifFalse: [ 'mismatch' ]);
		nextPut: $)

]
