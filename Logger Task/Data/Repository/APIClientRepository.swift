//
//  APIClientRepository.swift
//  Logger Task
//
//  Created by Radwa on 31/12/2023.
//

import Foundation
import Combine

// MARK: - APIClientRepository -
final class APIClientRepository: APIClientRepositoryProtocol {
    
    // MARK: - Properties -
    private var apiClient: APIClientProtocol
    
    // MARK: - Initializers -
    init(apiClient: APIClientProtocol = APIClient()) {
        self.apiClient = apiClient
    }
    
    // MARK: - Functions -
    func getLoggerStatus<T>(endpoint: ApiEndpoint, type: T.Type) -> Future<T, Error> where T : Decodable {
        apiClient.getLoggerStatus(endpoint: endpoint, type: type)
    }
    func uploadFile<T: Decodable>(fileURL: URL, endPoint: ApiEndpoint, responseType: T.Type) -> AnyPublisher<T, Error> {
        apiClient.uploadFile(fileURL: fileURL, endPoint: endPoint, responseType: responseType)
    }
}
