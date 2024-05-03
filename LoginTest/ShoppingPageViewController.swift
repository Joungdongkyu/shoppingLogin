//
//  ShoppingPageViewController.swift
//  LoginTest
//
//  Created by 정동교 on 5/3/24.
//

import Foundation
import UIKit
import KakaoSDKUser
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser
import SwiftyBootpay

class ShoppingPageViewController: UIViewController {
    @IBOutlet weak var shoppingTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        shoppingTableView.delegate = self
        shoppingTableView.dataSource = self
    }
    override func viewDidAppear(_ animated: Bool) {
        shoppingTableView.reloadData()
    }
    @IBAction func menuButtonTab(_ sender: Any) {
        let alert = UIAlertController(title: "", message: "메뉴를 골라주세요", preferredStyle: UIAlertController.Style.alert)
        
        let paymentAction = UIAlertAction(title: "결제내역 확인", style: UIAlertAction.Style.default){(_) in
            let tapPaymentPageVC = UIStoryboard.init(name: "PaymentPage", bundle: nil)
             guard let PaymentPageVC = tapPaymentPageVC.instantiateViewController(withIdentifier: "PaymentPage")as? PaymentPageViewController else {return}
             
            PaymentPageVC.modalPresentationStyle = .fullScreen
            self.present(PaymentPageVC, animated: true, completion: nil)
        }
        let logOutAction = UIAlertAction(title: "로그아웃", style: UIAlertAction.Style.default){(_) in
            UserApi.shared.logout {(error) in
                    if let error = error {
                        print(error)
                    }
                    else {
                        print("logout() success.")
                    }
                }
            self.presentingViewController?.dismiss(animated: true)
        }
        let staffAction = UIAlertAction(title: "관리자 권한", style: UIAlertAction.Style.default){(_) in
            let tapStaffPageVC = UIStoryboard.init(name: "StaffPage", bundle: nil)
             guard let StaffPageVC = tapStaffPageVC.instantiateViewController(withIdentifier: "StaffPage")as? StaffPageViewController else {return}
             
            StaffPageVC.modalPresentationStyle = .fullScreen
            self.present(StaffPageVC, animated: true, completion: nil)
        }
        let deleteAction = UIAlertAction(title: "회원탈퇴", style: UIAlertAction.Style.destructive){(_) in
            let deleteAlert = UIAlertController(title: "", message: "회원탈퇴를 하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
            let deleteAlertDon = UIAlertAction(title: "삭제", style: UIAlertAction.Style.destructive){(_) in
                UserDefaults.standard.removeObject(forKey: userLoginNick)
                if let loadData = UserDefaults.standard.object(forKey: userLoginNick) as? Data {
                    if let loadObject = try? decoder.decode(User.self, from: loadData) {
                        print(loadObject)
                    }
                }else{
                    print("사용자의 정보가 없습니다")
                }
                self.presentingViewController?.dismiss(animated: true)
            }
            let deleteAlertCancel = UIAlertAction(title: "취소", style: UIAlertAction.Style.cancel, handler: nil)
            
            deleteAlert.addAction(deleteAlertDon)
            deleteAlert.addAction(deleteAlertCancel)

            self.present(deleteAlert, animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: UIAlertAction.Style.cancel, handler: nil)

        alert.addAction(staffAction)
        alert.addAction(logOutAction)
        alert.addAction(paymentAction)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        

        present(alert, animated: true)
    }
    
}
extension ShoppingPageViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print(UserDefaults.standard.object(forKey: "Goods"))
//        if let loadData = UserDefaults.standard.object(forKey: "Goods") as? Data {
//            if let loadObject = try? decoder.decode([Goods].self, from: loadData) {
//                return loadObject.count
//            }
//        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingPageTableViewCell", for: indexPath) as! ShoppingPageTableViewCell
//        if let loadData = UserDefaults.standard.object(forKey: "Goods") as? Data {
//            if let loadObject = try? decoder.decode([Goods].self, from: loadData) {
//                cell.shoppingTableCellTitle.text = loadObject[index].title
//                cell.shoppingTableCellPrice.text = loadObject[index].price
//                cell.imageUpDate(with: loadObject[index].Image)
//            }
//        }
        
        cell.shoppingTableCellTitle.text = "바나나"
        cell.shoppingTableCellPrice.text = "2000"
        cell.imageUpDate(with: "https://health.chosun.com/site/data/img_dir/2022/05/04/2022050401754_0.jpg")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tapDetailPageVC = UIStoryboard.init(name: "DetailPage", bundle: nil)
         guard let detailPageVC = tapDetailPageVC.instantiateViewController(withIdentifier: "DetailPage")as? DetailPageViewController else {return}
         
        detailPageVC.modalPresentationStyle = .fullScreen
        self.present(detailPageVC, animated: true, completion: nil)
    }
}
extension UIImageView {
    func loadImage(url: String) {
        guard let url = URL(string: url) else { return }
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
