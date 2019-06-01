//
//  AppDelegate.swift
//  Todoey
//
//  Created by Jack Calo on 5/25/19.
//  Copyright © 2019 Jack Calo. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        
        // Realm Save Data
        // print (Realm.Configuration.defaultConfiguration.fileURL)
        
        do {
            _ = try Realm()
            }
        catch {
            print ("Error instantiating a Realm database: \(error)")
        }
        
        
        return true
    }


}

