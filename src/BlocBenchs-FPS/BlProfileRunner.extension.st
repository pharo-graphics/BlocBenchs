Extension { #name : #BlProfileRunner }

{ #category : #'*BlocBenchs-FPS' }
BlProfileRunner class >> exampleAlexandrieFPS [

	| hosts canvases cases runners |
	hosts := { "BlNullRendererMorphicWindowHost." BAMorphicWindowHost. BlMorphicWindowHost }.
	canvases := { BlSpartaSkiaCanvasBuilder. BlSpartaCairoCanvasBuilder }.
	cases := { BlBoidsProfileCase new boidsSkyElementClass: BoidsSkyUsingGeometryElement; yourself }.
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

	[	runners do: #run.
		runners do: #openMeterReports ] fork.

]
