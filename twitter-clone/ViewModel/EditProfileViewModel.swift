//
//  EditProfileViewModel.swift
//  twitter-clone
//
//  Created by Gilang Aditya Rahman on 27/04/23.
//

import Foundation

enum EditProfileOptions: Int, CaseIterable {
  case fullname
  case username
  case bio

  var description: String {
    switch self {
    case .username: return "Username"
    case .fullname: return "Name"
    case .bio: return "Bio"
    }
  }
}

struct EditProfileViewModel {
  private let user: User
  let option: EditProfileOptions

  var titleText: String {
    return option.description
  }

  var shouldHideTextField: Bool {
    return option == .bio
  }

  var shoulHideTextView: Bool {
    return option != .bio
  }

  var optionValue: String? {
    switch option {
    case .fullname:
      return user.username
    case .username: return user.username
    case .bio: return user.bio
    }
  }
  
  var shouldHidePlaceholderLabel: Bool {
    return user.bio != nil
  }

  init(user: User, option: EditProfileOptions) {
    self.user = user
    self.option = option
  }
}
