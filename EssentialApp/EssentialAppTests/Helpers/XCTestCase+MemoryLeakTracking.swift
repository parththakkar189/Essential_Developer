//
//  XCTestCase+MemoryLeakTracking.swift
//  EssentialApp
//
//  Created by Parth Thakkar on 2025-09-18.
//

import XCTest

extension XCTestCase {
    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #file, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have deallocated Potential Memory leak", file: file, line: line)
        }
    }
}
