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
        
        let floatingButton = CustomFloatingButton(type: .custom)
        floatingButton.frame = CGRect(x: UIScreen.main.bounds.width - 70,
                                      y: UIScreen.main.bounds.height - 100,
                                      width: 60,
                                      height: 60)
        goToSplash()
        window?.addSubview(floatingButton)
        

        return true
    }

    func goToSplash() {
        let navigationController = UINavigationController(rootViewController: LaunchViewController.buildVC())
        navigationController.navigationBar.isHidden = true
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
//      func getCustomButton() -> CustomFloatingButton?{
//          return floatingButton
//      }
}

