//
//  Notification.swift
//  twitter-clone
//
//  Created by Gilang Aditya Rahman on 24/04/23.
//

import Foundation

struct Notification {
  let tweetID: String?
  var timestamp: Date!
  let user: User
  var tweet: Tweet?

  init(user: User, tweet: Tweet? = nil, dictionary: [String: AnyObject]) {
    self.user = user
    self.tweet = tweet

    self.tweetID = dictionary["tweetID"] as? String ?? ""

    if let timestamp = dictionary["timestamp"] as? Double {
      self.timestamp = Date(timeIntervalSince1970: timestamp)
    }
  }
}
