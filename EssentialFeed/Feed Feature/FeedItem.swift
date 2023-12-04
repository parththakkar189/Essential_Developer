//
//  FeedItem.swift
//  EssentialFeed
//
//  Created by Parth Thakkar on 2023-12-02.
//

import Foundation

public struct FeedItem: Equatable {
    let id: UUID
    let description: String?
    let locaiton: String
    let imageURL: URL
}
