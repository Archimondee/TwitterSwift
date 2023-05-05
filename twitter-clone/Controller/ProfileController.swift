//
//  ProfileController.swift
//  twitter-clone
//
//  Created by Gilang Aditya Rahman on 14/04/23.
//

import Firebase
import Foundation
import UIKit

private let withReuseIdentifier = "TweetCell"
private let headerIdentifier = "ProfileHeader"

class ProfileController: UICollectionViewController {
  // MARK: - Properties

  public var user: User

  private var selectedFilter: ProfileFilterOptions = .tweets {
    didSet {
      collectionView.reloadData()
    }
  }

  private var tweets = [Tweet]()
  private var likedTweets = [Tweet]()
  private var replies = [Tweet]()

  private var currentDataSource: [Tweet] {
    switch selectedFilter {
    case .tweets: return tweets
    case .replies: return replies
    case .likes: return likedTweets
    }
  }

  // MARK: - Lifecycle

  init(user: User) {
    self.user = user
    super.init(collectionViewLayout: UICollectionViewFlowLayout())
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.backgroundColor = .white
    collectionView.showsVerticalScrollIndicator = false
    configureUI()
    fetchTweets()
    fetchUserStats()
    fetchLikedTweets()
    fetchReplies()
    checkIfUserIsFollowed()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    navigationController?.navigationBar.barStyle = .black
    navigationController?.isNavigationBarHidden = true
  }

  // MARK: - API

  func fetchTweets() {
    TweetService.shared.fetchTweets(forUser: user) { tweets in
      self.tweets = tweets
      self.collectionView.reloadData()
    }
  }

  func checkIfUserIsFollowed() {
    UserService.shared.checkIfUserIsFollowed(uid: user.uid) { isFollowed in
      self.user.isFollowed = isFollowed
      self.collectionView.reloadData()
    }
  }

  func fetchUserStats() {
    UserService.shared.fetchUserStats(uid: user.uid) { stats in
      self.user.stats = stats
      self.collectionView.reloadData()
    }
  }

  func fetchReplies() {
    TweetService.shared.fetchReplies(forUser: user) { tweets in
      self.replies = tweets
      self.replies.forEach { _ in
      }
    }
  }

  func fetchLikedTweets() {
    TweetService.shared.fetchLikes(forUser: user) { tweets in
      self.likedTweets = tweets
    }
  }

  // MARK: - HELPERS

  func configureUI() {
    collectionView.register(TweetCell.self, forCellWithReuseIdentifier: withReuseIdentifier)
    collectionView.contentInsetAdjustmentBehavior = .never
    collectionView.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                            withReuseIdentifier: headerIdentifier)
    collectionView.showsVerticalScrollIndicator = false

    guard let tabHeight = tabBarController?.tabBar.frame.height else { return }
    collectionView.contentInset.bottom = tabHeight + 20
  }
}

extension ProfileController {
  override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String,
                               at indexPath: IndexPath) -> UICollectionReusableView
  {
    let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! ProfileHeader
    header.user = user
    header.delegate = self
    return header
  }

  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let controller = TweetController(tweet: currentDataSource[indexPath.row])
    navigationController?.pushViewController(controller, animated: true)
  }
}

extension ProfileController {
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return currentDataSource.count
  }

  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: withReuseIdentifier, for: indexPath) as! TweetCell
    cell.tweet = currentDataSource[indexPath.row]
    cell.delegate = self

    return cell
  }
}

extension ProfileController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    var height: CGFloat = 300

    if user.bio != nil {
      height += 40
    }
    return CGSize(width: view.frame.width, height: height)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let viewModel = TweetViewModel(tweet: currentDataSource[indexPath.row])
    let height = viewModel.size(forWidth: view.frame.width).height
    return CGSize(width: view.frame.width, height: height + 90)
  }
}

extension ProfileController: ProfileHeaderDelegate {
  func didSelect(filter: ProfileFilterOptions) {
    selectedFilter = filter
  }

  func handleDismissal() {
    navigationController?.popViewController(animated: true)
  }
}

extension ProfileController: TweetCellDelegate {
  func handleLikeTapped(_ cell: TweetCell) {
    print("Hellooo")
  }

  func handleFetchUser(withUsername username: String) {
    print("helloo")
  }

  func handleReplyTapped(_ cell: TweetCell) {
    guard let tweet = cell.tweet else { return }
    let controller = UploadTweetController(user: tweet.user, config: .reply(tweet))
    let nav = UINavigationController(rootViewController: controller)
    nav.modalPresentationStyle = .fullScreen
    present(nav, animated: true, completion: nil)
  }

  func handleProfileImageTapped(_ cell: TweetCell) {
    guard let user = cell.tweet?.user else { return }
    let viewController = ProfileController(user: user)
    navigationController?.pushViewController(viewController, animated: true)
  }

  func handleEditProfileFollow(_ header: ProfileHeader) {
    if user.isCurrentUser {
      let controller = EditProfileController(user: user)
      controller.delegate = self
      let nav = UINavigationController(rootViewController: controller)
      nav.modalPresentationStyle = .fullScreen
      present(nav, animated: true, completion: nil)
      return
    }
    if user.isFollowed {
      UserService.shared.unfollowUser(uid: user.uid) { _, _ in
        self.user.isFollowed = false
        header.editProfileFollowButton.setTitle("Follow", for: .normal)
        self.collectionView.reloadData()
      }
    } else {
      UserService.shared.followUser(uid: user.uid) { _, _ in
        self.user.isFollowed = true
        header.editProfileFollowButton.setTitle("Following", for: .normal)
        self.collectionView.reloadData()

        NotificationService.shared.uploadNotification(toUser: self.user, type: .follow)
      }
    }
  }
}

extension ProfileController: EditProfileContollerDelegate {
  func handleLogout() {
    do {
      try Auth.auth().signOut()
      let nav = UINavigationController(rootViewController: LoginController())
      nav.modalPresentationStyle = .fullScreen
      present(nav, animated: true)
    } catch {
      print("ERROR: \(error.localizedDescription)")
    }
  }

  func controller(_ controller: EditProfileController, wantsToUpdate user: User) {
    controller.dismiss(animated: true, completion: nil)
    self.user = user
    collectionView.reloadData()
  }
}
