//
//  ShoppingPageTableViewCell.swift
//  LoginTest
//
//  Created by 정동교 on 5/3/24.
//

import UIKit

class ShoppingPageTableViewCell: UITableViewCell {

    @IBOutlet weak var shoppingTableCellTitle: UILabel!
    @IBOutlet weak var shoppingTableCellPrice: UILabel!
    @IBOutlet weak var shoppingTableCellImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    func imageUpDate(with feedElement: String) {
        shoppingTableCellImage.loadImage(url: feedElement)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
