//
//  MainTabController.swift
//  twitter-clone
//
//  Created by Gilang Aditya Rahman on 11/04/23.
//

import Firebase
import UIKit

enum ActionButtonConfiguration {
  case tweet
  case message
}

class MainTabController: UITabBarController {
  // MARK: - Properties

  private var buttonConfig: ActionButtonConfiguration = .tweet

  var user: User? {
    didSet {
      guard let nav = viewControllers?.first as? UINavigationController else { return }
      guard let feed = nav.viewControllers.first as? FeedController else { return }

      feed.user = user
    }
  }

  lazy var actionButton: UIButton = {
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
    view.backgroundColor = .twitterBlue
    // logUserOut()
    authenticateUserAndConfigureUI()
  }

//  override func viewDidAppear(_ animated: Bool) {
//    super.viewDidAppear(animated)
//    authenticateUserAndConfigureUI()
//  }

  // MARK: - API

  func fetchUser() {
    guard let uid = Auth.auth().currentUser?.uid else { return }
    UserService.shared.fetchUser(uid: uid) { user in
      self.user = user
    }
  }

  func authenticateUserAndConfigureUI() {
    if Auth.auth().currentUser == nil {
      DispatchQueue.main.async {
        let nav = UINavigationController(rootViewController: LoginController())
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
      }
    } else {
      configureViewController()
      configureUI()
      fetchUser()
    }
  }

  func logUserOut() {
    do {
      try Auth.auth().signOut()
    } catch {
      print("ERROR: \(error.localizedDescription)")
    }
  }

  // MARK: - Selectors

  @objc func actionButtonTapped() {
    let controller: UIViewController

    switch buttonConfig {
    case .tweet:
      guard let user = user else { return }
      controller = UploadTweetController(user: user, config: .tweet)
    case .message:
      controller = ExploreController()
    }
    guard let user = user else { return }
    let nav = UINavigationController(rootViewController: controller)
    nav.modalPresentationStyle = .fullScreen
    present(nav, animated: true, completion: nil)
  }

  // MARK: - Helpers

  func configureUI() {
    view.addSubview(actionButton)
    actionButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor,
                        paddingBottom: 64, paddingRight: 16, width: 56, height: 56)

    actionButton.layer.cornerRadius = 56 / 2
    delegate = self
  }

  func configureViewController() {
    // tabBar.backgroundColor = .white
    let appearance = UITabBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = .systemBackground
    // tabBar.standardAppearance = appearance
    // tabBar.isTranslucent = true
    if #available(iOS 15.0, *) {
      tabBar.scrollEdgeAppearance = appearance
    } else {
      // Fallback on earlier versions
    }

    let feed = templateNavigationController(image: UIImage(named: "home_unselected"),
                                            rootViewController: FeedController(collectionViewLayout: UICollectionViewFlowLayout()))

    let explore = templateNavigationController(image: UIImage(named: "search_unselected"), rootViewController: ExploreController())

    let notifications = templateNavigationController(image: UIImage(named: "like_unselected"), rootViewController: NotificationsController())

    let conversations = templateNavigationController(image: UIImage(named: "mail"), rootViewController: ConversationsController())

    viewControllers = [feed, explore, notifications, conversations]
  }

  func templateNavigationController(image: UIImage?, rootViewController: UIViewController) -> UINavigationController {
    let nav = UINavigationController(rootViewController: rootViewController)
    nav.tabBarItem.image = image
    let appearance = UINavigationBarAppearance()
    // appearance.configureWithOpaqueBackground()
    // nav.navigationBar.standardAppearance = appearance
    nav.navigationBar.backgroundColor = .white
    nav.navigationBar.scrollEdgeAppearance = appearance

    return nav
  }
}

extension MainTabController: UITabBarControllerDelegate {
  func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
    let index = viewControllers?.firstIndex(of: viewController)
    let imageName = index == 3 ? "mail" : "new_tweet"
    actionButton.setImage(UIImage(named: imageName), for: .normal)
    buttonConfig = index == 3 ? .message : .tweet
    if index == 3 {
    } else {}
  }
}
