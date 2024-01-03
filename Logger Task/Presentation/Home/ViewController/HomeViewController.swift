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
    private let floatingButton: UIButton = {
       let button = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        button.backgroundColor = .systemIndigo
        let image = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 32, weight: .medium))
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 30
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(floatingButton)
       viewModel = HomeViewModel()
        
        floatingButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        
        /// hide floating button when Logger disabled
        if loggerStatus{
            floatingButton.isHidden = false
            Timer.scheduledTimer(timeInterval: 3600.0, target: self, selector: #selector(sayHello), userInfo: nil, repeats: true)
        }else{
            floatingButton.isHidden = true
            DataProvider.shared.delete()
        }
    }
    
    override func viewDidLayoutSubviews() {
        floatingButton.frame = CGRect(x: view.frame.size.width - 70,
                                      y: view.frame.size.height - 100,
                                      width: 60,
                                      height: 60)
    }
    
    //MARK: - Logs will be synced with the server every 1 hour.
    @objc func sayHello()
    {
        DataProvider.shared.create(note: Logger.info("saved every 1 hour"))
    }
 
    //MARK: - Users can force sync the logs through a floating button
    @objc private func didTapButton(){
        DataProvider.shared.create(note: Logger.info("Floating Button"))
    }
    
    private func bindViewModel() {
            viewModel?.dataPublisher
                .sink { data in
                    
                }
                .store(in: &subscriptions)
        }
}
