//
//  AppDelegate.swift
//  Virtual Tourist
//
//  Created by Sergey Kravtsov on 17.03.17.
//  Copyright © 2017 Sergey Kravtsov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    static let stack = CoreDataStack(modelName: "Model")!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        return true
    }
}
