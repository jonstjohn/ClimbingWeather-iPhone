//
//  AreaMapViewController.swift
//  climbingweather
//
//  Created by Jon St. John on 3/2/17.
//
//

import Foundation
import UIKit
import MapKit

class AreaMapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet var mapView: MKMapView!
    
    var areaId: Int?
    var area: Area?
    
    override func viewDidLoad() {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.tabBarController?.title = self.area?.name
        self.navigationController?.isNavigationBarHidden = false
        
        super.viewWillAppear(animated)
        self.mapView.delegate = self
        
        self.update()
        
    }
    
    func update() {
        
        guard let areaId = self.areaId else {
            return
        }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        Area.fetchDetail(id: areaId, completion: { (area) in
            self.area = area
            
            DispatchQueue.main.async { [weak self] in
                
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                guard let strongSelf = self,
                    let latitude = area.latitude,
                    let latitudeDouble = Double(latitude),
                    let longitude = area.longitude,
                    let longitudeDouble = Double(longitude) else {
                    return
                }
                
                let coordinate = CLLocationCoordinate2D(latitude: latitudeDouble, longitude: longitudeDouble)

                strongSelf.mapView.addAnnotation(MapPoint(coordinate: coordinate, title: area.name))
                
            }
            
        })
    }
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        
        let annotationView = views[0]
        guard let mp = annotationView.annotation as? MapPoint else {
            return
        }
        
        let region = MKCoordinateRegion.init(center: mp.coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        mapView.setRegion(region, animated: false)
        mapView.isHidden = false
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let identifier = "climbing_area"
        if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
            return annotationView
        }
        
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        annotationView.image = UIImage(named: "climbing")
        annotationView.canShowCallout = true
        return annotationView
        
    }
    
    
}

class MapPoint: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    
    public init(coordinate: CLLocationCoordinate2D, title: String) {
        self.coordinate = coordinate
        self.title = title
    }
}
