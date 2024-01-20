//
//  HomeViewModel.swift
//  Logger Task
//
//  Created by Radwa on 01/01/2024.
//

import Foundation
import Combine

protocol HomeViewModelProtocol{
    func uploadFile()
    var dataPublisher: AnyPublisher<BaseModel, Never>{get}
}


// MARK: - HomeViewModel -
class HomeViewModel:HomeViewModelProtocol, ObservableObject{

    // MARK: - Properties -
    var repository: APIClientRepositoryProtocol
    
    // MARK: - Initializers -
    init(repository: APIClientRepositoryProtocol = APIClientRepository()) {
        self.repository = repository
    }
    @Published var context:BaseModel?
    private var cancellables = Set<AnyCancellable>()
    private let dataSubject = PassthroughSubject<BaseModel, Never>()
    var dataPublisher: AnyPublisher<BaseModel, Never>{
        return dataSubject.eraseToAnyPublisher()

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
            receiveValue: { [weak self] response in
                self?.dataSubject.send(response)
            }
            .store(in: &cancellables)
        }
}
