//
//  EditProfileCell.swift
//  twitter-clone
//
//  Created by Gilang Aditya Rahman on 27/04/23.
//

import UIKit

protocol EditProfileCellDelegate: AnyObject {
  func updateUserInfo(_ cell: EditProfileCell)
}

class EditProfileCell: UITableViewCell {
  // MARK: - Properties

  var viewModel: EditProfileViewModel? {
    didSet { configure() }
  }

  weak var delegate: EditProfileCellDelegate?

  let titleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 14)
    label.text = "Test title"
    return label
  }()

  lazy var infoTextField: UITextField = {
    let tf = UITextField()
    tf.borderStyle = .none
    tf.font = UIFont.systemFont(ofSize: 14)
    tf.textAlignment = .left
    tf.textColor = .twitterBlue
    tf.addTarget(self, action: #selector(handleUpdateUserInfo), for: .editingDidEnd)
    tf.text = "Test user"
    return tf
  }()

  let biotTextView: InputTextView = {
    let tv = InputTextView()
    tv.font = UIFont.systemFont(ofSize: 14)
    tv.textColor = .twitterBlue
    tv.placeholderLabel.text = "Bio"

    return tv
  }()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    selectionStyle = .none

    contentView.addSubview(titleLabel)
    titleLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
    titleLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 12, paddingLeft: 16)

    contentView.addSubview(infoTextField)
    infoTextField.anchor(top: topAnchor, left: titleLabel.rightAnchor,
                         bottom: bottomAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 16, paddingRight: 8)

    contentView.addSubview(biotTextView)
    biotTextView.anchor(top: topAnchor, left: titleLabel.rightAnchor,
                        bottom: bottomAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 16, paddingRight: 8)
    NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateUserInfo),
                                           name: UITextView.textDidEndEditingNotification, object: nil)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Selectors

  @objc func handleUpdateUserInfo() {
    delegate?.updateUserInfo(self)
  }

  func configure() {
    guard let viewModel = viewModel else { return }

    infoTextField.isHidden = viewModel.shouldHideTextField
    biotTextView.isHidden = viewModel.shoulHideTextView
    titleLabel.text = viewModel.titleText
    biotTextView.text = viewModel.optionValue
    infoTextField.text = viewModel.optionValue
    biotTextView.placeholderLabel.isHidden = viewModel.shouldHidePlaceholderLabel
  }
}
