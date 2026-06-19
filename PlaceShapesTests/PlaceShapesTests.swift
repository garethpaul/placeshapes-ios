//
//  PlaceShapesTests.swift
//  PlaceShapesTests
//
//  Created by Gareth Paul Jones on 2/6/17.
//  Copyright © 2017 Gareth Paul Jones. All rights reserved.
//

import XCTest
import CoreLocation
@testable import PlaceShapes

class PlaceShapesTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPolygonRenderingRequiresAtLeastThreeCoordinates() {
        XCTAssertFalse(PlaceShapes.shouldRenderPolygon(coordinateCount: 0))
        XCTAssertFalse(PlaceShapes.shouldRenderPolygon(coordinateCount: 1))
        XCTAssertFalse(PlaceShapes.shouldRenderPolygon(coordinateCount: 2))
        XCTAssertTrue(PlaceShapes.shouldRenderPolygon(coordinateCount: 3))
    }

    func testPolygonRenderingRejectsNegativeCoordinateCounts() {
        XCTAssertFalse(PlaceShapes.shouldRenderPolygon(coordinateCount: -1))
    }

    func testPolygonRenderingAcceptsValidCoordinates() {
        let coordinates = [
            CLLocationCoordinate2D(latitude: 37.0, longitude: -122.0),
            CLLocationCoordinate2D(latitude: 37.1, longitude: -122.1),
            CLLocationCoordinate2D(latitude: 37.2, longitude: -122.15),
        ]

        XCTAssertTrue(PlaceShapes.shouldRenderPolygon(coordinates: coordinates))
    }

    func testPolygonRenderingRejectsInvalidLatitude() {
        let coordinates = [
            CLLocationCoordinate2D(latitude: 37.0, longitude: -122.0),
            CLLocationCoordinate2D(latitude: 91.0, longitude: -122.1),
            CLLocationCoordinate2D(latitude: 37.2, longitude: -122.2),
        ]

        XCTAssertFalse(PlaceShapes.shouldRenderPolygon(coordinates: coordinates))
    }

    func testPolygonRenderingRejectsInvalidLongitude() {
        let coordinates = [
            CLLocationCoordinate2D(latitude: 37.0, longitude: -122.0),
            CLLocationCoordinate2D(latitude: 37.1, longitude: 181.0),
            CLLocationCoordinate2D(latitude: 37.2, longitude: -122.2),
        ]

        XCTAssertFalse(PlaceShapes.shouldRenderPolygon(coordinates: coordinates))
    }

    func testPolygonRenderingRejectsRepeatedNonAdjacentCoordinate() {
        let coordinates = [
            CLLocationCoordinate2D(latitude: 37.0, longitude: -122.0),
            CLLocationCoordinate2D(latitude: 37.1, longitude: -122.1),
            CLLocationCoordinate2D(latitude: 37.0, longitude: -122.0),
            CLLocationCoordinate2D(latitude: 37.2, longitude: -122.15),
        ]

        XCTAssertFalse(PlaceShapes.shouldRenderPolygon(coordinates: coordinates))
    }

    func testPolygonRenderingRejectsOnlyTwoDistinctCoordinates() {
        let coordinates = [
            CLLocationCoordinate2D(latitude: 37.0, longitude: -122.0),
            CLLocationCoordinate2D(latitude: 37.1, longitude: -122.1),
            CLLocationCoordinate2D(latitude: 37.0, longitude: -122.0),
        ]

        XCTAssertFalse(PlaceShapes.shouldRenderPolygon(coordinates: coordinates))
    }

    func testPolygonRenderingRejectsOneRepeatedCoordinate() {
        let coordinates = [
            CLLocationCoordinate2D(latitude: 37.0, longitude: -122.0),
            CLLocationCoordinate2D(latitude: 37.0, longitude: -122.0),
            CLLocationCoordinate2D(latitude: 37.0, longitude: -122.0),
        ]

        XCTAssertFalse(PlaceShapes.shouldRenderPolygon(coordinates: coordinates))
    }

    func testPolygonRenderingRejectsDistinctCollinearCoordinates() {
        let horizontalCoordinates = [
            CLLocationCoordinate2D(latitude: 37.0, longitude: -122.0),
            CLLocationCoordinate2D(latitude: 37.0, longitude: -121.9),
            CLLocationCoordinate2D(latitude: 37.0, longitude: -121.8),
        ]
        let diagonalCoordinates = [
            CLLocationCoordinate2D(latitude: 37.0, longitude: -122.0),
            CLLocationCoordinate2D(latitude: 37.1, longitude: -122.1),
            CLLocationCoordinate2D(latitude: 37.2, longitude: -122.2),
        ]

        XCTAssertFalse(PlaceShapes.shouldRenderPolygon(coordinates: horizontalCoordinates))
        XCTAssertFalse(PlaceShapes.shouldRenderPolygon(coordinates: diagonalCoordinates))
    }

    func testPolygonRenderingRejectsAdjacentDuplicateCoordinate() {
        let coordinates = [
            CLLocationCoordinate2D(latitude: 37.0, longitude: -122.0),
            CLLocationCoordinate2D(latitude: 37.0, longitude: -122.0),
            CLLocationCoordinate2D(latitude: 37.1, longitude: -122.0),
            CLLocationCoordinate2D(latitude: 37.0, longitude: -121.9),
        ]

        XCTAssertFalse(PlaceShapes.shouldRenderPolygon(coordinates: coordinates))
    }

    func testPolygonRenderingRejectsExplicitClosingCoordinate() {
        let coordinates = [
            CLLocationCoordinate2D(latitude: 37.0, longitude: -122.0),
            CLLocationCoordinate2D(latitude: 37.1, longitude: -122.0),
            CLLocationCoordinate2D(latitude: 37.0, longitude: -121.9),
            CLLocationCoordinate2D(latitude: 37.0, longitude: -122.0),
        ]

        XCTAssertFalse(PlaceShapes.shouldRenderPolygon(coordinates: coordinates))
    }

    func testPolygonRenderingRejectsSelfIntersectingCoordinates() {
        let bowTieCoordinates = [
            CLLocationCoordinate2D(latitude: 37.0, longitude: -122.0),
            CLLocationCoordinate2D(latitude: 37.1, longitude: -121.9),
            CLLocationCoordinate2D(latitude: 37.0, longitude: -121.9),
            CLLocationCoordinate2D(latitude: 37.1, longitude: -122.0),
        ]
        let overlappingCoordinates = [
            CLLocationCoordinate2D(latitude: 37.0, longitude: -122.0),
            CLLocationCoordinate2D(latitude: 37.0, longitude: -121.7),
            CLLocationCoordinate2D(latitude: 37.1, longitude: -121.8),
            CLLocationCoordinate2D(latitude: 37.0, longitude: -121.9),
            CLLocationCoordinate2D(latitude: 37.0, longitude: -121.8),
        ]

        XCTAssertFalse(PlaceShapes.shouldRenderPolygon(coordinates: bowTieCoordinates))
        XCTAssertFalse(PlaceShapes.shouldRenderPolygon(coordinates: overlappingCoordinates))
    }

    func testPolygonRenderingAcceptsConcaveCoordinates() {
        let coordinates = [
            CLLocationCoordinate2D(latitude: 37.0, longitude: -122.0),
            CLLocationCoordinate2D(latitude: 37.1, longitude: -122.0),
            CLLocationCoordinate2D(latitude: 37.05, longitude: -121.95),
            CLLocationCoordinate2D(latitude: 37.1, longitude: -121.9),
            CLLocationCoordinate2D(latitude: 37.0, longitude: -121.9),
        ]

        XCTAssertTrue(PlaceShapes.shouldRenderPolygon(coordinates: coordinates))
    }

    func testPolygonRenderingAcceptsSmallNonCollinearCoordinates() {
        let coordinates = [
            CLLocationCoordinate2D(latitude: 37.0, longitude: -122.0),
            CLLocationCoordinate2D(latitude: 37.0, longitude: -121.9999999),
            CLLocationCoordinate2D(latitude: 37.0000001, longitude: -121.9999999),
            CLLocationCoordinate2D(latitude: 37.0000001, longitude: -122.0),
        ]

        XCTAssertTrue(PlaceShapes.shouldRenderPolygon(coordinates: coordinates))
    }

    func testPolygonRenderingAcceptsSimpleDatelineCrossingCoordinates() {
        let coordinates = [
            CLLocationCoordinate2D(latitude: 10.0, longitude: 179.0),
            CLLocationCoordinate2D(latitude: 11.0, longitude: 179.0),
            CLLocationCoordinate2D(latitude: 10.5, longitude: -179.5),
            CLLocationCoordinate2D(latitude: 11.0, longitude: -179.0),
            CLLocationCoordinate2D(latitude: 10.0, longitude: -179.0),
        ]

        XCTAssertTrue(PlaceShapes.shouldRenderPolygon(coordinates: coordinates))
    }

    func testPolygonRenderingRejectsEquivalentDatelineDuplicateCoordinate() {
        let coordinates = [
            CLLocationCoordinate2D(latitude: 0.0, longitude: 180.0),
            CLLocationCoordinate2D(latitude: 1.0, longitude: 179.0),
            CLLocationCoordinate2D(latitude: 0.0, longitude: -180.0),
            CLLocationCoordinate2D(latitude: -1.0, longitude: 179.0),
        ]

        XCTAssertFalse(PlaceShapes.shouldRenderPolygon(coordinates: coordinates))
    }

    func testEquivalentDatelineLongitudesAreEqual() {
        let positiveDateline = CLLocationCoordinate2D(latitude: 0.0, longitude: 180.0)
        let negativeDateline = CLLocationCoordinate2D(latitude: 0.0, longitude: -180.0)

        XCTAssertTrue(PlaceShapes.coordinatesAreEqual(positiveDateline, negativeDateline))
    }

    func testBeginningPolygonDraftClearsCoordinates() {
        let controller = PlaceShapes()
        controller.coordinates = [
            CLLocationCoordinate2D(latitude: 37.0, longitude: -122.0),
        ]

        controller.beginPolygonDraft()

        XCTAssertEqual(controller.coordinates.count, 0)
    }

    func testCancellingPolygonDraftClearsCoordinates() {
        let controller = PlaceShapes()
        controller.coordinates = [
            CLLocationCoordinate2D(latitude: 37.0, longitude: -122.0),
        ]

        controller.cancelPolygonDraft()

        XCTAssertEqual(controller.coordinates.count, 0)
    }

    func testLeavingEditingClearsPolygonDraftCoordinates() {
        let controller = PlaceShapes()
        controller.coordinates = [
            CLLocationCoordinate2D(latitude: 37.0, longitude: -122.0),
        ]

        controller.setEditing(false, animated: false)

        XCTAssertEqual(controller.coordinates.count, 0)
    }

    func testInvalidPolygonFinalizationClearsDraftCoordinates() {
        let controller = PlaceShapes()
        controller.coordinates = [
            CLLocationCoordinate2D(latitude: 37.0, longitude: -122.0),
            CLLocationCoordinate2D(latitude: 37.1, longitude: -122.1),
        ]

        XCTAssertNil(controller.finalizePolygonDraft())
        XCTAssertEqual(controller.coordinates.count, 0)
    }

    func testSuccessfulPolygonFinalizationClearsDraftCoordinates() {
        let controller = PlaceShapes()
        controller.coordinates = [
            CLLocationCoordinate2D(latitude: 37.0, longitude: -122.0),
            CLLocationCoordinate2D(latitude: 37.1, longitude: -122.1),
            CLLocationCoordinate2D(latitude: 37.2, longitude: -122.15),
        ]

        XCTAssertNotNil(controller.finalizePolygonDraft())
        XCTAssertEqual(controller.coordinates.count, 0)
    }

    func testCollinearPolygonFinalizationClearsDraftCoordinates() {
        let controller = PlaceShapes()
        controller.coordinates = [
            CLLocationCoordinate2D(latitude: 37.0, longitude: -122.0),
            CLLocationCoordinate2D(latitude: 37.1, longitude: -122.1),
            CLLocationCoordinate2D(latitude: 37.2, longitude: -122.2),
        ]

        XCTAssertNil(controller.finalizePolygonDraft())
        XCTAssertEqual(controller.coordinates.count, 0)
    }

    func testSelfIntersectingPolygonFinalizationClearsDraftCoordinates() {
        let controller = PlaceShapes()
        controller.coordinates = [
            CLLocationCoordinate2D(latitude: 37.0, longitude: -122.0),
            CLLocationCoordinate2D(latitude: 37.1, longitude: -121.9),
            CLLocationCoordinate2D(latitude: 37.0, longitude: -121.9),
            CLLocationCoordinate2D(latitude: 37.1, longitude: -122.0),
        ]

        XCTAssertNil(controller.finalizePolygonDraft())
        XCTAssertEqual(controller.coordinates.count, 0)
    }

    func testZeroLengthEdgePolygonFinalizationClearsDraftCoordinates() {
        let controller = PlaceShapes()
        controller.coordinates = [
            CLLocationCoordinate2D(latitude: 37.0, longitude: -122.0),
            CLLocationCoordinate2D(latitude: 37.0, longitude: -122.0),
            CLLocationCoordinate2D(latitude: 37.1, longitude: -122.0),
            CLLocationCoordinate2D(latitude: 37.0, longitude: -121.9),
        ]

        XCTAssertNil(controller.finalizePolygonDraft())
        XCTAssertEqual(controller.coordinates.count, 0)
    }

    func testInvalidCoordinateFinalizationClearsDraftCoordinates() {
        let controller = PlaceShapes()
        controller.coordinates = [
            CLLocationCoordinate2D(latitude: 37.0, longitude: -122.0),
            CLLocationCoordinate2D(latitude: 91.0, longitude: -122.1),
            CLLocationCoordinate2D(latitude: 37.2, longitude: -122.2),
        ]

        XCTAssertNil(controller.finalizePolygonDraft())
        XCTAssertEqual(controller.coordinates.count, 0)
    }

    func testCancelledTouchesClearDraftCoordinatesOutsideEditing() {
        let controller = PlaceShapes()
        controller.coordinates = [
            CLLocationCoordinate2D(latitude: 37.0, longitude: -122.0),
        ]

        controller.touchesCancelled(Set<UITouch>(), with: nil)

        XCTAssertEqual(controller.coordinates.count, 0)
    }

    func testUnavailableTouchInputMapClearsDraftCoordinates() {
        let controller = PlaceShapes()
        controller.coordinates = [
            CLLocationCoordinate2D(latitude: 37.0, longitude: -122.0),
        ]

        XCTAssertNil(controller.mapViewForTouchInput())
        XCTAssertEqual(controller.coordinates.count, 0)
    }
    
}
