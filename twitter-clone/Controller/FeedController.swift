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

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    navigationController?.isNavigationBarHidden = false
  }

  // MARK: - API

  func fetchTweets() {
    collectionView.refreshControl?.beginRefreshing()
    TweetService.shared.fetchTweets { tweets in

      self.tweets = tweets.sorted(by: { tweet1, tweet2 -> Bool in
        tweet1.timestamp > tweet2.timestamp
      })
      self.checkIfUserLikedTweets()
      self.collectionView.refreshControl?.endRefreshing()
    }
  }

  func checkIfUserLikedTweets() {
    tweets.forEach { tweet in
      TweetService.shared.checkIfUserLikedTweet(tweet) { didLike in
        guard didLike == true else { return }
        if let index = self.tweets.firstIndex(where: { $0.tweetID == tweet.tweetID }) {
          self.tweets[index].didLike = true
        }
      }
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

    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    collectionView.refreshControl = refreshControl
  }

  func configureLeftButton() {
    guard let user = user else { return }
    let profileImageView = UIImageView()
    profileImageView.backgroundColor = .twitterBlue
    profileImageView.setDimensions(width: 32, height: 32)
    profileImageView.layer.cornerRadius = 32 / 2
    profileImageView.layer.masksToBounds = true
    profileImageView.sd_setImage(with: user.profileImageUrl, completed: nil)
    profileImageView.isUserInteractionEnabled = true
    let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTap))
    profileImageView.addGestureRecognizer(tap)

    navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileImageView)
  }

  // MARK: - Selectors

  @objc func handleRefresh() {
    fetchTweets()
  }

  @objc func handleProfileImageTap() {
    guard let user = user else { return }

    let controller = ProfileController(user: user)
    navigationController?.pushViewController(controller, animated: true)
  }
}

// MARK: UICollectionViewDelegate / DataSource

extension FeedController {
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return tweets.count
  }

  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TweetCell
    cell.delegate = self
    cell.tweet = tweets[indexPath.row]
    return cell
  }

  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let controller = TweetController(tweet: tweets[indexPath.row])
    navigationController?.pushViewController(controller, animated: true)
  }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension FeedController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let viewModel = TweetViewModel(tweet: tweets[indexPath.row])
    let height = viewModel.size(forWidth: view.frame.width).height
    return CGSize(width: view.frame.width, height: height + 90)
  }
}

extension FeedController: TweetCellDelegate {
  func handleLikeTapped(_ cell: TweetCell) {
    guard let tweet = cell.tweet else { return }
    TweetService.shared.likeTweet(tweet: tweet) { _, _ in
      cell.tweet?.didLike.toggle()
      let likes = tweet.didLike ? tweet.likes - 1 : tweet.likes + 1
      cell.tweet?.likes = likes

      // Only upload notification if tweet is being liked
      guard !tweet.didLike else { return }
      NotificationService.shared.uploadNotification(toUser: tweet.user, type: .like, tweetID: tweet.tweetID)
    }
  }

  func handleProfileImageTapped(_ cell: TweetCell) {
    guard let user = cell.tweet?.user else { return }
    let viewController = ProfileController(user: user)
    navigationController?.pushViewController(viewController, animated: true)
  }

  func handleReplyTapped(_ cell: TweetCell) {
    guard let tweet = cell.tweet else { return }
    let controller = UploadTweetController(user: tweet.user, config: .reply(tweet))
    let nav = UINavigationController(rootViewController: controller)
    nav.modalPresentationStyle = .fullScreen
    present(nav, animated: true, completion: nil)
  }

  func handleFetchUser(withUsername username: String) {
    UserService.shared.fetchUser(withUsername: username) { user in
      print("Debug : user is \(user.username)")
      let controller = ProfileController(user: user)
      self.navigationController?.pushViewController(controller, animated: true)
    }
  }
}
