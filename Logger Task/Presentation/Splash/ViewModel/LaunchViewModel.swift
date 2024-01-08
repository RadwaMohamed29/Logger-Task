//
//  LaunchViewModel.swift
//  Logger Task
//
//  Created by Radwa on 01/01/2024.
//

import Foundation
import Combine

protocol LaunchViewModelProtocol{
    var loggerStatus: LoggerStatus? {get}
    var dataPublisher: AnyPublisher<LoggerStatus, Never>{get}
    func getLoggerStatus()
}


// MARK: - LaunchViewModel -
final class LaunchViewModel:LaunchViewModelProtocol, ObservableObject{

    // MARK: - Properties -
    var repository: APIClientRepositoryProtocol
    
    // MARK: - Initializers -
    init(repository: APIClientRepositoryProtocol = APIClientRepository()) {
        self.repository = repository
    }
    @Published var loggerStatus:LoggerStatus?
    private var cancellables = Set<AnyCancellable>()
    private let dataSubject = PassthroughSubject<LoggerStatus, Never>()
    var dataPublisher: AnyPublisher<LoggerStatus, Never>{
        return dataSubject.eraseToAnyPublisher()

    }
    func getLoggerStatus() {
        repository.getLoggerStatus(endpoint: .getLoggerStatus, type: LoggerStatus.self)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    Logger.error("Error is \(error.localizedDescription)")
                case .finished: break

                }
            }
            receiveValue: { [weak self] statusData in
                self?.loggerStatus = statusData
                self?.dataSubject.send(statusData)
            }
            .store(in: &cancellables)
        }
}
