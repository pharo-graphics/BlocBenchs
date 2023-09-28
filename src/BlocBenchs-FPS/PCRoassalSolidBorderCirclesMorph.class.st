Class {
	#name : 'PCRoassalSolidBorderCirclesMorph',
	#superclass : 'PCRoassalCirclesMorph',
	#category : 'BlocBenchs-FPS-RawMorph-Old',
	#package : 'BlocBenchs-FPS',
	#tag : 'RawMorph-Old'
}

{ #category : 'instance creation' }
PCRoassalSolidBorderCirclesMorph >> prepareCircle: aCircleShape [

	aCircleShape
		noPaint;
		border: (RSBorder new
			 color: (Color random: random);
			 width: case borderWidth)

]
