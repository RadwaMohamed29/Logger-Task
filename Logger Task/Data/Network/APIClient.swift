//
//  APIClient.swift
//  Logger Task
//
//  Created by Radwa on 31/12/2023.
//

import Foundation
import Combine

protocol APIClientProtocol {
    func getLoggerStatus<T: Decodable>(endpoint: ApiEndpoint, type: T.Type) -> Future<T, Error>
   // func saveLoggerData<D: Decodable, E: Encodable>(from endpoint: ApiEndpoint, with body: E) async throws -> D
}


// MARK: - APIClient -
final class APIClient: APIClientProtocol {
    
    
    private var cancellables = Set<AnyCancellable>()
    
    
    func getLoggerStatus<T: Decodable>(endpoint: ApiEndpoint, type: T.Type) -> Future<T, Error> {
        return Future<T, Error> { [weak self] promise in
            guard let self = self, let url = URL(string: ApiHelper.baseURL.appending(endpoint.path))
            else {
                return promise(.failure(ApiError.invalidPath))
            }
            Logger.info("URL is \(url.absoluteString)")
            URLSession.shared.dataTaskPublisher(for: url)
                .tryMap() { element -> Data in
                        guard let httpResponse = element.response as? HTTPURLResponse,
                            httpResponse.statusCode == 200 else {
                            throw ApiError.responseError
                            }
                        return element.data
                        }
                .decode(type: T.self, decoder: JSONDecoder())
                .receive(on: RunLoop.main)
                .sink(receiveCompletion: { (completion) in
                    if case let .failure(error) = completion {
                        switch error {
                        case let decodingError as DecodingError:
                            promise(.failure(decodingError))
                        case let apiError as ApiError:
                            promise(.failure(apiError))
                        default:
                            promise(.failure(ApiError.unknown))
                        }
                    }
                }, receiveValue: {result in
                    promise(.success(result))
                    
                })
                .store(in: &self.cancellables)
        }
    }
      
   
//    func saveLoggerData<D: Decodable, E: Encodable>(from endpoint: ApiEndpoint, with body: E) async throws -> D {
//        let request = try createRequest(from: endpoint)
//        let data = try encoder.encode(body)
//        let response: NetworkResponse = try await session.upload(for: request, from: data)
//        return try decoder.decode(D.self, from: response.data)
//    }
}

//private extension APIClient {
//
//    func createRequest(from endpoint: ApiEndpoint) throws -> URLRequest {
//        guard
//            let urlPath = URL(string: ApiHelper.baseURL.appending(endpoint.path))
//        //    var urlComponents = URLComponents(string: urlPath.path)
//        else {
//            throw ApiError.invalidPath
//        }
//
////        if let parameters = endpoint.parameters {
////            urlComponents.queryItems = parameters
////        }
//
//        var request = URLRequest(url: urlPath)
//        request.httpMethod = endpoint.method.rawValue
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        return request
//    }
//}
