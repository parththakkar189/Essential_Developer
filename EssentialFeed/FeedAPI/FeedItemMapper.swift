//
//  FeedItemMapper.swift
//  EssentialFeed
//
//  Created by Parth Thakkar on 2023-12-24.
//

import Foundation

internal final class FeedItemMapper {
    private static var OK_200: Int { return 200 }
    internal static func map(_ data: Data, _ response: HTTPURLResponse)  throws -> [FeedItem] {
        guard response.statusCode == OK_200 else {
            throw RemoteFeedLoader.Error.invalidData
        }
        let root = try JSONDecoder().decode(Root.self, from: data)
        return root.items.map { $0.item }
    }
}
