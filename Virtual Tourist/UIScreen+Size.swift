//
//  UIScreen+Size.swift
//  Virtual Tourist
//
//  Created by Sergey Kravtsov on 01.04.17.
//  Copyright © 2017 Sergey Kravtsov. All rights reserved.
//

import UIKit
import Foundation

extension UIScreen {
    static func screenBounds() -> CGRect {
        return UIScreen.main.bounds
    }
    
    static func screenWidth() -> CGFloat {
        return UIScreen.main.bounds.width
    }
    
    static func screenHeight() -> CGFloat {
        return UIScreen.main.bounds.height
    }
}
