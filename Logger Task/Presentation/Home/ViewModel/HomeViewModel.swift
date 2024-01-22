//
//  HomeViewModel.swift
//  Logger Task
//
//  Created by Radwa on 01/01/2024.
//

import Foundation
import Combine

protocol HomeViewModelProtocol{
    var loggerStatus: LoggerStatus? {get set}
    func uploadFile()
    func getLoggerStatus()
//    var dataPublisher: AnyPublisher<LoggerStatus, Never>{get}
    var myDataPublisher: Published<LoggerStatus?>.Publisher { get }


}


// MARK: - HomeViewModel -
class HomeViewModel:HomeViewModelProtocol, ObservableObject{

    // MARK: - Properties -
    var repository: APIClientRepositoryProtocol
    
    // MARK: - Initializers -
    init(repository: APIClientRepositoryProtocol = APIClientRepository()) {
        self.repository = repository
    }
        @Published var loggerStatus:LoggerStatus?
        private var cancellables = Set<AnyCancellable>()
        var myDataPublisher: Published<LoggerStatus?>.Publisher {
            $loggerStatus
        }
    func uploadFile() {
        guard let filePath = Logger.shared.filePath() else{return}
        repository.uploadFile(fileURL: filePath, endPoint: .saveLoggerData , responseType: BaseModel.self)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    logError("Error is \(error.localizedDescription)")
                case .finished: break
                    
                }
            }
            receiveValue: {  response in
            }
            .store(in: &cancellables)
        }
    
        func getLoggerStatus() {
            repository.getLoggerStatus(endpoint: .getLoggerStatus, type: LoggerStatus.self)
                .sink { completion in
                    switch completion {
                    case .failure(let error):
                        logError("Error is \(error.localizedDescription)")
                    case .finished: break
    
                    }
                }
                receiveValue: { [weak self] statusData in
                    self?.loggerStatus = statusData
                    
                }
                .store(in: &cancellables)
            
            }
}
