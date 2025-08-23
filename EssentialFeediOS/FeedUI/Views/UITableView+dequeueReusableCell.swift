//
//  UITableView+dequeuing.swift
//  EssentialFeed
//
//  Created by Parth Thakkar on 2025-08-23.
//

import UIKit

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>() -> T {
        let identifier = String(describing: T.self)
        return dequeueReusableCell(withIdentifier: identifier) as! T
    }
}
