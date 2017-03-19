//
//  PhotoAlbumViewController.swift
//  Virtual Tourist
//
//  Created by Sergey Kravtsov on 19.03.17.
//  Copyright © 2017 Sergey Kravtsov. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class PhotoAlbumViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var toolBarButton: UIBarButtonItem!
}
