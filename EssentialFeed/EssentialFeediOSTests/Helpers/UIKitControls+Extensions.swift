//
//  UIKitControls+Extensions.swift
//  EssentialFeed
//
//  Created by Parth Thakkar on 2025-08-16.
//

import UIKit

// MARK: UIRefreshControl

extension UIRefreshControl {
    func simulatePullToRefresh() {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: .valueChanged)?.forEach {
                    (target as NSObject).perform(Selector($0))
            }
        }
    }
}

// MARK: UIImage

extension UIImage {
    static func make(withColor color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        
        return UIGraphicsImageRenderer(size: rect.size, format: format).image { rendererContext in
            color.setFill()
            rendererContext.fill(rect)
        }
    }
}

// MARK: UIButton

extension UIButton {
    func simulateTap() {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: .touchUpInside)?.forEach {
                    (target as NSObject).perform(Selector($0))
            }
        }
    }
}

