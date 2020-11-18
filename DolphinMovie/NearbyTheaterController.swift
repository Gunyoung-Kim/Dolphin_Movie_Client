//
//  NearbyTheaterController.swift
//  DolphinMovie
//
//  Created by 김건영 on 2020/10/05.
//

import UIKit
import MapKit
import NMapsMap


class NearbyTheaterController: UIViewController,CLLocationManagerDelegate {
    @IBOutlet var map: MKMapView!
    let MAP_SIZE: CLLocationDistance = 400
    var nearTheater: [CLLocationCoordinate2D]?
    let locationManager = CLLocationManager()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.locationManager.startUpdatingLocation()
        self.updateLoctionPoint()
    }
    
    override func viewDidLoad() {
        locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.startUpdatingLocation()
        self.updateLoctionPoint()
    }
    
    func updateLoctionPoint() {
        guard let coor = self.locationManager.location?.coordinate else {
            return
        }
        
        let lat = coor.latitude
        let long = coor.longitude
        
        let loc = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
        let regionrad: CLLocationDistance = self.MAP_SIZE
        
        let coordinateRegion = MKCoordinateRegion(center: loc, latitudinalMeters: regionrad, longitudinalMeters: regionrad)
        
        self.map.setRegion(coordinateRegion, animated: true)
        
        let point = MKPointAnnotation()
        
        point.coordinate = loc
        self.map.addAnnotation(point)
    }
}

