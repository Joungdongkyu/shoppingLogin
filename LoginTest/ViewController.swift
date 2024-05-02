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
import SwiftyBootpay

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
    var vc: BootpayController!


    @IBOutlet weak var informationLabel: UILabel!
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
        
//        if !UserApi.isKakaoTalkLoginAvailable() {
//            
//        }
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
    // MARK: - 결제창 버튼
    @IBAction func paymentButtonTap(_ sender: Any) {
        goBuy()
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
        informationLabel.text = "로그인 해 주세요"
    }
    private func logoutUI() {
        loginButton.isHidden = true
        withdrawalButton.isHidden = false
        logOutButton.isHidden = false
        signButton.isHidden = true
        informationLabel.text = "\(userLoginNick)님 안녕하세요"
    }
    private func SigninUI() {
        loginButton.isHidden = true
        withdrawalButton.isHidden = true
        logOutButton.isHidden = false
        signButton.isHidden = false
        informationLabel.text = "회원가입 해 주세요"
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
                //  유저디폴트에 로그인한 정보의 유무에 따라 UI 변화
                if let loadData = UserDefaults.standard.object(forKey: userLoginNick) as? Data {
    //                유저 디폴트에 저장된 정보 로드
    //                if let loadObject = try? decoder.decode(User.self, from: loadData) {
    //                    print(loadObject)
    //                }
                    self.logoutUI()
                }else
                {
                    
                    self.SigninUI()
                }
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
    func goBuy() {
            // 통계정보를 위해 사용되는 정보
            // 주문 정보에 담길 상품정보로 배열 형태로 add가 가능함
            let item1 = BootpayItem().params {
                $0.item_name = "B사 마스카라" // 주문정보에 담길 상품명
                $0.qty = 1 // 해당 상품의 주문 수량
                $0.unique = "123" // 해당 상품의 고유 키
                $0.price = 1000 // 상품의 가격
            }
            let item2 = BootpayItem().params {
                $0.item_name = "C사 셔츠" // 주문정보에 담길 상품명
                $0.qty = 1 // 해당 상품의 주문 수량
                $0.unique = "1234" // 해당 상품의 고유 키
                $0.price = 10000 // 상품의 가격
                $0.cat1 = "패션"
                $0.cat2 = "여성상의"
                $0.cat3 = "블라우스"
            }

            // 커스텀 변수로, 서버에서 해당 값을 그대로 리턴 받음
            let customParams: [String: String] = [
                "callbackParam1": "value12",
                "callbackParam2": "value34",
                "callbackParam3": "value56",
                "callbackParam4": "value78",
                ]

            // 구매자 정보
            let userInfo: [String: String] = [
                "username": "사용자 이름",
                "email": "user1234@gmail.com",
                "addr": "사용자 주소",
                "phone": "010-1234-4567"
            ]

            // 구매자 정보
            let bootUser = BootpayUser()
            bootUser.params {
               $0.username = "사용자 이름"
               $0.email = "user1234@gmail.com"
               $0.area = "서울" // 사용자 주소
               $0.phone = "010-1234-4567"
            }

            let payload = BootpayPayload()
            payload.params {
               $0.price = 1000 // 결제할 금액
               $0.name = "블링블링's 마스카라" // 결제할 상품명
               $0.order_id = "1234_1234_124" // 결제 고유번호
               $0.params = customParams // 커스텀 변수
        //         $0.user_info = bootUser
               $0.pg = "" // 결제할 PG사
               $0.method = "easy"
               $0.ux = UX.PG_DIALOG
               //            $0.account_expire_at = "2019-09-25" // 가상계좌 입금기간 제한 ( yyyy-mm-dd 포멧으로 입력해주세요. 가상계좌만 적용됩니다. 오늘 날짜보다 더 뒤(미래)여야 합니다 )
               //            $0.method = "card" // 결제수단
               $0.show_agree_window = false
            }

            let extra = BootpayExtra()
            extra.quotas = [0, 2, 3] // 5만원 이상일 경우 할부 허용범위 설정 가능, (예제는 일시불, 2개월 할부, 3개월 할부 허용)

            var items = [BootpayItem]()
            items.append(item1)
            items.append(item2)

            Bootpay.request(self, sendable: self, payload: payload, user: bootUser, items: items, extra: extra, addView: true)
        }
    
    
}

extension ViewController: BootpayRequestProtocol {
    // 에러가 났을때 호출되는 부분
    func onError(data: [String: Any]) {
        print(data)
    }

    // 가상계좌 입금 계좌번호가 발급되면 호출되는 함수입니다.
    func onReady(data: [String: Any]) {
        print("ready")
        print(data)
    }

    // 결제가 진행되기 바로 직전 호출되는 함수로, 주로 재고처리 등의 로직이 수행
    func onConfirm(data: [String: Any]) {
        print(data)

        var iWantPay = true
        if iWantPay == true {  // 재고가 있을 경우.
            Bootpay.transactionConfirm(data: data) // 결제 승인
        } else { // 재고가 없어 중간에 결제창을 닫고 싶을 경우
            Bootpay.dismiss() // 결제창 종료
        }
    }

    // 결제 취소시 호출
    func onCancel(data: [String: Any]) {
        print(data)
    }

    // 결제완료시 호출
    // 아이템 지급 등 데이터 동기화 로직을 수행합니다
    func onDone(data: [String: Any]) {
        print(data)
    }

    //결제창이 닫힐때 실행되는 부분
    func onClose() {
        print("close")
        Bootpay.dismiss() // 결제창 종료
    }
}
