//
//  EditProfileFooter.swift
//  twitter-clone
//
//  Created by Gilang Aditya Rahman on 06/05/23.
//

import Foundation
import UIKit

protocol EditProfileFooterDelegate: AnyObject {
  func handleLogout()
}

class EditProfileFooter: UIView {
  private lazy var logoutButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Logout", for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
    button.backgroundColor = .red
    button.layer.cornerRadius = 5
    button.layer.masksToBounds = true
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
    
    return button
  }()
  
  weak var delegate: EditProfileFooterDelegate?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    addSubview(logoutButton)
    logoutButton.anchor(left: leftAnchor, right: rightAnchor, paddingLeft: 16, paddingRight: 16)
    logoutButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    logoutButton.centerY(inView: self)
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  @objc func handleLogout() {
    delegate?.handleLogout()
  }
}
