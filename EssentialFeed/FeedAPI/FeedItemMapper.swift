//
//  FeedItemMapper.swift
//  EssentialFeed
//
//  Created by Parth Thakkar on 2023-12-24.
//

import Foundation

enum FeedItemMapper {
    private static var OK_200: Int { return 200 }
    
     static func map(_ data: Data, from response: HTTPURLResponse) -> RemoteFeedLoader.Result {
        guard response.statusCode == OK_200, let root = try? JSONDecoder().decode(Root.self, from: data)
        else { return .failure(RemoteFeedLoader.Error.invalidData) }
        return .success(root.feed)
    }
}
