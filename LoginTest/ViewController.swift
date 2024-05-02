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

struct User: Codable {
    let nickName: String
    let coupon: [Coupon]
}
struct Coupon: Codable {
    let couponName: String
    let expiration: Int
}

let encoder = JSONEncoder()
let decoder = JSONDecoder()
var userLoginNick = ""

class ViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signButton: UIButton!
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var withdrawalButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginUI()
    }

    // MARK: - 로그인 버튼
    @IBAction func loginButtonTap(_ sender: Any) {
        
        self.kakaoWebLogin()
        
        if !UserApi.isKakaoTalkLoginAvailable() {
            if let loadData = UserDefaults.standard.object(forKey: userLoginNick) as? Data {
                //유저 디폴트에 저장된 정보 로드
//                if let loadObject = try? decoder.decode(User.self, from: loadData) {
//                    print(loadObject)
//                }
                logoutUI()
            }else
            {
                SigninUI()
            }
        }
    }
    // MARK: - 회원가입 버튼
    @IBAction func signButtonTap(_ sender: Any) {
        let coup = Coupon(couponName: "웰컴 쿠폰", expiration: 1)
        let person = User(nickName: userLoginNick, coupon: [coup])
        if let encoded = try? encoder.encode(person) {
            UserDefaults.standard.setValue(encoded, forKey: userLoginNick)
        }
        logoutUI()
    }
    // MARK: - 회원탈퇴 버튼
    @IBAction func withdrawalButtonTap(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: userLoginNick)
        if let loadData = UserDefaults.standard.object(forKey: userLoginNick) as? Data {
            if let loadObject = try? decoder.decode(User.self, from: loadData) {
                print(loadObject)
            }
        }else{
            print("사용자의 정보가 없습니다")
        }
        loginUI()
    }
    // MARK: - 로그아웃 버튼
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
        loginUI()
    }
    private func loginUI() {
        loginButton.isHidden = false
        withdrawalButton.isHidden = true
        logOutButton.isHidden = true
        signButton.isHidden = true
    }
    private func logoutUI() {
        loginButton.isHidden = true
        withdrawalButton.isHidden = false
        logOutButton.isHidden = false
        signButton.isHidden = false
    }
    private func SigninUI() {
        loginButton.isHidden = true
        withdrawalButton.isHidden = true
        logOutButton.isHidden = false
        signButton.isHidden = false
    }
    // MARK: - 카카오 앱 로그인
    private func kakaoAppLogin() {
        if (UserApi.isKakaoTalkLoginAvailable()) {
       
                   UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                       if let error = error {
                           print(error)
                       }
                       else {
                           print("loginWithKakaoTalk() success.")
       
                          //let idToken = oAuthToken.idToken ?? ""
                          //let accessToken = oAuthToken.accessToken
       
                          self.kakaoGetUserInfo()
                       }
                   }
               }else{
                   print("??")
               }
    }
    
    // MARK: - 카카오 웹 로그인
    private func kakaoWebLogin() {
        UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("loginWithKakaoAccount() success.")

                    self.kakaoGetUserInfo()
            }
        }
    }
    
    // MARK: - 사용자 항목 가져오는 함수
    private func kakaoGetUserInfo() {
        UserApi.shared.me { user, error in
            if let error = error {
                print(error)
            }

            let userName = (user?.kakaoAccount?.profile?.nickname)!
//            print((user?.kakaoAccount?.profile?.nickname)!)
//            print(user?.kakaoAccount?.name)
            
            if userName == nil {
                self.kakaoRequestAgreement()
                return
            }else {
                userLoginNick = (user?.kakaoAccount?.profile?.nickname)!
            }

        }
    }
    // MARK: - 사용자 로그인 정보 동의 함수
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

