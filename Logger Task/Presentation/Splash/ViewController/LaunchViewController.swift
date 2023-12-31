//
//  LaunchViewController.swift
//  Logger Task
//
//  Created by Radwa on 01/01/2024.
//

import UIKit
import Combine
class LaunchViewController: UIViewController {
    private var status: Bool = false
    private var subscriptions = Set<AnyCancellable>()
    private var viewModel: LaunchViewModelProtocol?{
        didSet{
            bindViewModel()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = LaunchViewModel()
        viewModel?.getLoggerStatus()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            guard let self = self else {return}
            let viewController = HomeViewController.buildVC()
            viewController.loggerStatus = status
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    

    private func bindViewModel(){
            viewModel?.dataPublisher
                .sink { data in
                    self.status = data.status ?? true
                }
                .store(in: &subscriptions)
        }

}
