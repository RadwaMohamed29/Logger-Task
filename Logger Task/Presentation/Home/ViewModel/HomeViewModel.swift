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
final class HomeViewModel:HomeViewModelProtocol, ObservableObject{

    // MARK: - Properties -
    var repository: APIClientRepositoryProtocol
    
    // MARK: - Initializers -
    init(repository: APIClientRepositoryProtocol = APIClientRepository()) {
        self.repository = repository
    }
    @Published var context:BaseModel?
    private var cancellables = Set<AnyCancellable>()
    // custom PassthroughSubject
    private let dataSubject = PassthroughSubject<BaseModel, Never>()
    // Expose the subject as AnyPublisher
    var dataPublisher: AnyPublisher<BaseModel, Never>{
        return dataSubject.eraseToAnyPublisher()

    }
    func uploadFile() {
        repository.uploadFile(fileURL: DataProvider.shared.filePath(), endPoint: .saveLoggerData , responseType: BaseModel.self)
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
                print("Done \(response)")
            }
            .store(in: &cancellables)
        }
}
