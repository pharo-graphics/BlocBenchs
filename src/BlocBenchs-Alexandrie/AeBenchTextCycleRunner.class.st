"
I have benchmarks for the text cycle: open a font file, shape, draw.
"
Class {
	#name : #AeBenchTextCycleRunner,
	#superclass : #Object,
	#instVars : [
		'benchs',
		'fontFileReferences',
		'benchDuration',
		'fontSize',
		'utf8Encoded',
		'ttfFileReference',
		'cairoContext',
		'fontMatrix',
		'userToDeviceMatrix',
		'fontOptions',
		'results',
		'cairoSurface'
	],
	#category : #'BlocBenchs-Alexandrie-Text'
}

{ #category : #benchmarking }
AeBenchTextCycleRunner >> add0ScanFacesBenchs [

	| ftLibrary |
	fontFileReferences := { 
		AeFilesystemResources inriaSerifRegularTTF.
		'/System/Library/Fonts/Helvetica.ttc' asFileReference.
		Smalltalk vmBinary asFileReference.
		}.
	
	self
		addBenchLabeled: 'Scan faces FT'
		setUp: [ ftLibrary := AeFTLibrary newInitialized ]
		do: [
			| aFTFace |
			aFTFace := ftLibrary
				newFaceFromFile: ttfFileReference
				index: 0.
			aFTFace numberOfFaces ].

	self
		addBenchLabeled: 'Scan faces FT b'
		setUp: [  ]
		do: [
			| aFTFace |
			aFTFace := AeFTLibrary newInitialized
				newFaceFromFile: ttfFileReference
				index: 0.
			aFTFace numberOfFaces ].

	self
		addBenchLabeled: 'Scan faces HB'
		setUp: [ ]
		do: [
			| hbBlob |
			hbBlob := AeHbBlob newLocatedAt: ttfFileReference.
			hbBlob faceCount ]
]

{ #category : #benchmarking }
AeBenchTextCycleRunner >> add1ShapeBenchs [

	| ftLibrary ftFace hbBlob hbFace cairoFontFace hbFont |
	fontFileReferences := { 
		AeFilesystemResources inriaSerifRegularTTF.
"		AeCascadiaCodeDownloadedFont new fileReference.
		AeNotoColorEmojiDownloadedFont new fileReference.
		'/System/Library/Fonts/Helvetica.ttc' asFileReference.
		'/System/Library/Fonts/Apple Color Emoji.ttc' asFileReference."
		}.

	self
		addBenchLabeled: 'shape1: FT'
		setUp: [ 
			ftLibrary := AeFTLibrary newInitialized.
			ftFace := ftLibrary
				newFaceFromFile: ttfFileReference
				index: 0.
			cairoFontFace := ftFace newCairoFontFace ]
		do: [ self shape1: cairoFontFace ].

	self
		addBenchLabeled: 'shape1: HB'
		setUp: [ 
			hbBlob := AeHbBlob newLocatedAt: ttfFileReference.
			hbFace := hbBlob newHbFaceAtIndex: 0.
			cairoFontFace := hbFace newCairoFontFace ]
		do: [ self shape1: cairoFontFace ].
		
	self
		addBenchLabeled: 'shape2: FT'
		setUp: [ 
			ftLibrary := AeFTLibrary newInitialized.
			ftFace := ftLibrary
				newFaceFromFile: ttfFileReference
				index: 0.
			hbFont := AeHbFont newForFTFaceReferenced: ftFace ]
		do: [ self shape2: hbFont ].

	self
		addBenchLabeled: 'shape2: HB'
		setUp: [ 
			hbBlob := AeHbBlob newLocatedAt: ttfFileReference.
			hbFace := hbBlob newHbFaceAtIndex: 0.
			hbFont := hbFace newHbFont ]
		do: [ self shape2: hbFont ]
]

{ #category : #benchmarking }
AeBenchTextCycleRunner >> add2DrawBenchs [

	| ftLibrary ftFace hbBlob hbFace cairoFontFace glyphArray |
	fontFileReferences := { 
"		AeFilesystemResources inriaSerifRegularTTF."
		AeCascadiaCodeDownloadedFont new fileReference.
"		AeNotoColorEmojiDownloadedFont new fileReference."
		'/System/Library/Fonts/Helvetica.ttc' asFileReference.
"		'/System/Library/Fonts/Apple Color Emoji.ttc' asFileReference."
		}.

	self
		addBenchLabeled: 'draw FT'
		setUp: [ 
			ftLibrary := AeFTLibrary newInitialized.
			ftFace := ftLibrary
				newFaceFromFile: ttfFileReference
				index: 0.
			cairoFontFace := ftFace newCairoFontFace.
			glyphArray := self shape1: cairoFontFace ]
		do: [ self draw: glyphArray ].

	self
		addBenchLabeled: 'draw HB'
		setUp: [ 
			hbBlob := AeHbBlob newLocatedAt: ttfFileReference.
			hbFace := hbBlob newHbFaceAtIndex: 0.
			cairoFontFace := hbFace newCairoFontFace.
			glyphArray := self shape1: cairoFontFace ]
		do: [ self draw: glyphArray ]
]

{ #category : #benchmarking }
AeBenchTextCycleRunner >> addBenchLabeled: aString setUp: setUpBlock do: aBlock [

	benchs add: { setUpBlock. aBlock. aString }
]

{ #category : #benchmarking }
AeBenchTextCycleRunner >> draw: glyphArray [

	cairoContext showGlyphs: glyphArray size: glyphArray length
]

{ #category : #benchmarking }
AeBenchTextCycleRunner >> initialize [

	super initialize.

	benchs := OrderedCollection new.
	results := LinkedList new.

	utf8Encoded := 'Officë' utf8Encoded.
"	utf8Encoded := String loremIpsum utf8Encoded."
	fontSize := 50.
	benchDuration := 2 seconds.

	fontMatrix := AeCairoMatrix newScalingBy: fontSize asPoint.
	userToDeviceMatrix := AeCairoMatrix newIdentity.
	fontOptions := AeCairoFontOptions new
		hintMetrics: AeCairoHintMetrics off;
		hintStyle: AeCairoHintStyle none;
		yourself.
	cairoSurface := AeCairoImageSurface
		extent: 1000 asPoint
		format: AeCairoSurfaceFormat rgb24.
	cairoContext := cairoSurface newContext.
	cairoContext
		sourceColor: Color random;
		paint;
		sourceColor: Color black;
		fontOptions: fontOptions.
]

{ #category : #benchmarking }
AeBenchTextCycleRunner >> reportToStdout: results [

	| stream separator | 
	stream := Stdio stdout.
	separator := '; 	'.
	results do: [ :each |
		stream
			print: each third;
			nextPutAll: separator;
			nextPutAll: each second;
			nextPutAll: separator;
			nextPutAll: each first path segments last;
			nextPutAll: separator;
			lf ].
	stream flush
]

{ #category : #benchmarking }
AeBenchTextCycleRunner >> run0ScanBenchs [
	<script: 'self new run0ScanBenchs inspect'>

	self add0ScanFacesBenchs.

	fontFileReferences do: [	:eachFileRef |
		ttfFileReference := eachFileRef.

		benchs do: [ :eachBench |
			| benchResult lastAnswer |
			3 timesRepeat: [Smalltalk garbageCollect].
			
			lastAnswer := nil.
			eachBench first value.
			benchResult := [
				lastAnswer := eachBench second
					on: Error
					do: [ 'error' ]
				] benchFor: benchDuration.

			results add: {
				eachFileRef.
				eachBench third.
				benchResult frequency asInteger.
				lastAnswer.
				cairoSurface asForm } ]].
	
	results := results asArray.
	
	self reportToStdout: results.
]

{ #category : #benchmarking }
AeBenchTextCycleRunner >> run1ShapeBenchs [
	<script: 'self new run1ShapeBenchs inspect'>

	self add1ShapeBenchs.

	fontFileReferences do: [	:eachFileRef |
		ttfFileReference := eachFileRef.

		benchs do: [ :eachBench |
			| benchResult lastAnswer |
			3 timesRepeat: [Smalltalk garbageCollect].
			
			lastAnswer := nil.
			eachBench first value.
			benchResult := [
				lastAnswer := eachBench second
					on: Error
					do: [ 'error' ]
				] benchFor: benchDuration.

			results add: {
				eachFileRef.
				eachBench third.
				benchResult frequency asInteger.
				lastAnswer.
				cairoSurface asForm } ]].
	
	results := results asArray.
	
	self reportToStdout: results.
]

{ #category : #benchmarking }
AeBenchTextCycleRunner >> run2DrawBenchs [
	<script: 'self new run2DrawBenchs inspect'>

	self add2DrawBenchs.

	fontFileReferences do: [	:eachFileRef |
		ttfFileReference := eachFileRef.

		benchs do: [ :eachBench |
			| benchResult lastAnswer |
			3 timesRepeat: [Smalltalk garbageCollect].
			
			cairoContext
				sourceColor: Color random;
				paint.
			
			lastAnswer := nil.
			eachBench first value.
			benchResult := [
				cairoContext translateByX: 0.25 y: 0.25.
				lastAnswer := eachBench second
					on: Error
					do: [ 'error' ]
				] benchFor: benchDuration.

			results add: {
				eachFileRef.
				eachBench third.
				benchResult frequency asInteger.
				lastAnswer.
				cairoSurface } ]].
	
	results := results asArray.
	
	self reportToStdout: results.
]

{ #category : #benchmarking }
AeBenchTextCycleRunner >> shape1: cairoFontFace [

	cairoContext fontFace: cairoFontFace.
	cairoContext fontSize: fontSize.
	^ cairoContext scaledFont glyphArrayForUtf8Array: utf8Encoded
]

{ #category : #benchmarking }
AeBenchTextCycleRunner >> shape2: hbFont [

	self halt. "Set fontSize!?"
			
	^ AeHbBuffer new
		direction: AeHbDirection leftToRight;
		script: AeHbScript latin;
		language: AeHbLanguage en;
		clusterLevel: AeHbBufferClusterLevel recommended;
		addUtf8ByteArray: utf8Encoded;
		shapeWithFont: hbFont;
		cairoGlyphArray
]
