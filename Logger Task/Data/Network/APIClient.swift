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
    func uploadFile<T: Decodable>(fileURL: URL, apiURL: String, responseType: T.Type) -> AnyPublisher<T, Error>
}
    
    // MARK: - APIClient -
    final class APIClient: APIClientProtocol {
        
        
        private var cancellables = Set<AnyCancellable>()
        
        //MARK: - Methods
        
        func getLoggerStatus<T: Decodable>(endpoint: ApiEndpoint, type: T.Type) -> Future<T, Error> {
            return Future<T, Error> { [weak self] promise in
                guard let self = self, let url = URL(string: ApiHelper.baseURL.appending(endpoint.path))
                else {
                    return promise(.failure(ApiError.invalidPath))
                }
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
        
        
        //    func uploadFile<T: Decodable>(endpoint: ApiEndpoint, type: T.Type) -> Future<T, Error> {
        //        return Future<T, Error> { promise in
        //            guard let self = self, let url = URL(string: ApiHelper.baseURL.appending(endpoint.path))
        //            else {
        //                return promise(.failure(ApiError.invalidPath))
        //            }
        //
        //
        //            let task = URLSession.shared.uploadTask(with: URLRequest, from: url)
        //                .tryMap { data, response in
        //                    guard let httpResponse = response as? HTTPURLResponse else {
        //                        throw ApiError.unknown
        //                    }
        //
        //                    if httpResponse.statusCode == 200 {
        //                        return ()
        //                    } else {
        //                        throw ApiError.responseError
        //                    }
        //                }
        //                .receive(on: DispatchQueue.main)
        //                .sink(receiveCompletion: { completion in
        //                    switch completion {
        //                    case .finished:
        //                        break
        //                    case .failure(let error):
        //                        promise(.failure(error))
        //                    }
        //                }, receiveValue: { _ in
        //                    promise(.success(()))
        //                })
        //
        //            task.resume()
        //        }
        //        .eraseToAnyPublisher()
        //    }
        //***********************
//            func uploadMultipartData(url: URL, formData: LoggerContext) -> AnyPublisher<Data, Error> {
//                return Future<Data, Error> { promise in
//                    let boundary = "Boundary-\(UUID().uuidString)"
//
//                    var request = URLRequest(url: url)
//                    request.httpMethod = "POST"
//                    request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//
//                    let bodyPublisher = formData.publisher.flatMap { part -> AnyPublisher<Data, Error> in
//                        var body = Data()
//
//                        body.append("--\(boundary)\r\n")
//                        body.append("Content-Disposition: form-data; name=\"\(part.name)\"")
//
//                        if let filename = part.filename {
//                            body.append("; filename=\"\(filename)\"")
//                        }
//
//                        if let mimeType = part.mimeType {
//                            body.append("\r\nContent-Type: \(mimeType)")
//                        }
//
//                        body.append("\r\n\r\n")
//                        body.append(part.data)
//                        body.append("\r\n")
//
//                        return Just(body).setFailureType(to: Error.self).eraseToAnyPublisher()
//                    }
//
//                    let finalBody = bodyPublisher.append(Just("--\(boundary)--\r\n").setFailureType(to: Error.self)).eraseToAnyPublisher()
//
//                    request.httpBodyPublisher = finalBody
//
//                    let task = URLSession.shared.dataTaskPublisher(for: request)
//                        .map(\.data)
//                        .mapError { $0 as Error }
//                        .receive(on: DispatchQueue.main)
//                        .sink(receiveCompletion: { completion in
//                            switch completion {
//                            case .finished:
//                                break
//                            case .failure(let error):
//                                promise(.failure(error))
//                            }
//                        }, receiveValue: { data in
//                            promise(.success(data))
//                        })
//
//                    cancellables.insert(task)
//                }
//                .eraseToAnyPublisher()
//            }
//
        
        func uploadFile<T: Decodable>(fileURL: URL, apiURL: String, responseType: T.Type) -> AnyPublisher<T, Error> {
            guard var request = createMultipartRequest(apiURL: apiURL, fileURL: fileURL) else {
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

        private func createMultipartRequest(apiURL: String, fileURL: URL) -> URLRequest? {
            var request = URLRequest(url: URL(string: apiURL)!)
            request.httpMethod = "POST"

            let boundary = UUID().uuidString
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

            guard let fileData = try? Data(contentsOf: fileURL) else {
                return nil
            }

            var body = Data()
            
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(fileURL.lastPathComponent)\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: application/octet-stream\r\n\r\n".data(using: .utf8)!)
            body.append(fileData)
            body.append("\r\n".data(using: .utf8)!)
            body.append("--\(boundary)--\r\n".data(using: .utf8)!)

            request.httpBody = body

            return request
        }
}




 

 
