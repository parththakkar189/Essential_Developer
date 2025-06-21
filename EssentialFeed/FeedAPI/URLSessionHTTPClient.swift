//
//  URLSessionHTTPClient.swift
//  EssentialFeed
//
//  Created by Parth Thakkar on 2024-11-09.
//

import Foundation

public class URLSessionHTTPClient: HTTPClient {
    private let session: URLSession
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    private struct UnexpectedValuesRepresentationError: Error {}
    
    public func get(from url: URL, completion: @escaping (Result) -> Void) {
        session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data, let response = response as? HTTPURLResponse {
                completion(.success((data, response)))
            } else {
                completion(.failure(UnexpectedValuesRepresentationError()))
            }
        }.resume()
    }
}
