//
//  UserInfoManager.swift
//  MyMemory
//
//  Created by prologue on 2017. 6. 11..
//  Copyright © 2017년 rubypaper. All rights reserved.
//

import UIKit

struct UserInfoKey {
  // 저장에 사용할 키
  static let loginId = "LOGINID"
  static let account = "ACCOUNT"
  static let name = "NAME"
  static let profile = "PROFILE"
  static let tutorial = "TUTORIAL"
}

// 계정 및 사용자 정보를 저장 관리하는 클래스
// 사용자가 설정한 개인정보를 UserDefauls 객체에 저장하고 필요할 때 이를 꺼내어 주는 역할을 담당한다.
// 데이터를 저장하거나 읽어오는 로직을 그때그때 필요한 곳에서 직접 구현하는 것이 아니라 이 역할을 독립적인 객체 하나에 모두 전담시킨다.
// (일반적으로 객체지향 프로그래밍에서는 독립적인 모듈관리 클래스에 Manager이라는 접미사를 붙이는 관례가 있다.)

/*
 매니저 객체를 사용해야 하는 이유
 
 이 앱은 여러곳에서 사용자 정보를 이용한다. 필요할때마다 프로퍼티 리스트에 직접 접근하여 데이터를 처리한다면 결과적으로 코드의 중복이 심해질 뿐만 아니라 데이터의 일관성을 보장하기도 어렵다. 하지만 사용자 정보를 전담 관리하는 매니저 객체를 만들고, 이를 통해서만 사용자 데이터를 읽고 쓸 수 있도록 한다면 문제를 줄여나갈 수 있다. 게다가 데이터 처리과정이 캡슐화되기 때문에, 각각의 뷰컨트롤러는 복잡한 과정 거칠 필요 없이 간단한 메소드 호출이나 속성참조만으로 사용자 데이터를 이용할 수 있다. 이는 코드의 경량화에 도움을 준다.
 */
class UserInfoManager {
  // 연산 프로퍼티 loginId 정의
  var loginid: Int {
    get {
        // get 구문에서는 프로퍼티 리스트에 저장된 아이디를 꺼내어 제공한다.
      return UserDefaults.standard.integer(forKey: UserInfoKey.loginId)
    }
    set(v) {
        // set 구문에서는 loginId 프로퍼티에 할당된 값을 프로퍼티 리스트에 저장한다.
      let ud = UserDefaults.standard
      ud.set(v, forKey: UserInfoKey.loginId)
      ud.synchronize()
    }
  }
  
    // 계정정보를 저장하는 역할 프로퍼티가 옵셔널 타입으로 설정 : 이는 비로그인 상태일때 이를 nil로 설정하기 위함.
var account: String? {
    get {
      return UserDefaults.standard.string(forKey: UserInfoKey.account)
    }
    set (v) {
      let ud = UserDefaults.standard
      ud.set(v, forKey: UserInfoKey.account)
      ud.synchronize()
    }
  }
  
  var name: String? {
    get {
      return UserDefaults.standard.string(forKey: UserInfoKey.name)
    }
    set (v) {
      let ud = UserDefaults.standard
      ud.set(v, forKey: UserInfoKey.name)
      ud.synchronize()
    }
  }
  
  var profile: UIImage? {
    get {
      let ud = UserDefaults.standard
        if let _profile = ud.data(forKey: UserInfoKey.profile) {
        return UIImage(data: _profile)
      } else {
        return UIImage(named: "account.jpg") // 이미지가 없다면 기본 이미지로
      }
    }
    set(v) {
      if v != nil {
        // UIImage 타입은 프로퍼티 리스트에 직접 저장할 수 없어서 data타입으로 변환 후 저장해야 한다.
        let ud = UserDefaults.standard
        ud.set(UIImagePNGRepresentation( v! ), forKey: UserInfoKey.profile)
        ud.synchronize()
      }
    }
  }
  
  var isLogin: Bool {
    // 로그인 아이디가 0이거나 계정이 비어 있으면
    if self.loginid == 0 || self.account == nil {
      return false
    } else {
      return true
    }
  }
  
  func login(account: String, passwd: String) -> Bool {
    // 이 부분은 나중에 서버와 연동되는 코드로 대체될 예정입니다.
    if account.isEqual("jihyea@naver.com") && passwd.isEqual("1234") {
      let ud = UserDefaults.standard
      ud.set(100, forKey: UserInfoKey.loginId)
      ud.set(account, forKey: UserInfoKey.account)
      ud.set("지헤", forKey: UserInfoKey.name)
      ud.synchronize()
      return true
    } else {
      return false
    }
  }
  
  func logout() -> Bool {
    // iOS 에서는 세션 개념이 없다. 따라서 프로퍼티 리스트에 저장된 사용자 데이터를 삭제하기만 하면, 그것으로 로그아웃 상태를 만들어낼 수 있다. 프로퍼티 리스트에 저장된 모든 사용자 데이터를 차례대로 삭제하여 로그아웃 처리를 하고있다.
    let ud = UserDefaults.standard
    ud.removeObject(forKey: UserInfoKey.loginId)
    ud.removeObject(forKey: UserInfoKey.account)
    ud.removeObject(forKey: UserInfoKey.name)
    ud.removeObject(forKey: UserInfoKey.profile)
    ud.synchronize()
    return true
  }
  
  
}






