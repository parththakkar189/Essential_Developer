//
//  FeedImageViewModel+PrototypeData.swift
//  Prototype
//
//  Created by Parth Thakkar on 2025-06-24.
//

extension FeedImageViewModel {
     static var prototypeData: [FeedImageViewModel] {
        return [
            FeedImageViewModel(
                description: nil,
                location: nil,
                imageName: "imageName-1"
            ),
            FeedImageViewModel(
                description: nil,
                location: "Toronto, Canada",
                imageName: "imageName-2"
            ),
            FeedImageViewModel(
                description: "A beautiful view of Banff National Park, where the majestic mountains rise above crystal-clear lakes, and the air is filled with the scent of pine trees. Wildlife roams freely, and every season brings a new palette of colors to the landscape, making it a paradise for nature lovers and adventurers alike.",
                location: nil,
                imageName: "imageName-3"
            ),
            FeedImageViewModel(
                description: nil,
                location: "Vancouver, Canada",
                imageName: "imageName-4"
            ),
            FeedImageViewModel(
                description: "Sunset over the Rockies paints the sky in brilliant shades of orange and pink, casting long shadows across the rugged peaks. The cool mountain air is refreshing, and the silence is broken only by the distant call of an eagle soaring above.",
                location: nil,
                imageName: "imageName-5"
            ),
            FeedImageViewModel(
                description: nil,
                location: "Montreal, Canada",
                imageName: "imageName-6"
            ),
            FeedImageViewModel(
                description: "Winter in Whistler transforms the village into a snowy wonderland, with skiers and snowboarders carving down powdery slopes. Twinkling lights and cozy lodges create a festive atmosphere, perfect for après-ski gatherings and warm drinks by the fire.",
                location: nil,
                imageName: "imageName-7"
            ),
            FeedImageViewModel(
                description: nil,
                location: "Calgary, Canada",
                imageName: "imageName-8"
            ),
            FeedImageViewModel(
                description: "Northern lights in Yukon dance across the night sky in vibrant waves of green and purple, illuminating the snowy landscape below. The breathtaking display is a magical experience that draws visitors from around the world to witness nature's own light show.",
                location: nil,
                imageName: "imageName-9"
            ),
            FeedImageViewModel(
                description: nil,
                location: "Halifax, Canada",
                imageName: "imageName-10"
            )
        ]
    }
}
