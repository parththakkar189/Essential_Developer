//
//  FeedImageCell.swift
//  EssentialFeediOS
//
//  Created by Parth Thakkar on 2025-08-10.
//

import UIKit

public class FeedImageCell: UITableViewCell {

    public let locationContainer = UIView()
    public let locationLabel = UILabel()
    public let descriptionLabel = UILabel()
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
