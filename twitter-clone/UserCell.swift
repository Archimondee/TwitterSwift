//
//  UserCell.swift
//  twitter-clone
//
//  Created by Gilang Aditya Rahman on 20/04/23.
//

import UIKit

class UserCell: UITableViewCell {
  // MARK: - Properties

  private lazy var profileImageView: UIImageView = {
    let iv = UIImageView()
    iv.contentMode = .scaleAspectFit
    iv.clipsToBounds = true
    iv.setDimensions(width: 32, height: 32)
    iv.layer.cornerRadius = 32 / 2
    iv.backgroundColor = .twitterBlue

    return iv
  }()

  private lazy var usernameLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.boldSystemFont(ofSize: 14)
    label.text = "Username"
    return label
  }()

  private lazy var fullnameLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 14)
    label.text = "Fullname"
    return label
  }()

  // MARK: - Lifecycle

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    addSubview(profileImageView)
    profileImageView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12)

    let stack = UIStackView(arrangedSubviews: [usernameLabel, fullnameLabel])
    stack.axis = .vertical
    stack.spacing = 2

    addSubview(stack)
    stack.centerY(inView: profileImageView, leftAnchor: profileImageView.rightAnchor, paddingLeft: 12)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
