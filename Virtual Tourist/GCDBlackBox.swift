//
//  GCDBlackBox.swift
//  Virtual Tourist
//
//  Created by Sergey Kravtsov on 31.03.17.
//  Copyright © 2017 Sergey Kravtsov. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
