//
//  APIClient.swift
//  Logger Task
//
//  Created by Radwa on 31/12/2023.
//

import Foundation
import Combine

protocol APIClientProtocol {
    func getLoggerStatus<T: Decodable>(endpoint: ApiEndpoint, type: T.Type) -> AnyPublisher<T, Error>
    func uploadFile<T: Decodable>(fileURL: URL, endPoint: ApiEndpoint, responseType: T.Type) -> AnyPublisher<T, Error>}

// MARK: - APIClient -
class APIClient: APIClientProtocol {
    
    private var cancellables = Set<AnyCancellable>()
    
    //MARK: - Methods
    func getLoggerStatus<T: Decodable>(endpoint: ApiEndpoint, type: T.Type) -> AnyPublisher<T, Error> {
        guard let url = URL(string: ApiHelper.baseURL.appending(endpoint.path)) else {
            return Fail(error: ApiError.invalidPath).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw ApiError.responseError
                }
                return element.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main) // Switch to the main thread for UI updates
            .mapError { error in
                if let decodingError = error as? DecodingError {
                    return decodingError
                } else if let apiError = error as? ApiError {
                    return apiError
                } else {
                    return ApiError.unknown
                }
            }
            .eraseToAnyPublisher()
    }
    
    func uploadFile<T: Decodable>(fileURL: URL, endPoint: ApiEndpoint, responseType: T.Type) -> AnyPublisher<T, Error> {
        guard let request = createMultipartRequest(endPoint: endPoint, files: [fileURL]) else {
            return Fail(error: ApiError.invalidPath).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw ApiError.responseError
                }
                
                if (200..<300).contains(httpResponse.statusCode) {
                    return data
                } else {
                    throw ApiError.responseError
                }
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { _ in
                ApiError.unknown
            }
            .eraseToAnyPublisher()
    }
    
    private func createMultipartRequest(endPoint: ApiEndpoint, files: [URL]) -> URLRequest? {
        guard let url = URL(string: ApiHelper.baseURL.appending(endPoint.path)) else {
            logError("\(ApiError.invalidPath)")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endPoint.method.rawValue
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        // Add parameters to the request body
//        for (key, value) in parameters {
//            body.append("--\(boundary)\r\n".data(using: .utf8)!)
//            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
//            body.append("\(value)\r\n".data(using: .utf8)!)
//        }
        
        // Add files to the request body
        for fileURL in files {
            guard let fileName = fileURL.lastPathComponent.data(using: .utf8) else {
                return nil
            }

            guard let fileData = try? Data(contentsOf: fileURL) else {
                return nil
            }
            
            body.append(contentsOf: "--\(boundary)\r\n".utf8)
            body.append(contentsOf: "Content-Disposition: form-data; name=\"file[]\"; filename=\"\(fileName)\"\r\n".utf8)
            body.append(contentsOf: "Content-Type: application/octet-stream\r\n\r\n".utf8)
            body.append(fileData)
            body.append(contentsOf: "\r\n".utf8)
        }
        
        body.append(contentsOf: "--\(boundary)--\r\n".utf8)
        
        request.httpBody = body
        
        return request
    }
}







