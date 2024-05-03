//
//  PaymentPageViewController.swift
//  LoginTest
//
//  Created by 정동교 on 5/3/24.
//

import Foundation
import UIKit

class PaymentPageViewController: UIViewController {
    
    @IBOutlet weak var paymentTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        paymentTableView.delegate = self
        paymentTableView.dataSource = self
    }
    @IBAction func backButtonTap(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true)
    }
}

extension PaymentPageViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentPageTableViewCell", for: indexPath) as! PaymentPageTableViewCell
        
        cell.totalTitle.text = "삼겹살 외 2"
        cell.totalPrice.text = "5000"
        cell.discountPrice.text = "1000"
        cell.paymentFee.text = "4000"
        
        return cell
    }
    
    
}
