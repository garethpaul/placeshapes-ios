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
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            mapView.isUserInteractionEnabled = false
        }
        else {
            // Enable the map to move
            mapView.isUserInteractionEnabled = true
        }
    }
    
    // MARK: - Handle Touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // If editing
        if isEditing {
            // Empty array
            coordinates.removeAll()
            
            // Convert touches to map coordinates
            for touch in touches {
                let coordinate = mapView.convert(touch.location(in: mapView), toCoordinateFrom: mapView)
                coordinates.append(coordinate)
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // If editing
        if isEditing {
            // Convert touches to map coordinates
            for touch in touches {
                // Use this method to convert a CGPoint to CLLocationCoordinate2D
                let coordinate = mapView.convert(touch.location(in: mapView), toCoordinateFrom: mapView)
                // Add the coordinate to the array
                coordinates.append(coordinate)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // If editing
        if isEditing {
            // Convert touches to map coordinates
            for touch in touches {
                let coordinate = mapView.convert(touch.location(in: mapView), toCoordinateFrom: mapView)
                coordinates.append(coordinate)
            }
            
            // Remove existing polygon
            mapView.remove(polygon)
            
            // Create new polygon
            print(coordinates)
            polygon = MKPolygon(coordinates: &coordinates, count: coordinates.count)
            
            // Add polygon to map
            mapView.add(polygon)
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        // If editing
        if isEditing {
            // Do nothing
        }
    }
}

