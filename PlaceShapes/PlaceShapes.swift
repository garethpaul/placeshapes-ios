//
//  ViewController.swift
//  PlaceShapes
//
//

import UIKit
import MapKit

class PlaceShapes: UIViewController, MKMapViewDelegate {
    static let polygonIntersectionTolerance = 0.000000000001
    
    // Map View
    @IBOutlet var mapView:MKMapView!
    
    // Array for holding coordinates
    var coordinates = [CLLocationCoordinate2D]()
    // Polygon to draw on map
    var polygon = MKPolygon()

    static func shouldRenderPolygon(coordinateCount: Int) -> Bool {
        return coordinateCount >= 3
    }

    static func shouldRenderPolygon(coordinates: [CLLocationCoordinate2D]) -> Bool {
        guard shouldRenderPolygon(coordinateCount: coordinates.count) else {
            return false
        }

        for coordinate in coordinates {
            if !CLLocationCoordinate2DIsValid(coordinate) {
                return false
            }
        }
        let validationCoordinates = coordinatesWithUnwrappedLongitudes(coordinates)
        return hasAtLeastThreeDistinctCoordinates(coordinates) &&
            hasNonzeroPolygonEdges(coordinates) &&
            hasAtLeastThreeNonCollinearCoordinates(validationCoordinates) &&
            hasSimplePolygonRing(validationCoordinates)
    }

    static func coordinatesAreEqual(
        _ firstCoordinate: CLLocationCoordinate2D,
        _ secondCoordinate: CLLocationCoordinate2D
    ) -> Bool {
        return firstCoordinate.latitude == secondCoordinate.latitude &&
            canonicalLongitude(firstCoordinate.longitude) == canonicalLongitude(secondCoordinate.longitude)
    }

    static func canonicalLongitude(_ longitude: CLLocationDegrees) -> CLLocationDegrees {
        return longitude == 180.0 ? -180.0 : longitude
    }

    static func coordinatesWithUnwrappedLongitudes(
        _ coordinates: [CLLocationCoordinate2D]
    ) -> [CLLocationCoordinate2D] {
        guard let firstCoordinate = coordinates.first else {
            return []
        }

        var unwrappedCoordinates = [firstCoordinate]
        for coordinate in coordinates.dropFirst() {
            var longitude = coordinate.longitude
            let previousLongitude = unwrappedCoordinates[unwrappedCoordinates.count - 1].longitude
            while longitude - previousLongitude > 180.0 {
                longitude -= 360.0
            }
            while longitude - previousLongitude < -180.0 {
                longitude += 360.0
            }
            unwrappedCoordinates.append(CLLocationCoordinate2D(
                latitude: coordinate.latitude,
                longitude: longitude
            ))
        }
        return unwrappedCoordinates
    }

    static func hasAtLeastThreeDistinctCoordinates(_ coordinates: [CLLocationCoordinate2D]) -> Bool {
        var distinctCoordinates = [CLLocationCoordinate2D]()
        for coordinate in coordinates {
            var alreadyRecorded = false
            for existingCoordinate in distinctCoordinates {
                if coordinatesAreEqual(existingCoordinate, coordinate) {
                    alreadyRecorded = true
                    break
                }
            }
            if !alreadyRecorded {
                distinctCoordinates.append(coordinate)
                if distinctCoordinates.count == 3 {
                    return true
                }
            }
        }
        return false
    }

    static func hasNonzeroPolygonEdges(_ coordinates: [CLLocationCoordinate2D]) -> Bool {
        guard coordinates.count >= 3 else {
            return false
        }

        for startIndex in 0..<coordinates.count {
            let endIndex = (startIndex + 1) % coordinates.count
            if coordinatesAreEqual(coordinates[startIndex], coordinates[endIndex]) {
                return false
            }
        }
        return true
    }

    static func hasAtLeastThreeNonCollinearCoordinates(_ coordinates: [CLLocationCoordinate2D]) -> Bool {
        guard let firstCoordinate = coordinates.first else {
            return false
        }

        var secondCoordinate: CLLocationCoordinate2D?
        for coordinate in coordinates {
            if coordinate.latitude != firstCoordinate.latitude ||
                coordinate.longitude != firstCoordinate.longitude {
                secondCoordinate = coordinate
                break
            }
        }
        guard let distinctSecondCoordinate = secondCoordinate else {
            return false
        }

        for coordinate in coordinates {
            if orientation(firstCoordinate, distinctSecondCoordinate, coordinate) != 0 {
                return true
            }
        }
        return false
    }

    static func hasSimplePolygonRing(_ coordinates: [CLLocationCoordinate2D]) -> Bool {
        let coordinateCount = coordinates.count
        guard coordinateCount >= 3 else {
            return false
        }

        for firstEdgeStartIndex in 0..<coordinateCount {
            let firstEdgeEndIndex = (firstEdgeStartIndex + 1) % coordinateCount
            for secondEdgeStartIndex in (firstEdgeStartIndex + 1)..<coordinateCount {
                let secondEdgeEndIndex = (secondEdgeStartIndex + 1) % coordinateCount
                if firstEdgeEndIndex == secondEdgeStartIndex ||
                    secondEdgeEndIndex == firstEdgeStartIndex {
                    continue
                }
                if segmentsIntersect(
                    coordinates[firstEdgeStartIndex],
                    coordinates[firstEdgeEndIndex],
                    coordinates[secondEdgeStartIndex],
                    coordinates[secondEdgeEndIndex]
                ) {
                    return false
                }
            }
        }
        return true
    }

