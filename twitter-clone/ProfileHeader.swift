//
//  ProfileHeader.swift
//  twitter-clone
//
//  Created by Gilang Aditya Rahman on 16/04/23.
//

import Foundation
import UIKit

protocol ProfileHeaderDelegate: AnyObject {
  func handleDismissal()
  func handleEditProfileFollow(_ header: ProfileHeader)
  func didSelect(filter: ProfileFilterOptions)
}

class ProfileHeader: UICollectionReusableView {
  weak var delegate: ProfileHeaderDelegate?

  var user: User? {
    didSet { configure() }
  }

  private lazy var backButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(UIImage(named: "arrow_back")?.withRenderingMode(.alwaysOriginal), for: .normal)
    button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)

    return button
  }()

  private lazy var containerView: UIView = {
    let view = UIView()
    view.backgroundColor = .twitterBlue
    view.addSubview(backButton)
    backButton.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 42, paddingLeft: 16)
    backButton.setDimensions(width: 30, height: 30)

    return view
  }()

  private lazy var profileImageView: UIImageView = {
    let iv = UIImageView()
    iv.contentMode = .scaleAspectFit
    iv.clipsToBounds = true
    iv.backgroundColor = .lightGray
    iv.layer.borderColor = UIColor.white.cgColor
    iv.layer.borderWidth = 4

    return iv
  }()

  lazy var editProfileFollowButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Loading", for: .normal)
    button.layer.borderColor = UIColor.twitterBlue.cgColor
    button.layer.borderWidth = 1.25
    button.setTitleColor(.twitterBlue, for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
    button.addTarget(self, action: #selector(handleEditProfileFollow), for: .touchUpInside)

    return button
  }()

  private lazy var fullnameLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.boldSystemFont(ofSize: 20)

    return label
  }()

  private lazy var usernameLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 16)
    label.textColor = .lightGray
    return label
  }()

  private let bioLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 16)
    label.numberOfLines = 3
    label.text = "This is a bio user"

    return label
  }()

  private let filterBar = ProfileFilterView()

  

  private let underlineViewGray: UIView = {
    let view = UIView()
    view.backgroundColor = .lightGray
    return view

  }()

  private lazy var followingLabel: UILabel = {
    let label = UILabel()
    let followTap = UITapGestureRecognizer(target: self, action: #selector(handleFollowingTapped))
    label.addGestureRecognizer(followTap)
    label.isUserInteractionEnabled = true

    return label
  }()

  private lazy var followersLabel: UILabel = {
    let label = UILabel()
    let followTap = UITapGestureRecognizer(target: self, action: #selector(handleFollowersTapped))
    label.addGestureRecognizer(followTap)
    label.isUserInteractionEnabled = true

    return label
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)

    filterBar.delegate = self

    addSubview(containerView)
    containerView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, height: 108)

    addSubview(profileImageView)
    profileImageView.anchor(top: containerView.bottomAnchor, left: leftAnchor, paddingTop: -24, paddingLeft: 8)
    profileImageView.setDimensions(width: 80, height: 80)
    profileImageView.layer.cornerRadius = 80 / 2

    addSubview(editProfileFollowButton)
    editProfileFollowButton.anchor(top: containerView.bottomAnchor, right: rightAnchor,
                                   paddingTop: 12, paddingRight: 12)
    editProfileFollowButton.setDimensions(width: 100, height: 36)
    editProfileFollowButton.layer.cornerRadius = 36 / 2

    let userDetailStack = UIStackView(arrangedSubviews: [fullnameLabel, usernameLabel, bioLabel])
    userDetailStack.axis = .vertical
    userDetailStack.spacing = 4
    userDetailStack.distribution = .fillProportionally

    addSubview(userDetailStack)
    userDetailStack.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 12, paddingRight: 12)

    let followStack = UIStackView(arrangedSubviews: [followingLabel, followersLabel])
    followStack.axis = .horizontal
    followStack.spacing = 8
    followStack.distribution = .fillEqually

    addSubview(followStack)
    followStack.anchor(top: userDetailStack.bottomAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 12)

    addSubview(filterBar)
    filterBar.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, height: 50)

    addSubview(underlineViewGray)
    underlineViewGray.anchor(left: leftAnchor, bottom: bottomAnchor, width: frame.width, height: 0.5)

    
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Selectors

  @objc func handleDismissal() {
    delegate?.handleDismissal()
  }

  @objc func handleEditProfileFollow() {
    delegate?.handleEditProfileFollow(self)
  }

  @objc func handleFollowersTapped() {}

  @objc func handleFollowingTapped() {}

  func configure() {
    guard let user = user else { return }
    let viewModel = ProfileHeaderViewModel(user: user)
    followingLabel.attributedText = viewModel.followingString
    followersLabel.attributedText = viewModel.followersString
    profileImageView.sd_setImage(with: user.profileImageUrl)
    editProfileFollowButton.setTitle(viewModel.actionButtonTitle, for: .normal)
    fullnameLabel.text = user.fullname
    usernameLabel.text = viewModel.usernameText
  }
}

extension ProfileHeader: ProfileFilterViewDelegate {
  func filterView(_ view: ProfileFilterView, didSelect index: Int) {
    guard let filter = ProfileFilterOptions(rawValue: index) else { return }
    delegate?.didSelect(filter: filter)
  }
}
