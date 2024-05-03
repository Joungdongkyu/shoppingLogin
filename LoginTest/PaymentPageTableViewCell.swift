//
//  PaymentPageTableViewCell.swift
//  LoginTest
//
//  Created by 정동교 on 5/3/24.
//

import UIKit

class PaymentPageTableViewCell: UITableViewCell {

    @IBOutlet weak var totalTitle: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var discountPrice: UILabel!
    @IBOutlet weak var paymentFee: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
