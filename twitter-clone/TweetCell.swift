//
//  TweetCell.swift
//  twitter-clone
//
//  Created by Gilang Aditya Rahman on 14/04/23.
//

import ActiveLabel
import UIKit

protocol TweetCellDelegate: AnyObject {
  func handleProfileImageTapped(_ cell: TweetCell)
  func handleReplyTapped(_ cell: TweetCell)
  func handleLikeTapped(_ cell: TweetCell)
  func handleFetchUser(withUsername username: String)
}

class TweetCell: UICollectionViewCell {
  // MARK: - Properties

  var tweet: Tweet? {
    didSet { configureData() }
  }

  weak var delegate: TweetCellDelegate?

  private lazy var profileImageView: UIImageView = {
    let iv = UIImageView()
    iv.contentMode = .scaleAspectFit
    iv.clipsToBounds = true
    iv.setDimensions(width: 48, height: 48)
    iv.layer.cornerRadius = 48 / 2
    iv.backgroundColor = .twitterBlue

    let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTapped))

    iv.isUserInteractionEnabled = true
    iv.addGestureRecognizer(tap)

    return iv
  }()

  private let replyLabel: UILabel = {
    let label = UILabel()
    label.textColor = .lightGray
    label.font = UIFont.systemFont(ofSize: 12)

    return label
  }()

  private let captionLabel: ActiveLabel = {
    let label = ActiveLabel()
    label.mentionColor = .twitterBlue
    label.font = UIFont.systemFont(ofSize: 14)
    label.numberOfLines = 0
    label.text = "Some text option"

    return label
  }()

  private let infoLabel = UILabel()

  private lazy var commentButton: UIButton = {
    let button = createButton(withImageName: "comment")
    button.addTarget(self, action: #selector(handleCommentTapped), for: .touchUpInside)
    return button
  }()
  
  private lazy var retweetButton: UIButton = {
    let button = createButton(withImageName: "retweet")
    button.addTarget(self, action: #selector(handleRetweetTapped), for: .touchUpInside)
    return button
  }()
  
  private lazy var likeButton: UIButton = {
    let button = createButton(withImageName: "like")
    button.addTarget(self, action: #selector(handleLikeTapped), for: .touchUpInside)
    return button
  }()
  
  private lazy var shareButton: UIButton = {
    let button = createButton(withImageName: "share")
    button.addTarget(self, action: #selector(handleShareTapped), for: .touchUpInside)
    return button
  }()

  // MARK: - Lifecycle

  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .white
    configure()
    profileImageView.isUserInteractionEnabled = true
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Selectors

  @objc func handleCommentTapped() {
    delegate?.handleReplyTapped(self)
  }

  @objc func handleRetweetTapped() {}

  @objc func handleLikeTapped() {
    delegate?.handleLikeTapped(self)
  }

  @objc func handleShareTapped() {}

  @objc func handleProfileImageTapped() {
    delegate?.handleProfileImageTapped(self)
  }

  // MARK: - Helpers

  func configure() {
//    addSubview(profileImageView)
//    profileImageView.anchor(top: topAnchor, left: leftAnchor, paddingTop: 15, paddingLeft: 8)

    let captionStack = UIStackView(arrangedSubviews: [infoLabel, captionLabel])
    captionStack.axis = .vertical
    captionStack.distribution = .fillProportionally
    captionStack.spacing = 4

    let imageCaptionStack = UIStackView(arrangedSubviews: [profileImageView, captionStack])
    imageCaptionStack.distribution = .fillProportionally
    imageCaptionStack.spacing = 12
    imageCaptionStack.alignment = .leading

    let stack = UIStackView(arrangedSubviews: [replyLabel, imageCaptionStack])
    stack.axis = .vertical
    stack.spacing = 8
    stack.distribution = .fillProportionally
    addSubview(stack)
    stack.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 12, paddingLeft: 12, paddingBottom: 12, paddingRight: 12)

    infoLabel.font = UIFont.systemFont(ofSize: 14)

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

    configureMentionHandler()
  }

  func configureData() {
    guard let tweet = tweet else { return }
    let viewModel = TweetViewModel(tweet: tweet)

    captionLabel.text = tweet.caption
    profileImageView.sd_setImage(with: viewModel.profileImageUrl)
    infoLabel.attributedText = viewModel.userInfoText
    likeButton.setImage(viewModel.likeButtonImage, for: .normal)
    likeButton.tintColor = viewModel.liketButtonTintColor
    replyLabel.isHidden = viewModel.shouldHideReplyLabel
    replyLabel.text = viewModel.replyText
  }

  func configureMentionHandler() {
    captionLabel.handleMentionTap { caption in
      self.delegate?.handleFetchUser(withUsername: caption)
    }
  }
  
  func createButton(withImageName imageName: String) -> UIButton {
    let button = UIButton(type: .system)
    button.setImage(UIImage(named: imageName), for: .normal)
    button.tintColor = .darkGray
    button.setDimensions(width: 20, height: 20)
    return button
  }
}
