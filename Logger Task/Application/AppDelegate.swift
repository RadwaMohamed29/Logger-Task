//
//  AppDelegate.swift
//  Logger Task
//
//  Created by Radwa on 27/12/2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window:UIWindow?
     
    static var shared: AppDelegate {
          return UIApplication.shared.delegate as! AppDelegate
      }


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Logger.shared.setRequired(.info)
        let floatingButton = CustomFloatingButton()
        goToSplash()
        window?.addSubview(floatingButton)
        

        return true
    }

    func goToSplash() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        let navigationController = UINavigationController(rootViewController: storyboard)
        navigationController.navigationBar.isHidden = true
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
}

