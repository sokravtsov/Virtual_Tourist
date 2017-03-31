//
//  Animations.swift
//  Virtual Tourist
//
//  Created by Sergey Kravtsov on 01.04.17.
//  Copyright © 2017 Sergey Kravtsov. All rights reserved.
//

import UIKit
import Foundation

fileprivate protocol AnimationView {
    static func hide(view: UIView, alpha: Int)
}

final class Animations: AnimationView {
    static func hide(view: UIView, alpha: Int) {
        let duration = Animation.Duration.medium
        UIView.animate(withDuration: TimeInterval(duration),
                       delay: TimeInterval(0),
                       options: [UIViewAnimationOptions.allowUserInteraction, UIViewAnimationOptions.beginFromCurrentState],
                       animations: {
                        view.alpha = CGFloat(alpha)
        }, completion: { (_) in
            view.removeFromSuperview()
        })
    }
}
