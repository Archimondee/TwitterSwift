//
//  UserService.swift
//  twitter-clone
//
//  Created by Gilang Aditya Rahman on 12/04/23.
//

import Firebase
import Foundation

struct UserService {
  static let shared = UserService()

  func fetchUser() {
    guard let uid = Auth.auth().currentUser?.uid else { return }

    REF_USERS.child(uid).observeSingleEvent(of: .value) { snapshot in
      guard let dictionay = snapshot.value as? [String: AnyObject] else { return }
      
      let user = User(uid: uid, dictionary: dictionay)
    }
  }
}
