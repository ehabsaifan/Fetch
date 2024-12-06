//
//  AppDelegate.swift
//  Fetch Recipes
//
//  Created by Ehab Saifan on 12/2/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var fileHandler: FileHandler!
    var imageStorageManager: ImageStorageManager!
    var networkManager: NetworkManager!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        setup()
        
        return true
    }
 
    private func setup() {
        networkManager = NetworkManager()
        fileHandler = FileHandler()
        imageStorageManager = ImageStorageManager()
    }
}

