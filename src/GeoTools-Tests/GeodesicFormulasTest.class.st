"
A GeodesicFormulasTest is a test class for testing the behavior of GeodesicFormulas
"
Class {
	#name : #GeodesicFormulasTest,
	#superclass : #TestCase,
	#instVars : [
		'geodesicFormulas'
	],
	#category : #'GeoTools-Tests-Geodesic'
}

{ #category : #testing }
GeodesicFormulasTest class >> isAbstract [ 

	^ self == GeodesicFormulasTest 
]

{ #category : #accessing }
GeodesicFormulasTest >> geodesicFormulasClass [

	self subclassResponsibility 
]

{ #category : #running }
GeodesicFormulasTest >> intializeGeodesicFormulas [

	geodesicFormulas := self geodesicFormulasClass new.
]

{ #category : #running }
GeodesicFormulasTest >> setUp [ 

	super setUp.
	self intializeGeodesicFormulas.
]

{ #category : #tests }
GeodesicFormulasTest >> testAbsoluteCoordinatesAlongGeodesicFromToAtFraction [

	| coordinates |
	coordinates := geodesicFormulas
		               absoluteCoordinatesAlongGeodesicFrom:
		               AbsoluteCoordinates zero
		               to: AbsoluteCoordinates zero
		               atFraction: 0.5.

	self assert: coordinates class identicalTo: AbsoluteCoordinates
]

{ #category : #tests }
GeodesicFormulasTest >> testAbsoluteCoordinatesFromDistanceInMetersAzimuthInRadians [

	| coordinates |
	coordinates := geodesicFormulas
		               absoluteCoordinatesFrom: AbsoluteCoordinates zero
		               distanceInMeters: 1000
		               azimuthInRadians: (0 degreesToRadians).
	self assert: coordinates class identicalTo: AbsoluteCoordinates.
	
	"limit cases"
	"at the extreme south-east, when the requested point in on top (0°) need to return a new south-east point"
	coordinates := geodesicFormulas
		               absoluteCoordinatesFrom: (AbsoluteCoordinates latitudeInDegrees: -70 longitudeInDegrees: 180) 
		               distanceInMeters: 500000
		               azimuthInRadians: (0 degreesToRadians).
	self assert: coordinates longitudeInDegrees equals: 180.
	
	"at the extreme north-east, when the requested point in on bottom (180°) need to return a new north-east point"
	coordinates := geodesicFormulas
		               absoluteCoordinatesFrom: (AbsoluteCoordinates latitudeInDegrees: 70 longitudeInDegrees: 180) 
		               distanceInMeters: 500000
		               azimuthInRadians: (180 degreesToRadians).
	self assert: coordinates longitudeInDegrees equals: 180.
	
	"at the extreme north-west, when the requested point in on bottom (180°) need to return a new north-west point"
	coordinates := geodesicFormulas
		               absoluteCoordinatesFrom: (AbsoluteCoordinates latitudeInDegrees: 70 longitudeInDegrees: -180) 
		               distanceInMeters: 500000
		               azimuthInRadians: (180 degreesToRadians).
	self assert: coordinates longitudeInDegrees equals: -180.
	
	"at the extreme south-west, when the requested point in on bottom (180°) need to return a new south-west point"
	coordinates := geodesicFormulas
		               absoluteCoordinatesFrom: (AbsoluteCoordinates latitudeInDegrees: -70 longitudeInDegrees: -180) 
		               distanceInMeters: 500000
		               azimuthInRadians: (0 degreesToRadians).
	self assert: coordinates longitudeInDegrees equals: -180.
]

{ #category : #tests }
GeodesicFormulasTest >> testAzimuthInRadiansFromTo [

	| radians |
	radians := geodesicFormulas
		               azimuthInRadiansFrom: AbsoluteCoordinates zero
		               to: AbsoluteCoordinates zero.

	self assert: radians equals: 0
]

{ #category : #tests }
GeodesicFormulasTest >> testDistanceInMetersFromTo [

	| distance |
	distance := geodesicFormulas
		               distanceInMetersFrom: AbsoluteCoordinates zero
		               to: AbsoluteCoordinates zero.

	self assert: distance equals: 0
]

{ #category : #tests }
GeodesicFormulasTest >> testFastModeFormulas [

	self assert: geodesicFormulas fastModeFormulas class equals: geodesicFormulas class defaultFastModeFormulasClass.
	
	geodesicFormulas fastModeFormulas: GeodesicVincentyFormulas new.
	self assert: geodesicFormulas fastModeFormulas class equals: GeodesicVincentyFormulas.
	
	geodesicFormulas fastModeFormulas: nil.
	self assert: geodesicFormulas fastModeFormulas class equals: geodesicFormulas class defaultFastModeFormulasClass.
	
]

{ #category : #tests }
GeodesicFormulasTest >> testFastModeThresholdInRadians [

	self assert: geodesicFormulas fastModeThresholdInRadians equals: geodesicFormulas class defaultFastModeThresholdInRadians.
	
	geodesicFormulas fastModeThresholdInRadians: 1e-12.
	self assert: geodesicFormulas fastModeThresholdInRadians equals: 1e-12.
	
	geodesicFormulas fastModeThresholdInRadians: nil.
	self assert: geodesicFormulas fastModeThresholdInRadians equals: geodesicFormulas class defaultFastModeThresholdInRadians.
	
]
