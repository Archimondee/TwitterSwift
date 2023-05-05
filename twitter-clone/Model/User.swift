//
//  User.swift
//  twitter-clone
//
//  Created by Gilang Aditya Rahman on 12/04/23.
//

import Firebase
import Foundation

struct User {
  var fullname: String
  var email: String
  var username: String
  var profileImageUrl: URL?
  var uid: String
  var isFollowed = false
  var stats: UserRelationStats?
  var bio: String?

  var isCurrentUser: Bool { return Auth.auth().currentUser?.uid == uid }

  init(uid: String, dictionary: [String: AnyObject]) {
    self.uid = uid
    self.fullname = dictionary["fullname"] as? String ?? ""
    self.email = dictionary["email"] as? String ?? ""
    self.username = dictionary["username"] as? String ?? ""
    if let profileImageUrlString = dictionary["profileImageUrl"] as? String {
      guard let url = URL(string: profileImageUrlString) else { return }
      self.profileImageUrl = url
    }
    if let bio = dictionary["bio"] as? String {
      self.bio = bio
    }
  }
}

struct UserRelationStats {
  var followers: Int
  var following: Int
}
