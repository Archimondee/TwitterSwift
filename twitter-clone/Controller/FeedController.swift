//
//  FeedController.swift
//  twitter-clone
//
//  Created by Gilang Aditya Rahman on 11/04/23.
//

import SDWebImage
import UIKit

private let reuseIdentifier = "Tweetcell"

class FeedController: UICollectionViewController {
  // MARK: - Properties

  var user: User? {
    didSet {
      configureLeftButton()
    }
  }

  private var tweets = [Tweet]() {
    didSet {
      collectionView.reloadData()
    }
  }

  // MARK: - Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()

    configureUI()
    fetchTweets()
  }

  // MARK: - API

  func fetchTweets() {
    TweetService.shared.fetchTweets { tweets in
      self.tweets = tweets
    }
  }

  // MARK: - Helpers

  func configureUI() {
    view.backgroundColor = .white

    collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    collectionView.backgroundColor = .clear
    collectionView.showsVerticalScrollIndicator = false

    let imageView = UIImageView(image: UIImage(named: "twitter_logo_blue"))
    imageView.contentMode = .scaleAspectFit
    imageView.setDimensions(width: 44, height: 44)
    navigationItem.titleView = imageView
  }

  func configureLeftButton() {
    guard let user = user else { return }
    let profileImageView = UIImageView()
    profileImageView.backgroundColor = .twitterBlue
    profileImageView.setDimensions(width: 32, height: 32)
    profileImageView.layer.cornerRadius = 32 / 2
    profileImageView.layer.masksToBounds = true
    profileImageView.sd_setImage(with: user.profileImageUrl, completed: nil)
    navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileImageView)
  }
}

// MARK: UICollectionViewDelegate / DataSource

extension FeedController {
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return tweets.count
  }

  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TweetCell

    cell.tweet = tweets[indexPath.row]
    return cell
  }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension FeedController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: view.frame.width, height: 120)
  }
}
