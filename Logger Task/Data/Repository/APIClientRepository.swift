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
//    func getLoggerStatus<D>(from endpoint: ApiEndpoint) async throws -> D where D : Decodable {
//        try await apiClient.getLoggerStatus(from: endpoint)
//    }
//
//    func saveLoggerData<D, E>(from endpoint: ApiEndpoint, with body: E) async throws -> D where D : Decodable, E : Encodable {
//        try await apiClient.saveLoggerData(from: endpoint, with: body)
//    }
    
}
