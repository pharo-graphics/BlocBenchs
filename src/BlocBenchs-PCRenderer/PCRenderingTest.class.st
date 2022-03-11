Class {
	#name : #PCRenderingTest,
	#superclass : #TestCase,
	#category : #'BlocBenchs-PCRenderer-Tests'
}

{ #category : #exporting }
PCRenderingTest class >> exportAllFilesUsingCurrentSpartaCanvas [
	<script>

	| spaceFixture |
	spaceFixture := BlSpaceFixture new.
	spaceFixture allFixtureSelectors do: [ :each |
		| aSpace |
		aSpace := spaceFixture perform: each.
		self exportFileNamed: each with: aSpace root asSpartaForm ].
	
	self inform: ('Exported files using Sparta ', Bloc preferableSpartaCanvas label)

]

{ #category : #exporting }
PCRenderingTest class >> exportAllFilesUsingPCCanvas [
	<script>

	| spaceFixture |
	spaceFixture := BlSpaceFixture new.
	spaceFixture allFixtureSelectors do: [ :each |
		| aSpace |
		aSpace := spaceFixture perform: each.
		self exportFileNamed: each with: aSpace root pureCairoAsForm ].
	
	self inform: ('Exported files using PCCanvas ', Bloc preferableSpartaCanvas label)

]

{ #category : #exporting }
PCRenderingTest class >> exportFileNamed: aSymbol with: aForm [ 

	| aFileName aPCRenderingTest |
	aPCRenderingTest := self new.
	aFileName := aPCRenderingTest fileNameFor: aSymbol.
	aFileName asFileReference ensureDelete.

	aForm writePNGFileNamed: aFileName
]

{ #category : #tests }
PCRenderingTest >> fileNameFor: aSymbol [

	^ 'expected-', aSymbol asString, '.png'

]

{ #category : #tests }
PCRenderingTest >> testAllFixtures [

	| spaceFixture results mismatchingResults |
	spaceFixture := BlSpaceFixture new.

	results := spaceFixture allFixtureSelectors
		collect: [ :each |
			| aSpace expectedForm actualForm |
			aSpace := spaceFixture perform: each.
			expectedForm := Form fromFileNamed: (self fileNameFor: each).
			actualForm := aSpace root pureCairoAsForm.
	
			each -> (PCPixelComparison new
				expectedForm: expectedForm;
				actualForm: actualForm;
				yourself) ]
		as: OrderedDictionary.

	mismatchingResults := results reject: [:each | each isMatch ].

	mismatchingResults keysAndValuesDo: [ :selector :result |
		result actualVsExpectedMergedForm 
			inspectWithLabel: selector, ' - Actual vs. Expected' ].

	self assertEmpty: mismatchingResults
]
