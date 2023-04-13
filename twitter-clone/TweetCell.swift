//
//  TweetCell.swift
//  twitter-clone
//
//  Created by Gilang Aditya Rahman on 14/04/23.
//

import UIKit

class TweetCell: UICollectionViewCell {
  // MARK: - Properties

  var tweet: Tweet? {
    didSet { configureData() }
  }

  private let profileImageView: UIImageView = {
    let iv = UIImageView()
    iv.contentMode = .scaleAspectFit
    iv.clipsToBounds = true
    iv.setDimensions(width: 48, height: 48)
    iv.layer.cornerRadius = 48 / 2
    iv.backgroundColor = .twitterBlue

    return iv
  }()

  private let captionLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 14)
    label.numberOfLines = 0
    label.text = "Some text option"

    return label
  }()

  private let infoLabel = UILabel()

  private lazy var commentButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(UIImage(named: "comment"), for: .normal)
    button.tintColor = .darkGray
    button.setDimensions(width: 20, height: 20)
    button.addTarget(self, action: #selector(handleCommentTapped), for: .touchUpInside)

    return button
  }()

  private lazy var retweetButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(UIImage(named: "retweet"), for: .normal)
    button.tintColor = .darkGray
    button.setDimensions(width: 20, height: 20)
    button.addTarget(self, action: #selector(handleRetweetTapped), for: .touchUpInside)

    return button
  }()

  private lazy var likeButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(UIImage(named: "like"), for: .normal)
    button.tintColor = .darkGray
    button.setDimensions(width: 20, height: 20)
    button.addTarget(self, action: #selector(handleLikeTapped), for: .touchUpInside)

    return button
  }()

  private lazy var shareButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(UIImage(named: "share"), for: .normal)
    button.tintColor = .darkGray
    button.setDimensions(width: 20, height: 20)
    button.addTarget(self, action: #selector(handleShareTapped), for: .touchUpInside)

    return button
  }()

  // MARK: - Lifecycle

  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .white
    configure()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Selectors

  @objc func handleCommentTapped() {}

  @objc func handleRetweetTapped() {}

  @objc func handleLikeTapped() {}

  @objc func handleShareTapped() {}

  // MARK: - Helpers

  func configure() {
    addSubview(profileImageView)
    profileImageView.anchor(top: topAnchor, left: leftAnchor, paddingTop: 15, paddingLeft: 8)

    let stack = UIStackView(arrangedSubviews: [infoLabel, captionLabel])
    stack.axis = .vertical
    stack.distribution = .fillProportionally
    stack.spacing = 4
    addSubview(stack)
    stack.anchor(top: profileImageView.topAnchor, left: profileImageView.rightAnchor, right: rightAnchor, paddingLeft: 12, paddingRight: 12)

    infoLabel.font = UIFont.systemFont(ofSize: 14)
    infoLabel.text = "Eddie Brock @venom"

    let actionStack = UIStackView(arrangedSubviews: [commentButton, retweetButton, likeButton, shareButton])
    actionStack.axis = .horizontal
    actionStack.spacing = 72
    // actionStack.distribution = .equalSpacing

    addSubview(actionStack)
    actionStack.centerX(inView: self)
    actionStack.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingLeft: 50, paddingBottom: 8, paddingRight: 50)

    let underlineView = UIView()
    underlineView.backgroundColor = .systemGroupedBackground
    addSubview(underlineView)
    underlineView.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, height: 1)
  }

  func configureData() {
    guard let tweet = tweet else { return }
    let viewModel = TweetViewModel(tweet: tweet)

    captionLabel.text = tweet.caption
    profileImageView.sd_setImage(with: viewModel.profileImageUrl)
    infoLabel.attributedText = viewModel.userInfoText
  }
}
