//
//  PhotoAlbumViewCell.swift
//  Virtual Tourist
//
//  Created by Sergey Kravtsov on 01.04.17.
//  Copyright © 2017 Sergey Kravtsov. All rights reserved.
//

import UIKit

final class PhotoAlbumViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - Properties
    var taskToCancelIfCellReused: URLSessionTask? {
        didSet {
            if let taskToCancel = oldValue {
                taskToCancel.cancel()
            }
        }
    }
}

