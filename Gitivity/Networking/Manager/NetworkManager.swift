//
//  NetworkManager.swift
//  SandboxApp
//
//  Created by Darul Firmansyah on 28/06/24.
//

import Combine
import Foundation

enum APIError: Error {
    case invalidURL
    case requestFailed(String)
    case decodingFailed
}

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum Endpoint {
    case users
    case user(String)
    case repositories(String)
    
    var path: String {
        switch self {
        case .users:
            return "/users"
        case let .user(username):
            return "/users/" + username
        case let .repositories(username):
            return "/users/" + username + "/repos"
        }
    }
    
    var httpMethod: HttpMethod {
        switch self {
        default:
            return .get
        }
    }
}

protocol NetworkManagerProtocol {
    func request<T: Decodable>(_ endpoint: Endpoint, headers: [String: String]?, parameters: [String: String]?, headerInterceptor: (([AnyHashable: Any]) -> Void)?) -> AnyPublisher<T, APIError>
}

class NetworkManager: NetworkManagerProtocol {
    private let baseURL: String = "https://api.github.com"
    
    private func defaultHeaders() -> [String: String] {
        return [
            "Accept": "application/vnd.github+json",
            "Authorization": "Bearer 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",
            "X-GitHub-Api-Version": "2022-11-28"
        ]
    }
    
    func request<T: Decodable>(_ endpoint: Endpoint, headers: [String: String]? = nil, parameters: [String: String]? = nil, headerInterceptor: (([AnyHashable: Any]) -> Void)?) -> AnyPublisher<T, APIError> {
        var queryItems: [URLQueryItem] = []
        if let parameters {
            for param in parameters {
                queryItems.append(URLQueryItem(name: param.key, value: param.value))
            }
        }
        
        var url: URL? = URL(string: baseURL + endpoint.path)
        
        if #available(iOS 16.0, *) {
            url = url?.appending(queryItems: queryItems)
        } else {
            // Fallback on earlier versions
        }
        
        
        guard let url
        else {
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endpoint.httpMethod.rawValue
        let allHeaders = defaultHeaders().merging(headers ?? [:], uniquingKeysWith: { (_, new) in new })
        for (key, value) in allHeaders {
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap { (data, response) -> (Data) in
                if let httpResponse = response as? HTTPURLResponse,
                   (200..<300).contains(httpResponse.statusCode) {
                    headerInterceptor?(httpResponse.allHeaderFields)
                    return data
                } else {
                    let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
                    throw APIError.requestFailed("Request failed with status code: \(statusCode)")
                }
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .tryMap { (responseWrapper) -> T in
                return responseWrapper
            }
            .mapError { error -> APIError in
                if error is DecodingError {
                    return APIError.decodingFailed
                } else if let apiError = error as? APIError {
                    return apiError
                } else {
                    return APIError.requestFailed("An unknown error occurred.")
                }
            }
            .eraseToAnyPublisher()
    }
}


extension String {
    
    func slice(from: String, to: String) -> String? {
        guard let rangeFrom = range(of: from)?.upperBound else { return nil }
        guard let rangeTo = self[rangeFrom...].range(of: to)?.lowerBound else { return nil }
        return String(self[rangeFrom..<rangeTo])
    }
    
}
