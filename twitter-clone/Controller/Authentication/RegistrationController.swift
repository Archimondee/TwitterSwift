//
//  RegisterController.swift
//  twitter-clone
//
//  Created by Gilang Aditya Rahman on 11/04/23.
//

import UIKit

class RegistrationController: UIViewController {
  // MARK: - Properties

  private let alreadyHaveAccountButton: UIButton = {
    let button = Utilities().attributedButton("Already have an account?", " Login")
    button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)

    return button
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
  }

  // MARK: - Lifecycle

  // MARK: - Selectors

  @objc func handleShowLogin() {
    navigationController?.popViewController(animated: true)
  }

  // MARK: - Helpers

  func configureUI() {
    view.backgroundColor = .twitterBlue

    view.addSubview(alreadyHaveAccountButton)
    alreadyHaveAccountButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 40, paddingRight: 40)
  }
}
