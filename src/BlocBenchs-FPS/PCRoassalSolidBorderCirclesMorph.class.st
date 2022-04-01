Class {
	#name : #PCRoassalSolidBorderCirclesMorph,
	#superclass : #PCRoassalCirclesMorph,
	#category : #'BlocBenchs-FPS-RawMorph'
}

{ #category : #'instance creation' }
PCRoassalSolidBorderCirclesMorph >> prepareCircle: aCircleShape [

	aCircleShape
		noPaint;
		border: (RSBorder new
			 color: (Color random: random);
			 width: case borderWidth)

]
