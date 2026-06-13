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
            CLLocationCoordinate2D(latitude: 37.2, longitude: -122.2),
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
            CLLocationCoordinate2D(latitude: 37.2, longitude: -122.2),
        ]

        XCTAssertNotNil(controller.finalizePolygonDraft())
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
