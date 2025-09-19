//
//  SharedTestHelpers.swift
//  EssentialApp
//
//  Created by Parth Thakkar on 2025-09-18.
//

import Foundation


func anyURL() -> URL {
    URL(string: "http://any-url.com")!
}

func anyNSError() -> NSError {
    NSError(domain: "any", code: 0)
}

func anyData() -> Data {
    Data("anyData".utf8)
}

