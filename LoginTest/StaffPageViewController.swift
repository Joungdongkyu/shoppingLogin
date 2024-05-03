//
//  StaffPageViewController.swift
//  LoginTest
//
//  Created by 정동교 on 5/3/24.
//

import Foundation
import UIKit

class StaffPageViewController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var imageURLTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func backButton(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true)
    }
    @IBAction func saveButton(_ sender: Any) {
        
//        let goods = Goods(title: titleTextField.text!, price: titleTextField.text!, description: descriptionTextView.text!, Image: imageURLTextField.text!)
//        if let loadData = UserDefaults.standard.object(forKey: "Goods") as? Data {
//            if let loadObject = try? decoder.decode([Goods].self, from: loadData) {
//                
//                print(loadObject,"!!!!!")
//                
//                
//                if let encoded = try? encoder.encode([loadObject]) {
//                    if loadObject == nil {
//                        UserDefaults.standard.setValue([goods], forKey: "Goods")
//                    }else{
//                        
//                        UserDefaults.standard.setValue(encoded, forKey: "Goods")
//                    }
//                    
//                    
//                }
//            }
//        }else {
//            if let encoded = try? encoder.encode([goods]){
//                UserDefaults.standard.setValue([goods], forKey: "Goods")
//            }
//        }
//        
//        
//  
//        
//        if let loadData2 = UserDefaults.standard.object(forKey: "Goods") as? Data {
//            if let loadObject = try? decoder.decode([Goods].self, from: loadData2) {
//                print(loadObject)
//            }
//        }
        
        titleTextField.text = ""
        priceTextField.text = ""
        imageURLTextField.text = ""
        descriptionTextView.text = ""
    }
}
