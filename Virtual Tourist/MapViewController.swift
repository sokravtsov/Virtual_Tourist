//
//  MapViewController.swift
//  Virtual Tourist
//
//  Created by Sergey Kravtsov on 17.03.17.
//  Copyright © 2017 Sergey Kravtsov. All rights reserved.
//

import UIKit
import MapKit
import CoreData

// MARK: - MapViewController: UIViewController
final class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, NSFetchedResultsControllerDelegate {
    
    // MARK: - Variables
    var locationManager = CLLocationManager()
    
    enum PresentationState { case configure, on, off }
    var presentationState: Bool!
    
    /* Create a fetchedResultsController to retrieve and monitor changes in CoreDataModel */
    lazy var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>? = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.pin)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: Constants.latitude, ascending: true)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: AppDelegate.stack.context, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }()
    
    // MARK: - Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        self.locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        fetchedResultsController?.delegate = self
        loadPersistedRegion()
        setPersistedLocations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupGesture()
    }
}

//// MARK: - LocationManager
//extension MapViewController {
//    ///Method for update location
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        
//        let location = locations.last
//        
//        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
//        
//        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
//        
//        self.mapView.setRegion(region, animated: true)
//        
//        self.locationManager.stopUpdatingLocation()
//    }
//    
//    ///Method for checking errors
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print ("Errors: " + error.localizedDescription)
//    }
//}

// MARK: - UILongPressGestureRecognizer
extension MapViewController {
    func setupGesture() {
        let uilgr = UILongPressGestureRecognizer(target: self, action: #selector(action))
        self.mapView.addGestureRecognizer(uilgr)
    }
    
    func action(gestureRecognizer:UIGestureRecognizer){
        let touchPoint = gestureRecognizer.location(in: mapView)
        let newCoordinates = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        let annotation = Pin(latitude: newCoordinates.latitude, longitude: newCoordinates.longitude, context: AppDelegate.stack.context)
        self.mapView.addAnnotation(annotation)
        AppDelegate.stack.save()
    }
}

extension MapViewController {
    func executeSearch() {
        if let fc = fetchedResultsController {
            do {
                try fc.performFetch()
            } catch let error as NSError {
                print("Error while trying to perform a search: \n\(error)\n\(String(describing: fetchedResultsController))")
            }
        }
    }
    
    func loadPersistedRegion() {
        if let region = UserDefaults.standard.object(forKey: Constants.region) as AnyObject? {
            let latitude = region[Constants.latitude] as! CLLocationDegrees
            let longitude = region[Constants.longitude] as! CLLocationDegrees
            let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let latDelta = region[Constants.latitudeDelta] as! CLLocationDegrees
            let longDelta = region[Constants.longitudeDelta] as! CLLocationDegrees
            let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
            let updatedRegion = MKCoordinateRegion(center: center, span: span)
            mapView.setRegion(updatedRegion, animated: true)
        }
    }
    
    func setPersistedLocations() {
        executeSearch()
        for pin in fetchedResultsController?.fetchedObjects as! [Pin] {
            mapView.addAnnotation(pin)
        }
    }
}

extension MapViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Identifier.photoAlbum {
            let pin = sender as! Pin
            let nextController = segue.destination as! PhotoAlbumViewController
            nextController.pin = pin
        }
    }
    
    // MARK: - MKMapViewDelegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = ReuseID.pin
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.pinTintColor = .red
            pinView!.animatesDrop = true
            pinView!.isDraggable = true
        } else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        mapView.deselectAnnotation(view.annotation, animated: true)
        let pin = view.annotation as! Pin
        performSegue(withIdentifier: Identifier.photoAlbum, sender: pin)
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let persistedRegion = [
            Constants.latitude : mapView.region.center.latitude,
            Constants.longitude : mapView.region.center.longitude,
            Constants.latitudeDelta : mapView.region.span.latitudeDelta,
            Constants.longitudeDelta : mapView.region.span.longitudeDelta
        ]
        UserDefaults.standard.set(persistedRegion, forKey: Constants.region)
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState) {
        if newState == .ending {
            let annotation = view.annotation as! Pin
            mapView.addAnnotation(annotation)
            AppDelegate.stack.save()
        }
    }
}

extension MapViewController {
    // MARK: - NSFetchedResultsControllerDelegate
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    }
}
