//
//  Tweet.swift
//  twitter-clone
//
//  Created by Gilang Aditya Rahman on 13/04/23.
//

import Foundation

struct Tweet {
  let caption: String
  let tweetID: String
  let uid: String
  var likes: Int
  var timestamp: Date!
  let retweetCount: Int
  let user: User
  var didLike = false

  init(user: User, tweetID: String, dictionary: [String: Any]) {
    self.tweetID = tweetID
    self.user = user
    self.caption = dictionary["caption"] as? String ?? ""
    self.likes = dictionary["likes"] as? Int ?? 0
    self.retweetCount = dictionary["retweets"] as? Int ?? 0
    self.uid = dictionary["uid"] as? String ?? ""

    if let timestamp = dictionary["timestamp"] as? Double {
      self.timestamp = Date(timeIntervalSince1970: timestamp)
    }
  }
}
