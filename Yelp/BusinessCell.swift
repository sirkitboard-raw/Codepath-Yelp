//
//  BusinessCell.swift
//  Yelp
//
//  Created by Aditya Balwani on 2/18/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {

    @IBOutlet weak var bussinessImage: UIImageView!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var reviewsLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    var business : Business! {
        didSet {
            nameLabel.text = business.name
            bussinessImage.setImageWithURL(business.imageURL!)
            addressLabel.text = business.address
            ratingImageView.setImageWithURL(business.ratingImageURL!)
            distanceLabel.text = business.distance
            typeLabel.text = business.categories
            reviewsLabel.text = "\(business.reviewCount) Reviews"
            
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bussinessImage.layer.cornerRadius = 3
        bussinessImage.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
