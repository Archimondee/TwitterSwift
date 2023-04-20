//
//  ProfileFilterCell.swift
//  twitter-clone
//
//  Created by Gilang Aditya Rahman on 16/04/23.
//

import UIKit

class ProfileFilterCell: UICollectionViewCell {
  // MARK: - Properties
  var option: ProfileFilterOptions! {
    didSet { titleLabel.text = option.descriptions }
  }
  
  let titleLabel: UILabel = {
    let label = UILabel()
    label.textColor = .lightGray
    label.font = UIFont.systemFont(ofSize: 14)
    label.text = "Testing"

    return label
  }()

  override var isSelected: Bool {
    didSet {
      titleLabel.font = isSelected ? UIFont.boldSystemFont(ofSize: 16) : UIFont.systemFont(ofSize: 14)
      titleLabel.textColor = isSelected ? .twitterBlue : .lightGray
    }
  }

  override init(frame: CGRect) {
    super.init(frame: frame)

    addSubview(titleLabel)
    titleLabel.center(inView: self)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