    static func segmentsIntersect(
        _ firstStart: CLLocationCoordinate2D,
        _ firstEnd: CLLocationCoordinate2D,
        _ secondStart: CLLocationCoordinate2D,
        _ secondEnd: CLLocationCoordinate2D
    ) -> Bool {
        let firstStartOrientation = orientation(firstStart, firstEnd, secondStart)
        let firstEndOrientation = orientation(firstStart, firstEnd, secondEnd)
        let secondStartOrientation = orientation(secondStart, secondEnd, firstStart)
        let secondEndOrientation = orientation(secondStart, secondEnd, firstEnd)

        if firstStartOrientation != 0 && firstEndOrientation != 0 &&
            secondStartOrientation != 0 && secondEndOrientation != 0 &&
            firstStartOrientation != firstEndOrientation &&
            secondStartOrientation != secondEndOrientation {
            return true
        }
        if firstStartOrientation == 0 && isCoordinate(secondStart, onSegmentFrom: firstStart, to: firstEnd) {
            return true
        }
        if firstEndOrientation == 0 && isCoordinate(secondEnd, onSegmentFrom: firstStart, to: firstEnd) {
            return true
        }
        if secondStartOrientation == 0 && isCoordinate(firstStart, onSegmentFrom: secondStart, to: secondEnd) {
            return true
        }
        return secondEndOrientation == 0 &&
            isCoordinate(firstEnd, onSegmentFrom: secondStart, to: secondEnd)
    }

    static func orientation(
        _ first: CLLocationCoordinate2D,
        _ second: CLLocationCoordinate2D,
        _ third: CLLocationCoordinate2D
    ) -> Int {
        let crossProduct =
            (second.longitude - first.longitude) * (third.latitude - first.latitude) -
            (second.latitude - first.latitude) * (third.longitude - first.longitude)
        let crossProductScale =
            abs((second.longitude - first.longitude) * (third.latitude - first.latitude)) +
            abs((second.latitude - first.latitude) * (third.longitude - first.longitude))
        if abs(crossProduct) <= crossProductScale * polygonIntersectionTolerance {
            return 0
        }
        return crossProduct > 0 ? 1 : -1
    }

    static func isCoordinate(
        _ coordinate: CLLocationCoordinate2D,
        onSegmentFrom start: CLLocationCoordinate2D,
        to end: CLLocationCoordinate2D
    ) -> Bool {
        return coordinate.longitude >= min(start.longitude, end.longitude) - polygonIntersectionTolerance &&
            coordinate.longitude <= max(start.longitude, end.longitude) + polygonIntersectionTolerance &&
            coordinate.latitude >= min(start.latitude, end.latitude) - polygonIntersectionTolerance &&
            coordinate.latitude <= max(start.latitude, end.latitude) + polygonIntersectionTolerance
    }

    func beginPolygonDraft() {
        coordinates.removeAll()
    }

    func cancelPolygonDraft() {
        coordinates.removeAll()
    }

    func mapViewForTouchInput() -> MKMapView? {
        guard let touchMapView = mapView else {
            cancelPolygonDraft()
            return nil
        }
        return touchMapView
    }

    func finalizePolygonDraft() -> MKPolygon? {
        guard PlaceShapes.shouldRenderPolygon(coordinates: coordinates) else {
            cancelPolygonDraft()
            return nil
        }

        var draftCoordinates = coordinates
        cancelPolygonDraft()
        return MKPolygon(coordinates: &draftCoordinates, count: draftCoordinates.count)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView?.delegate = self
        // Add an edit button to the navigation bar
        navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: Customize the drawing of the map overlay
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        // Create polygon renderer
        let renderer = MKPolygonRenderer(overlay: overlay)
        
        
        // Set the line color
        renderer.strokeColor = UIColor.purple
        renderer.fillColor = UIColor.blue.withAlphaComponent(0.4)

        
        // Set the line width
        renderer.lineWidth = 1.0
        renderer.lineDashPattern = [2,3]
        
        // Return the customized renderer
        return renderer
    }
    
    // MARK: - Get notified when the view begins/ends editing
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if editing {
            // Disable the map from moving
            mapView?.isUserInteractionEnabled = false
        }
        else {
            cancelPolygonDraft()
            // Enable the map to move
            mapView?.isUserInteractionEnabled = true
        }
    }
    
    // MARK: - Handle Touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // If editing
        if isEditing {
            guard let touchMapView = mapViewForTouchInput() else {
                return
            }
            // Empty array
            beginPolygonDraft()
            
            // Convert touches to map coordinates
            for touch in touches {
                let coordinate = touchMapView.convert(touch.location(in: touchMapView), toCoordinateFrom: touchMapView)
                coordinates.append(coordinate)
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // If editing
        if isEditing {
            guard let touchMapView = mapViewForTouchInput() else {
                return
            }
            // Convert touches to map coordinates
            for touch in touches {
                // Use this method to convert a CGPoint to CLLocationCoordinate2D
                let coordinate = touchMapView.convert(touch.location(in: touchMapView), toCoordinateFrom: touchMapView)
                // Add the coordinate to the array
                coordinates.append(coordinate)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // If editing
        if isEditing {
            guard let touchMapView = mapViewForTouchInput() else {
                return
            }
            // Convert touches to map coordinates
            for touch in touches {
                let coordinate = touchMapView.convert(touch.location(in: touchMapView), toCoordinateFrom: touchMapView)
                coordinates.append(coordinate)
            }

            guard let nextPolygon = finalizePolygonDraft() else {
                return
            }
            
            // Remove existing polygon
            #if swift(>=4.2)
                touchMapView.removeOverlay(polygon)
            #else
                touchMapView.remove(polygon)
            #endif
            
            // Create new polygon
            polygon = nextPolygon
            
            // Add polygon to map
            #if swift(>=4.2)
                touchMapView.addOverlay(polygon)
            #else
                touchMapView.add(polygon)
            #endif
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        cancelPolygonDraft()
    }
}
