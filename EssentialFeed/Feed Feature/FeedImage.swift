//
//  FeedItem.swift
//  EssentialFeed
//
//  Created by Parth Thakkar on 2023-12-02.
//

import Foundation

public struct FeedImage: Equatable {
    public let id: UUID
    public let description: String?
    public let location: String?
    public let url: URL
    
    public init(id: UUID, description: String?, location: String? = nil , url: URL) {
        self.id = id
        self.description = description
        self.location = location
        self.url = url
    }
}

extension FeedImage: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id
        case description
        case location
        case url = "image"
    }
    
    var item: FeedImage {
        return FeedImage(id: id, description: description, location: location, url: url)
    }
    
    public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(id.uuidString, forKey: .id)
            try container.encode(description, forKey: .description)
            
            // Check if locaiton is nil before encoding
            if let location = location {
                try container.encode(location, forKey: .location)
            }

        try container.encode(url.absoluteString, forKey: .url)
        }
}
