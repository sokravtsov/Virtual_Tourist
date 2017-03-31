//
//  PhotoAlbumViewCell.swift
//  Virtual Tourist
//
//  Created by Sergey Kravtsov on 01.04.17.
//  Copyright © 2017 Sergey Kravtsov. All rights reserved.
//

import UIKit

class PhotoAlbumViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    // MARK: - Variables 
    var taskToCancelIfCellReused: URLSessionTask? {
        didSet {
            if let taskToCancel = oldValue {
                taskToCancel.cancel()
            }
        }
    }
}

