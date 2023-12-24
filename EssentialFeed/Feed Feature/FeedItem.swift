//
//  FeedItem.swift
//  EssentialFeed
//
//  Created by Parth Thakkar on 2023-12-02.
//

import Foundation
struct Root: Decodable {
    let items: [FeedItem]
    var feed: [FeedItem] {
        return items.compactMap { $0.item }
    }
}
public struct FeedItem: Equatable {
    public let id: UUID
    public let description: String?
    public let location: String?
    public let imageURL: URL
    
    public init(id: UUID, description: String?, location: String? = nil , imageURL: URL) {
        self.id = id
        self.description = description
        self.location = location
        self.imageURL = imageURL
    }
}

extension FeedItem: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id
        case description
        case location
        case imageURL = "image"
    }
    
    var item: FeedItem {
        return FeedItem(id: id, description: description, location: location, imageURL: imageURL)
    }
    
    public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(id.uuidString, forKey: .id)
            try container.encode(description, forKey: .description)
            
            // Check if locaiton is nil before encoding
            if let location = location {
                try container.encode(location, forKey: .location)
            }

            try container.encode(imageURL.absoluteString, forKey: .imageURL)
        }
}
