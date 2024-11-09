//
//  XCTTestCase+MemoryLeakHelper.swift
//  EssentialFeedTests
//
//  Created by Parth Thakkar on 2024-11-09.
//

import XCTest

extension XCTestCase {
    func trackForMemoryLeaks(_ instance: AnyObject,
                                     file: StaticString = #filePath,
                                     line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential Memory Leak.", file: file, line: line)
        }
    }
}
