//
//  APIClientRepositoryProtocol.swift
//  Logger Task
//
//  Created by Radwa on 31/12/2023.
//

import Foundation
import Combine

protocol APIClientRepositoryProtocol {
    func getLoggerStatus<T: Decodable>(endpoint: ApiEndpoint, type: T.Type) -> Future<T, Error>
    func uploadFile<T: Decodable>(fileURL: URL, apiURL: String, responseType: T.Type) -> AnyPublisher<T, Error>
}
