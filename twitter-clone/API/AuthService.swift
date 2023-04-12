//
//  AuthService.swift
//  twitter-clone
//
//  Created by Gilang Aditya Rahman on 12/04/23.
//

import Firebase
import Foundation
import UIKit

struct AuthCredentials {
  let email: String
  let password: String
  let fullname: String
  let username: String
  let profileImage: UIImage
}

struct AuthService {
  static let shared = AuthService()

  func logUserIn(withEmail email: String, password: String, completion: @escaping (AuthDataResult?, Error?) -> Void) {
    Auth.auth().signIn(withEmail: email, password: password, completion: completion)
  }

  func registerUser(credentials: AuthCredentials, completion: @escaping (Error?, DatabaseReference) -> Void) {
    let email = credentials.email
    let password = credentials.password
    let fullname = credentials.fullname
    let username = credentials.username
    let profileImage = credentials.profileImage

    guard let imageData = profileImage.jpegData(compressionQuality: 0.3) else { return }
    let filename = NSUUID().uuidString
    let storageRef = STORAGE_PROFILE_IMAGES.child(filename)
    storageRef.putData(imageData) { _, _ in
      storageRef.downloadURL { url, _ in
        guard let profileImageUrl = url?.absoluteString else { return }

        Auth.auth().createUser(withEmail: email, password: password) { result, error in
          if let error = error {
            print("Error \(error.localizedDescription)")
            return
          }

          guard let uid = result?.user.uid else { return }
          let values = ["email": email, "username": username, "fullname": fullname, "profileImageUrl": profileImageUrl]

          REF_USERS.updateChildValues(values, withCompletionBlock: completion)
        }
      }
    }
  }
}
