//
//  HTTPURLResponse+StatusCode.swift
//  EssentialFeed
//
//  Created by Parth Thakkar on 2025-09-06.
//

import Foundation

extension HTTPURLResponse {
    private static var OK_200: Int { 200 }
    
    var isOK: Bool {
        statusCode == Self.OK_200
    }
}
