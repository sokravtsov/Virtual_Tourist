//
//  MapViewController.swift
//  Virtual Tourist
//
//  Created by Sergey Kravtsov on 17.03.17.
//  Copyright © 2017 Sergey Kravtsov. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

// MARK: - MapViewController: UIViewController
class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    // MARK: - Variables
    var locationManager = CLLocationManager()
    
    // MARK: - Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
//        self.mapView.showsUserLocation = true
//        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupGesture()
    }
}

// MARK: - LocationManager
extension MapViewController {
    ///Method for update location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        
        self.mapView.setRegion(region, animated: true)
        
        self.locationManager.stopUpdatingLocation()
    }
    
    ///Method for checking errors
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print ("Errors: " + error.localizedDescription)
    }
}

// MARK: - UILongPressGestureRecognizer
extension MapViewController {
    func setupGesture() {
        let uilgr = UILongPressGestureRecognizer(target: self, action: #selector(action))
        uilgr.minimumPressDuration = 1.0
        self.mapView.addGestureRecognizer(uilgr)
    }
    
    func action(gestureRecognizer:UIGestureRecognizer){
        let touchPoint = gestureRecognizer.location(in: mapView)
        let newCoordinates = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        let annotation = MKPointAnnotation()
        annotation.coordinate = newCoordinates
        mapView.addAnnotation(annotation)
    }
}

