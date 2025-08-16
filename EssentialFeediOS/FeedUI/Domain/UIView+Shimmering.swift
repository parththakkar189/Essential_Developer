//
//  UIView+Shimmering.swift
//  EssentialFeed
//
//  Created by Parth Thakkar on 2025-08-10.
//
import UIKit

extension UIView {
    
    public var isShimmering: Bool {
        return layer.mask?.animation(forKey: shimmerAnimationKey) != nil
    }

    private var shimmerAnimationKey: String {
        return "shimmer"
    }
    
    func startAnimating() {
        let white = UIColor.white.cgColor
        let alpha = UIColor.white.withAlphaComponent(0.7).cgColor
        let width = bounds.width
        let height = bounds.height
        
        let gradient = CAGradientLayer()
        gradient.colors = [alpha, white, alpha]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.4)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.6)
        gradient.locations = [0.4,0.5,0.6]
        gradient.frame = CGRect(x: -width, y: 0, width: width*3, height: height)
        layer.mask = gradient
        
        let animation = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.locations))
        animation.fromValue = [0.0,0.1,0.2]
        animation.toValue = [0.8,0.2,1.0]
        animation.duration = 1
        animation.repeatCount = .infinity
        gradient.add(animation, forKey: shimmerAnimationKey)
    }
    
    func stopAnimating() {
        layer.mask = nil
    }
}
