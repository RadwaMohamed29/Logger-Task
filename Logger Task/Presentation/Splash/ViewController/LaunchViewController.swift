//
//  LaunchViewController.swift
//  Logger Task
//
//  Created by Radwa on 01/01/2024.
//

import UIKit
import Combine
class LaunchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            guard let self = self else {return}
            let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
           // viewController.loggerStatus = status
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }

}
