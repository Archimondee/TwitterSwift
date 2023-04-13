//
//  CaptionTextView.swift
//  twitter-clone
//
//  Created by Gilang Aditya Rahman on 13/04/23.
//

import UIKit

class CaptionTextView: UITextView {
  let placeholderLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 16)
    label.textColor = .darkGray
    label.text = "Whats happening ?"

    return label
  }()

  override init(frame: CGRect, textContainer: NSTextContainer?) {
    super.init(frame: frame, textContainer: textContainer)
    backgroundColor = .white
    font = UIFont.systemFont(ofSize: 16)
    //isScrollEnabled = false
    layer.borderColor = UIColor.darkGray.cgColor
    layer.borderWidth = 0.5
    layer.cornerRadius = 10
    layer.masksToBounds = true
    sizeToFit()
    translatesAutoresizingMaskIntoConstraints = false
    heightAnchor.constraint(equalToConstant: 300).isActive = true

    addSubview(placeholderLabel)
    placeholderLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 4)
    NotificationCenter.default.addObserver(self, selector: #selector(handleTextInputChange),
                                           name: UITextView.textDidChangeNotification, object: nil)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  @objc func handleTextInputChange() {
    if text.isEmpty {
      placeholderLabel.isHidden = false
    } else {
      placeholderLabel.isHidden = true
    }
    // placeholderLabel.isHidden = !text.isEmpty
  }
}
