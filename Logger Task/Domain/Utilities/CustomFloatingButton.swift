//
//  CustomFloatingButton.swift
//  Logger Task
//
//  Created by Radwa Mohamed on 18/01/2024.
//

import Foundation
import UIKit
import Combine

class CustomFloatingButton: UIButton{
    
    private var subscriptions = Set<AnyCancellable>()
    var status: PassthroughSubject<Bool, Never> = .init()
    private var viewModel: HomeViewModelProtocol?
    
    init() {
        super.init(frame: .zero)
        self.viewModel = HomeViewModel()
        bindViewModel()
        viewModel?.getLoggerStatus()
        
        status.sink { [self] value in
            if value{
                setUpFloatingButton()
                Timer.scheduledTimer(timeInterval: 3600.0, target: self, selector: #selector(sayHello), userInfo: nil, repeats: true)
            }
        }
        .store(in: &subscriptions)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setUpFloatingButton(){
        backgroundColor = .systemIndigo
        let image = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 32, weight: .medium))
        setImage(image, for: .normal)
        tintColor = .white
        setTitleColor(.white, for: .normal)
        layer.cornerRadius = 30
        frame = CGRect(x: UIScreen.main.bounds.width - 70,
                       y: UIScreen.main.bounds.height - 100,
                       width: 60,
                       height: 60)
        addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
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
    
    private func bindViewModel(){
        viewModel?.myDataPublisher
            .sink { [self] data in
                guard let data = data?.status else{return}
                status.send(data)
            }
            .store(in: &subscriptions)
    }
}
