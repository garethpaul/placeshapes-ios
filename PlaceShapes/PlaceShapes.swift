//
//  ViewController.swift
//  PlaceShapes
//
//

import UIKit
import MapKit

class PlaceShapes: UIViewController, MKMapViewDelegate {
    
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
        return hasAtLeastThreeDistinctCoordinates(coordinates)
    }

    static func hasAtLeastThreeDistinctCoordinates(_ coordinates: [CLLocationCoordinate2D]) -> Bool {
        var distinctCoordinates = [CLLocationCoordinate2D]()
        for coordinate in coordinates {
            var alreadyRecorded = false
            for existingCoordinate in distinctCoordinates {
                if existingCoordinate.latitude == coordinate.latitude &&
                    existingCoordinate.longitude == coordinate.longitude {
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
            touchMapView.remove(polygon)
            
            // Create new polygon
            polygon = nextPolygon
            
            // Add polygon to map
            touchMapView.add(polygon)
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        cancelPolygonDraft()
    }
}
