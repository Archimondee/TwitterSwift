//
//  MainTabController.swift
//  twitter-clone
//
//  Created by Gilang Aditya Rahman on 11/04/23.
//

import UIKit

class MainTabController: UITabBarController {
  // MARK: - Properties

  let actionButton: UIButton = {
    let button = UIButton(type: .system)
    button.tintColor = .white
    button.setImage(UIImage(named: "new_tweet"), for: .normal)
    button.backgroundColor = .twitterBlue
    button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)

    return button
  }()

  // MARK: - Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()

    configureViewController()
    configureUI()
  }

  // MARK: - Selectors

  @objc func actionButtonTapped() {}

  // MARK: - Helpers

  func configureUI() {
    view.addSubview(actionButton)
    actionButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor,
                        paddingBottom: 64, paddingRight: 16, width: 56, height: 56)

    actionButton.layer.cornerRadius = 56 / 2
  }

  func configureViewController() {
    // tabBar.backgroundColor = .white
    let appearance = UITabBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = .systemBackground
    tabBar.standardAppearance = appearance
    tabBar.isTranslucent = true
    if #available(iOS 15.0, *) {
      tabBar.scrollEdgeAppearance = appearance
    } else {
      // Fallback on earlier versions
    }

    let feed = templateNavigationController(image: UIImage(named: "home_unselected"), rootViewController: FeedController())

    let explore = templateNavigationController(image: UIImage(named: "search_unselected"), rootViewController: ExploreController())

    let notifications = templateNavigationController(image: UIImage(named: "like_unselected"), rootViewController: NotificationsController())

    let conversations = templateNavigationController(image: UIImage(named: "mail"), rootViewController: ConversationsController())

    viewControllers = [feed, explore, notifications, conversations]
  }

  func templateNavigationController(image: UIImage?, rootViewController: UIViewController) -> UINavigationController {
    let nav = UINavigationController(rootViewController: rootViewController)
    nav.tabBarItem.image = image
    let appearance = UINavigationBarAppearance()
    appearance.configureWithOpaqueBackground()
    nav.navigationBar.standardAppearance = appearance
    nav.navigationBar.scrollEdgeAppearance = appearance

    return nav
  }
}
