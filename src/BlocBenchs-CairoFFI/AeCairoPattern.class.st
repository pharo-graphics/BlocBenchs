"
I am a Cairo FFI binding for `cairo_pattern_t`.
A `cairo_pattern_t` represents a source when drawing onto a surface.

See: https://www.cairographics.org/manual/cairo-cairo-pattern-t.html
"
Class {
	#name : #AeCairoPattern,
	#superclass : #FFIExternalObject,
	#traits : 'AeTCairoLibrary',
	#classTraits : 'AeTCairoLibrary classTrait',
	#category : #'BlocBenchs-CairoFFI-Core'
}
