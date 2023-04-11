//
//  ExploreController.swift
//  twitter-clone
//
//  Created by Gilang Aditya Rahman on 11/04/23.
//

import UIKit

class ExploreController: UIViewController {
  // MARK: - Properties

  // MARK: - Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
  }

  // MARK: - Helpers

  func configureUI() {
    view.backgroundColor = .white

    navigationItem.title = "Explore"
  }

  func configureViewController() {}
}
