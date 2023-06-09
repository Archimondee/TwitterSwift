//
//  ProfileHeaderViewModel.swift
//  twitter-clone
//
//  Created by Gilang Aditya Rahman on 18/04/23.
//

import Firebase
import Foundation
import UIKit

enum ProfileFilterOptions: Int, CaseIterable {
  case tweets
  case replies
  case likes

  var descriptions: String {
    switch self {
    case .tweets: return "Tweets"
    case .replies: return "Tweets & Replies"
    case .likes: return "Likes"
    }
  }
}

struct ProfileHeaderViewModel {
  private let user: User

  let usernameText: String

  var followersString: NSAttributedString? {
    return attributedText(withValue: user.stats?.followers ?? 0, text: "followers")
  }

  var followingString: NSAttributedString? {
    return attributedText(withValue: user.stats?.following ?? 0, text: "following")
  }

  var actionButtonTitle: String {
    if user.isCurrentUser {
      return "Edit Profile"
    }
    if !user.isFollowed && !user.isCurrentUser {
      return "Follow"
    }

    if user.isFollowed {
      return "Following"
    }

    return ""
  }

  init(user: User) {
    self.user = user

    self.usernameText = "@" + user.username.lowercased()
  }

  fileprivate func attributedText(withValue value: Int, text: String) -> NSAttributedString {
    let attributedTitle = NSMutableAttributedString(string: "\(value)",
                                                    attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
    attributedTitle.append(NSAttributedString(string: " \(text)",
                                              attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
                                                           NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
    return attributedTitle
  }
}
