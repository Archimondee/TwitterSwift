//
//  UserService.swift
//  twitter-clone
//
//  Created by Gilang Aditya Rahman on 12/04/23.
//

import Firebase
import Foundation

typealias DatabaseCompletion = (Error?, DatabaseReference) -> Void

struct UserService {
  static let shared = UserService()

  func fetchUser(uid: String, completion: @escaping (User) -> Void) {
    REF_USERS.child(uid).observeSingleEvent(of: .value) { snapshot in
      guard let dictionay = snapshot.value as? [String: AnyObject] else { return }

      let user = User(uid: uid, dictionary: dictionay)
      completion(user)
    }
  }

  func fetchUsers(completion: @escaping ([User]) -> Void) {
    var users = [User]()
    REF_USERS.observe(.childAdded) { snapshot in
      let uid = snapshot.key
      guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
      let user = User(uid: uid, dictionary: dictionary)
      users.append(user)
      completion(users)
    }
  }

  func followUser(uid: String, completion: @escaping (DatabaseCompletion)) {
    guard let currentUid = Auth.auth().currentUser?.uid else { return }
    REF_USER_FOLLOWING.child(currentUid).updateChildValues([uid: 1]) { _, _ in
      REF_USER_FOLLOWERS.child(uid).updateChildValues([currentUid: 1], withCompletionBlock: completion)
    }
  }

  func unfollowUser(uid: String, completion: @escaping (DatabaseCompletion)) {
    guard let currentUid = Auth.auth().currentUser?.uid else { return }

    REF_USER_FOLLOWING.child(currentUid).child(uid).removeValue { _, _ in
      REF_USER_FOLLOWERS.child(uid).child(currentUid).removeValue(completionBlock: completion)
    }
  }

  func checkIfUserIsFollowed(uid: String, completion: @escaping (Bool) -> Void) {
    guard let currentUid = Auth.auth().currentUser?.uid else { return }

    REF_USER_FOLLOWING.child(currentUid).child(uid).observeSingleEvent(of: .value) { snapshot in
      completion(snapshot.exists())
    }
  }

  func fetchUserStats(uid: String, completion: @escaping (UserRelationStats) -> Void) {
    REF_USER_FOLLOWERS.child(uid).observeSingleEvent(of: .value) { snapshot in
      let followers = snapshot.children.allObjects.count

      REF_USER_FOLLOWING.child(uid).observeSingleEvent(of: .value) { snapshot in
        let following = snapshot.children.allObjects.count

        let stats = UserRelationStats(followers: followers, following: following)
        completion(stats)
      }
    }
  }

  func saveUserData(user: User, completion: @escaping (DatabaseCompletion)) {
    guard let uid = Auth.auth().currentUser?.uid else { return }

    let values = ["fullname": user.fullname, "username": user.username, "bio": user.bio ?? ""]

    REF_USERS.child(uid).updateChildValues(values, withCompletionBlock: completion)
  }

  func updateProfileImage(image: UIImage, completion: @escaping (URL?) -> Void) {
    guard let imageData = image.jpegData(compressionQuality: 0.3) else { return }
    guard let uid = Auth.auth().currentUser?.uid else { return }

    let filename = NSUUID().uuidString
    let ref = STORAGE_PROFILE_IMAGES.child(filename)

    ref.putData(imageData, metadata: nil) { _, _ in
      ref.downloadURL { url, _ in
        guard let profileImageUrl = url?.absoluteString else { return }
        let values = ["profileImageUrl": profileImageUrl]

        REF_USERS.child(uid).updateChildValues(values) { _, _ in
          completion(url)
        }
      }
    }
  }

  func fetchUser(withUsername username: String, completion: @escaping (User) -> Void) {
    REF_USER_USERNAMES.child(username).observeSingleEvent(of: .value) { snapshot in
      guard let uid = snapshot.value as? String else { return }

      self.fetchUser(uid: uid, completion: completion)
    }
  }
}
