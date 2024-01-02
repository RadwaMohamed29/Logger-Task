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
 //   func saveLoggerData<D: Decodable, E: Encodable>(from endpoint: ApiEndpoint, with body: E) async throws -> D
}
