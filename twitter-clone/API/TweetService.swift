//
//  TweetService.swift
//  twitter-clone
//
//  Created by Gilang Aditya Rahman on 13/04/23.
//

import Firebase
import Foundation

struct TweetService {
  static let shared = TweetService()

  func uploadTweet(caption: String, completion: @escaping (Error?, DatabaseReference) -> Void) {
    guard let uid = Auth.auth().currentUser?.uid else { return }

    let values = ["uid": uid, "timestamp": Int(NSDate().timeIntervalSince1970),
                  "likes": 0, "retweets": 0, "caption": caption] as [String: Any]
    REF_TWEETS.childByAutoId().updateChildValues(values, withCompletionBlock: completion)
  }

  func fetchTweets(completion: @escaping ([Tweet]) -> Void) {
    var tweets = [Tweet]()

    REF_TWEETS.observe(.childAdded) { snapshot in
      guard let dictionary = snapshot.value as? [String: Any] else { return }
      guard let uid = dictionary["uid"] as? String else { return }
      let tweetId = snapshot.key

      UserService.shared.fetchUser(uid: uid) { user in
        let tweet = Tweet(user: user, tweetID: tweetId, dictionary: dictionary)
        tweets.append(tweet)
        completion(tweets)
      }
    }
  }
}