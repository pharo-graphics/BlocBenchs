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

	results := spaceFixture allFixtureSelectors collect: [ :selector |
		| aSpace expectedForm actualForm |
		aSpace := spaceFixture perform: selector.
		expectedForm := Form fromFileNamed: (self fileNameFor: selector).
		actualForm := aSpace root pureCairoAsForm.

		PCPixelComparison
			expectedForm: expectedForm
			actualForm: actualForm
			label: selector ].

	mismatchingResults := results reject: [ :each | each isMatch ].

	mismatchingResults do: [ :each | each inspect ].

	self assertEmpty: mismatchingResults
]
