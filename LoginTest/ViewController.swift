//
//  ViewController.swift
//  LoginTest
//
//  Created by 정동교 on 4/29/24.
//

import UIKit
import KakaoSDKUser
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

class ViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signButton: UIButton!
    @IBOutlet weak var logOutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func loginButtonTap(_ sender: Any) {
        print("로그인 버튼")
        // 카카오톡 설치 여부 확인
        UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("loginWithKakaoAccount() success.")

                    //do something
                    self.kakaoGetUserInfo()
                }
            }
//        if (UserApi.isKakaoTalkLoginAvailable()) {
//            
//            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
//                if let error = error {
//                    print(error)
//                }
//                else {
//                    print("loginWithKakaoTalk() success.")
//
//                   //let idToken = oAuthToken.idToken ?? ""
//                   //let accessToken = oAuthToken.accessToken
//                   
//                   self.kakaoGetUserInfo()
//                }
//            }
//        }else{
//            print("??")
//        }
    }
    @IBAction func signButtonTap(_ sender: Any) {
      
    }
    @IBAction func logOutButtonTap(_ sender: Any) {
        print("로그아웃")
        UserApi.shared.logout {(error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("logout() success.")
                }
            }
       
    }
    
    // 사용자 항목 가져오기
    private func kakaoGetUserInfo() {
        UserApi.shared.me { user, error in
            if let error = error {
                print(error)
            }

            let userName = user?.kakaoAccount?.name
          
            if userName == nil {
                self.kakaoRequestAgreement()
                return
            }

        }
    }
    // 동의
    private func kakaoRequestAgreement() {
        UserApi.shared.me { user, error in
            if let error = error {
                print(error)
            }
            else {
                guard let user = user else { return }
                var scopes = [String]()
                if (user.kakaoAccount?.profileNeedsAgreement == true) { scopes.append("profile") }
                if (user.kakaoAccount?.emailNeedsAgreement == true) { scopes.append("account_email") }
                if (user.kakaoAccount?.birthdayNeedsAgreement == true) { scopes.append("birthday") }
                if (user.kakaoAccount?.birthyearNeedsAgreement == true) { scopes.append("birthyear") }
                if (user.kakaoAccount?.genderNeedsAgreement == true) { scopes.append("gender") }
                if (user.kakaoAccount?.phoneNumberNeedsAgreement == true) { scopes.append("phone_number") }
                if (user.kakaoAccount?.ageRangeNeedsAgreement == true) { scopes.append("age_range") }
                if (user.kakaoAccount?.ciNeedsAgreement == true) { scopes.append("account_ci") }
                
                if scopes.count > 0 {
                    print("사용자에게 추가 동의를 받아야 합니다.")
                    
                    UserApi.shared.loginWithKakaoAccount(scopes: scopes) { _, error in
                        if let error = error {
                            print(error,"에러1")
                        }
                        else {
                            UserApi.shared.me { user, error in
                                if let error = error {
                                    print(error,"에러2")
                                }
                                else {
                                    print("me() success.")
                                    guard let user = user else { return }
                                    // do something
                                   
                                
                                    
                                   
                                }
                            }
                        }
                    }
                }
                else {
                    print("사용자의 추가 동의가 필요하지 않습니다.")
                }
            }
        }
    }
}

