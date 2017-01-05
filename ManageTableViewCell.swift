//
//  ManageTableViewCell.swift
//  YardSale
//
//  Created by Caitlyn Chen on 1/3/17.
//  Copyright © 2017 Caitlyn Chen. All rights reserved.
//

import UIKit

class ManageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
   
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var titleLabel: UILabel!

//    @IBOutlet weak var soldButton: UIButton!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

   
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
