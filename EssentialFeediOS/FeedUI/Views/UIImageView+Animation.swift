//
//  UIImageView+Animation.swift
//  EssentialFeed
//
//  Created by Parth Thakkar on 2025-08-23.
//

import UIKit

extension UIImageView {
    func setAnimated(_ newImage: UIImage?) {
        image = newImage
        
        guard newImage != nil else { return }
        alpha = 0
        UIView.animate(withDuration: 0.25) {
            self.alpha = 1
        }
    }
}
