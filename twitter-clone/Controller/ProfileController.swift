//
//  ProfileController.swift
//  twitter-clone
//
//  Created by Gilang Aditya Rahman on 14/04/23.
//

import Foundation
import UIKit

private let withReuseIdentifier = "TweetCell"
private let headerIdentifier = "ProfileHeader"

class ProfileController: UICollectionViewController {
  // MARK: - Properties

  private let user: User

  private var tweets = [Tweet]() {
    didSet { collectionView.reloadData() }
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
    configureUI()
    fetchTweets()
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
    }
  }

  // MARK: - HELPERS

  func configureUI() {
    collectionView.register(TweetCell.self, forCellWithReuseIdentifier: withReuseIdentifier)
    collectionView.contentInsetAdjustmentBehavior = .never
    collectionView.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                            withReuseIdentifier: headerIdentifier)
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
}

extension ProfileController {
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return tweets.count
  }

  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: withReuseIdentifier, for: indexPath) as! TweetCell
    cell.tweet = tweets[indexPath.row]
    cell.delegate = self

    return cell
  }
}

extension ProfileController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    return CGSize(width: view.frame.width, height: 350)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: view.frame.width, height: 120)
  }
}

extension ProfileController: ProfileHeaderDelegate {
  func handleDismissal() {
    navigationController?.popViewController(animated: true)
  }
}

extension ProfileController: TweetCellDelegate {
  func handleProfileImageTapped(_ cell: TweetCell) {
    guard let user = cell.tweet?.user else { return }
    let viewController = ProfileController(user: user)
    navigationController?.pushViewController(viewController, animated: true)
  }
}
