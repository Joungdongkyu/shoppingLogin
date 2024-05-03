//
//  DetailPageViewController.swift
//  LoginTest
//
//  Created by 정동교 on 5/3/24.
//

import Foundation
import UIKit

class DetailPageViewController: UIViewController {
    @IBOutlet weak var detailTitle: UILabel!
    @IBOutlet weak var detailImage: UIImageView!
    @IBOutlet weak var detailPrice: UILabel!
    @IBOutlet weak var detailDescription: UILabel!
    @IBAction func backButton(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        detailTitle.text = "바나나"
        detailDescription.text = "노란고 긴 바나나 입니다."
        detailPrice.text = "2000"
        imageUpDate(with: "https://health.chosun.com/site/data/img_dir/2022/05/04/2022050401754_0.jpg")
        
    }
    func imageUpDate(with feedElement: String) {
        detailImage.loadImage(url: feedElement)
    }
}
