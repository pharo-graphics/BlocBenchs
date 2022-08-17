Extension { #name : #PCMeanConfidenceIntervalPrinter }

{ #category : #'*BlocBenchs-Old' }
PCMeanConfidenceIntervalPrinter class >> example [

	| cases runners printer df hosts canvases |
	hosts := { BlOSWindowSDL2Host. BAOSWindowSDL2Host."BlMorphicWindowHost" }.
	canvases := { BlSpartaCairoCanvasBuilder. BlSpartaSkiaCanvasBuilder}.
	cases := { BlBoidsProfileCase new duration: 10 seconds; yourself }.
	runners := hosts flatCollect: [:eachHost |
		canvases flatCollect: [:eachCanvas |
			cases collect: [ :eachCase |
				| case |
				case := eachCase copy
					hostClass: eachHost;
					spartaCanvasClass: eachCanvas;
					yourself.

				(BlProfileRunner newForCase: case)
					enableFPS;
					yourself

				] ] ].

	[
	runners do: #run.

	printer := PCMeanConfidenceIntervalPrinter new
		fixedDecimalPlaces: 1;
		yourself.
	df := DataFrame
		withRowNames: (hosts collect: #label)
		columnNames: (canvases collect: #label).
	hosts doWithIndex: [:eachHost :hostIndex |
		canvases doWithIndex: [:eachCanvas :canvasIndex |
			runners
				detect: [ :each |
					each case hostClass = eachHost and: [
					each case spartaCanvasClass = eachCanvas ] ]
				ifFound: [ :found |
					df
						at: hostIndex at: canvasIndex
						put: (printer print: found meters anyOne intermediateFPS) ] ] ].

	Stdio stdout
		lf;
		<< runners anyOne case label;
		lf;
		<< AeCairoLibrary uniqueInstance versionString;
		lf; lf.
	DataFrameMarkdownPrinter new
		stream: Stdio stdout;
		dataFrame: df;
		write.
	Stdio stdout lf. 
	] fork
]
