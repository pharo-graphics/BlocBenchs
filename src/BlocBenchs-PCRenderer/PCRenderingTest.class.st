Class {
	#name : #PCRenderingTest,
	#superclass : #TestCase,
	#instVars : [
		'spaceFixture'
	],
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

	^ self filesystemResourcesDirectory / ('expected-', aSymbol asString, '.png')

]

{ #category : #tests }
PCRenderingTest >> filesystemResourcesDirectory [

	| repo |
	repo := IceRepository registry detect: [ :each | each name = 'BlocBenchs' ].
	^ repo location / 'tests' 
]

{ #category : #tests }
PCRenderingTest >> pixelComparisonFor: aSymbol [
	
	| aSpace expectedForm actualForm |
	aSpace := spaceFixture perform: aSymbol.
	expectedForm := Form fromFileNamed: (self fileNameFor: aSymbol).
	actualForm := aSpace root pureCairoAsForm.

	^ PCPixelComparison
		expectedForm: expectedForm
		actualForm: actualForm
		label: aSymbol
]

{ #category : #running }
PCRenderingTest >> setUp [
	super setUp.
	
	spaceFixture := BlSpaceFixture new.
]

{ #category : #tests }
PCRenderingTest >> testAllFixtures [

	| results mismatchingResults |
	results := spaceFixture allFixtureSelectors
		collect: [ :each | self pixelComparisonFor: each ].

	mismatchingResults := results reject: [ :each | each isMatch ].

"	DEBUG WITH: mismatchingResults do: [ :each | each inspect ]."

	self assertEmpty: mismatchingResults
]
