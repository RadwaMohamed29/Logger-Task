//
//  HomeViewController.swift
//  Logger Task
//
//  Created by Radwa on 28/12/2023.
//

import UIKit
import Combine

class HomeViewController: UIViewController {
    public class func buildVC() -> HomeViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
    }
    
    private var subscriptions = Set<AnyCancellable>()
    private var viewModel: HomeViewModelProtocol?{
        didSet{
            bindViewModel()
        }
    }
    var loggerStatus: Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        viewModel = HomeViewModel()
        
         let customButton = AppDelegate.shared.getCustomButton()
         customButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)

            /// hide floating button when Logger disabled
            if loggerStatus{
                customButton.isHidden = false
                Timer.scheduledTimer(timeInterval: 3600.0, target: self, selector: #selector(sayHello), userInfo: nil, repeats: true)
            }else{
                customButton.isHidden = true
                Logger.shared.deleteLog()
            }
            
        
    }
    
    //MARK: - Logs will be synced with the server every 1 hour.
    @objc func sayHello()
    {
        logInfo("saved every 1 hour")
        viewModel?.uploadFile()
    }
    
    //MARK: - Users can force sync the logs through a floating button
    @objc private func didTapButton(){
        logInfo("Floating Button")
        viewModel?.uploadFile()
    }
    
    private func bindViewModel() {
        viewModel?.dataPublisher
            .sink { data in
                //    Swift.print(data)
            }
            .store(in: &subscriptions)
    }
}
