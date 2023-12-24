//
//  HTTPClient.swift
//  EssentialFeed
//
//  Created by Parth Thakkar on 2023-12-24.
//

import Foundation

public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}


public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}
