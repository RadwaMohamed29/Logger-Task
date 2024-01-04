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
    func uploadFile<T>(fileURL: URL, apiURL: String, responseType: T.Type) -> AnyPublisher<T, Error> where T : Decodable {
        apiClient.uploadFile(fileURL: fileURL, apiURL: apiURL, responseType: responseType)
    }
}
