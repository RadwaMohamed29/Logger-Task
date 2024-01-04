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
    var dataPublisher: AnyPublisher<LoggerContext, Never>{get}
}


// MARK: - HomeViewModel -
final class HomeViewModel:HomeViewModelProtocol, ObservableObject{

    // MARK: - Properties -
    var repository: APIClientRepositoryProtocol
    
    // MARK: - Initializers -
    init(repository: APIClientRepositoryProtocol = APIClientRepository()) {
        self.repository = repository
    }
    @Published var context:LoggerContext?
    private var cancellables = Set<AnyCancellable>()
    // custom PassthroughSubject
    private let dataSubject = PassthroughSubject<LoggerContext, Never>()
    // Expose the subject as AnyPublisher
    var dataPublisher: AnyPublisher<LoggerContext, Never>{
        return dataSubject.eraseToAnyPublisher()

    }
    func uploadFile() {
        repository.uploadFile(fileURL: DataProvider.shared.filePath(), apiURL: " ", responseType: LoggerContext.self)
            .sink { completion in
                switch completion {
                case .failure(let err):
                    print("Error is \(err.localizedDescription)")
                case .finished:
                    print("Finished")
                }
            }
            receiveValue: { [weak self] response in
                self?.dataSubject.send(response)
            }
            .store(in: &cancellables)
        }
}
