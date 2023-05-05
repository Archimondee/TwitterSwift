//
//  NotificationCell.swift
//  twitter-clone
//
//  Created by Gilang Aditya Rahman on 24/04/23.
//

import UIKit

protocol NotificationCellDelegate: AnyObject {
  func handleProfileImageTapped(_ cell: NotificationCell)
  func didTapFollow(_ cell: NotificationCell)
}

class NotificationCell: UITableViewCell {
  var notification: Notification? {
    didSet { configure() }
  }

  weak var delegate: NotificationCellDelegate?

  private lazy var profileImageView: UIImageView = {
    let iv = UIImageView()
    iv.contentMode = .scaleAspectFit
    iv.clipsToBounds = true
    iv.setDimensions(width: 40, height: 40)
    iv.layer.cornerRadius = 40 / 2
    iv.backgroundColor = .twitterBlue

    let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTapped))

    iv.isUserInteractionEnabled = true
    iv.addGestureRecognizer(tap)

    return iv
  }()

  let notificationLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 2
    label.font = UIFont.systemFont(ofSize: 14)
    label.text = "Some test notifications"
    return label
  }()

  private lazy var followButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Loading", for: .normal)
    button.backgroundColor = .white
    button.setTitleColor(.twitterBlue, for: .normal)
    button.layer.borderColor = UIColor.twitterBlue.cgColor
    button.layer.borderWidth = 2
    button.addTarget(self, action: #selector(handleFollowTapped), for: .touchUpInside)

    return button
  }()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    selectionStyle = .none
    configureUI()
    profileImageView.isUserInteractionEnabled = true
  }

  func configureUI() {
    let stack = UIStackView(arrangedSubviews: [profileImageView, notificationLabel])

    stack.spacing = 8
    stack.alignment = .center

    contentView.addSubview(stack)
    stack.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12)
    stack.anchor(right: rightAnchor, paddingRight: 12)
    contentView.addSubview(followButton)
    followButton.centerY(inView: self)
    followButton.setDimensions(width: 92, height: 32)
    followButton.layer.cornerRadius = 32 / 2
    followButton.anchor(right: rightAnchor, paddingRight: 12)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  @objc func handleProfileImageTapped() {
    delegate?.handleProfileImageTapped(self)
  }

  @objc func handleFollowTapped() {
    delegate?.didTapFollow(self)
  }

  // MARK: - Helpers

  func configure() {
    guard let notification = notification else { return }

    let viewModel = NotificationViewModel(notification: notification)
    profileImageView.sd_setImage(with: viewModel.profileImageUrl)

    notificationLabel.attributedText = viewModel.notificationText
    followButton.isHidden = viewModel.shouldHideFollowButton
    followButton.setTitle(viewModel.followButtonText, for: .normal)
  }
}
