//
//  PlaceShapesTests.swift
//  PlaceShapesTests
//
//  Created by Gareth Paul Jones on 2/6/17.
//  Copyright © 2017 Gareth Paul Jones. All rights reserved.
//

import XCTest
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
    
}
