//
//  EditProfileHeader.swift
//  twitter-clone
//
//  Created by Gilang Aditya Rahman on 27/04/23.
//

import UIKit

protocol EditProfileHeaderDelegate: AnyObject {
  func didTapChangeProfilePhoto()
}

class EditProfileHeader: UIView {
  weak var delegate: EditProfileHeaderDelegate?
  private var user: User
  let profileImageView: UIImageView = {
    let iv = UIImageView()
    iv.contentMode = .scaleAspectFill
    iv.clipsToBounds = true
    iv.backgroundColor = .lightGray
    iv.layer.borderColor = UIColor.white.cgColor
    iv.layer.borderWidth = 3.0

    return iv
  }()

  private lazy var changePhotoButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Change profile photo", for: .normal)
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
    button.setTitleColor(.white, for: .normal)
    button.addTarget(self, action: #selector(handleChangeProfilePhoto), for: .touchUpInside)

    return button
  }()

  init(user: User) {
    self.user = user
    super.init(frame: .zero)

    backgroundColor = .twitterBlue
    addSubview(profileImageView)
    profileImageView.center(inView: self, yConstant: -16)
    profileImageView.setDimensions(width: 100, height: 100)
    profileImageView.layer.cornerRadius = 100 / 2

    addSubview(changePhotoButton)
    changePhotoButton.centerX(inView: self, topAnchor: profileImageView.bottomAnchor, paddingTop: 8)
    profileImageView.sd_setImage(with: user.profileImageUrl)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Selectors

  @objc func handleChangeProfilePhoto() {
    delegate?.didTapChangeProfilePhoto()
  }
}
