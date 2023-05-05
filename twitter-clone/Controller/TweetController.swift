//
//  TweetController.swift
//  twitter-clone
//
//  Created by Gilang Aditya Rahman on 20/04/23.
//

import UIKit
private let headerIdentifier = "TweetHeader"
private let reuseIdentifier = "TweetCell"

class TweetController: UICollectionViewController {
  // MARK: - Properties

  private var tweet: Tweet
  private var actionSheetLauncher: ActionSheetLauncher!
  private var replies = [Tweet]() {
    didSet {
      collectionView.reloadData()
    }
  }

  init(tweet: Tweet) {
    self.tweet = tweet

    super.init(collectionViewLayout: UICollectionViewFlowLayout())
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    configureCollectionView()
    fetchReplies()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    navigationController?.navigationBar.barStyle = .default
    navigationController?.isNavigationBarHidden = false
  }

  // MARK: - API

  func fetchReplies() {
    TweetService.shared.fetchReplies(forTweet: tweet) { replies in
      self.replies = replies
    }
  }

  // MARK: - Helpers

  func configureCollectionView() {
    collectionView.backgroundColor = .white
    collectionView.showsVerticalScrollIndicator = false
    collectionView.register(TweetHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
    collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reuseIdentifier)
  }
}

// MARK: - UICollectionViewDataSource

extension TweetController {
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return replies.count
  }

  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TweetCell
    cell.tweet = replies[indexPath.row]
    return cell
  }
}

// MARK: - UICollectionViewDelegate

extension TweetController {
  override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String,
                               at indexPath: IndexPath) -> UICollectionReusableView
  {
    let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! TweetHeader
    header.tweet = tweet
    header.delegate = self
    return header
  }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension TweetController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    let viewModel = TweetViewModel(tweet: tweet)
    let height = viewModel.size(forWidth: view.frame.width).height
    return CGSize(width: view.frame.width, height: height + 240)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: view.frame.width, height: 120)
  }
}

extension TweetController: TweetHeaderDelegate {
  func showActionSheet() {
    if tweet.user.isCurrentUser {
      actionSheetLauncher = ActionSheetLauncher(user: tweet.user)
      actionSheetLauncher.delegate = self

      actionSheetLauncher.show()
    } else {
      UserService.shared.checkIfUserIsFollowed(uid: tweet.user.uid) { isFollowed in
        var user = self.tweet.user
        user.isFollowed = isFollowed
        self.actionSheetLauncher = ActionSheetLauncher(user: user)
        self.actionSheetLauncher.delegate = self
        self.actionSheetLauncher.show()
      }
    }
  }

  func handleFetchUser(withUsername username: String) {
    UserService.shared.fetchUser(withUsername: username) { user in
      print("Debug : user is \(user.username)")
      let controller = ProfileController(user: user)
      self.navigationController?.pushViewController(controller, animated: true)
    }
  }
}

extension TweetController: ActionSheetLauncherDelegate {
  func didSelect(option: ActionSheetOptions) {
    switch option {
    case .follow(let user):
      UserService.shared.followUser(uid: user.uid) { _, _ in
        print("Follow user \(user.username)")
      }
    case .unfollow(let user):
      UserService.shared.unfollowUser(uid: user.uid) { _, _ in
        print("Unfollow user \(user.username)")
      }
    case .report:
      print("Report tweet")
    case .delete:
      print("Delete tweet")
    }
  }
}
