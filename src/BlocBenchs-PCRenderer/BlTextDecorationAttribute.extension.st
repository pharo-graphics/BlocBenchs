Extension { #name : #BlTextDecorationAttribute }

{ #category : #'*BlocBenchs-PCRenderer' }
BlTextDecorationAttribute >> pureCairoDrawAboveOn: aPCCanvas with: aBlTextParagraphSpan [
	"I render an underline above the text span"

"	aSpartaCanvas stroke
		paint: self color;
		path: (self lineOnSpartaCanvas: aSpartaCanvas with: aSpartaSpan);
		width: self thickness;
		draw"
	1halt
]
