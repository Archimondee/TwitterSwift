//
//  UploadTweetController.swift
//  twitter-clone
//
//  Created by Gilang Aditya Rahman on 13/04/23.
//

import UIKit

class UploadTweetController: UIViewController {
  // MARK: - Properties

  private let user: User

  private lazy var actionButton: UIButton = {
    let button = UIButton(type: .system)
    button.backgroundColor = .twitterBlue
    button.setTitle("Tweet", for: .normal)
    button.titleLabel?.textAlignment = .center
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
    button.setTitleColor(.white, for: .normal)
    
    button.frame = CGRect(x: 0, y: 0, width: 64, height: 32)
    button.layer.cornerRadius = 32 / 2
    button.layer.masksToBounds = true
    button.addTarget(self, action: #selector(handleUploadTweet), for: .touchUpInside)
    
    return button
  }()
  
  private let profileImageView: UIImageView = {
    let iv = UIImageView()
    iv.contentMode = .scaleAspectFit
    iv.clipsToBounds = true
    iv.setDimensions(width: 48, height: 48)
    iv.layer.cornerRadius = 48 / 2
    iv.backgroundColor = .twitterBlue
        
    return iv
  }()
  
  private let captionTextView = CaptionTextView()
  
  // MARK: - Lifecycles

  init(user: User) {
    self.user = user
    super.init(nibName: nil, bundle: nil)
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
  }
  
  // MARK: - Selectors

  @objc func handleCancel() {
    dismiss(animated: true, completion: nil)
  }
  
  @objc func handleUploadTweet() {
    guard let caption = captionTextView.text else { return }
    TweetService.shared.uploadTweet(caption: caption) { error, _ in
      if let error = error {
        print("DebugError: \(error.localizedDescription)")
      }
      
      self.dismiss(animated: true, completion: nil)
    }
  }
  
  // MARK: - API
  
  // MARK: - Helpers
  
  func configureUI() {
    view.backgroundColor = .white
    configureNavigationBar()
//    let stack = UIStackView(arrangedSubviews: [profileImageView, captionTextView])
//
//    stack.axis = .horizontal
//    stack.spacing = 12
//    view.addSubview(stack)
//    stack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingRight: 16)
    profileImageView.sd_setImage(with: user.profileImageUrl, completed: nil)
    view.addSubview(profileImageView)
    view.addSubview(captionTextView)
    profileImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 16, paddingLeft: 16)
    captionTextView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: profileImageView.rightAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 16, paddingLeft: 12, paddingRight: 16, height: 100)
  }
  
  func configureNavigationBar() {
    navigationController?.navigationBar.barTintColor = .white
    let appearance = UINavigationBarAppearance()
    appearance.configureWithOpaqueBackground()
    // nav.navigationBar.standardAppearance = appearance
    navigationController?.navigationBar.scrollEdgeAppearance = appearance
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
    navigationItem.rightBarButtonItem = UIBarButtonItem(customView: actionButton)
  }
}
