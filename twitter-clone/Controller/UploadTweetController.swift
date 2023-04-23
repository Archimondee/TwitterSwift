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
  private let config: UploadTweetConfiguration
  private lazy var viewModel = UploadTweetViewModel(config: config)

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
  
  private lazy var replyLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 14)
    label.textColor = .lightGray
    label.text = "replying to @joker"
    label.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
    return label
  }()
  
  // MARK: - Lifecycles

  init(user: User, config: UploadTweetConfiguration) {
    self.user = user
    self.config = config
    super.init(nibName: nil, bundle: nil)
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
    
//    switch config {
//    case .tweet:
//
//    case .reply(let tweet):
//    }
  }
  
  // MARK: - Selectors

  @objc func handleCancel() {
    dismiss(animated: true, completion: nil)
  }
  
  @objc func handleUploadTweet() {
    guard let caption = captionTextView.text else { return }
    TweetService.shared.uploadTweet(caption: caption, type: config) { error, _ in
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
    view.addSubview(replyLabel)
    replyLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 16, paddingLeft: 16)
    
    view.addSubview(profileImageView)
    profileImageView.sd_setImage(with: user.profileImageUrl, completed: nil)
    profileImageView.anchor(top: !viewModel.shouldShowReplyLabel ? view.safeAreaLayoutGuide.topAnchor : replyLabel.bottomAnchor, left: view.leftAnchor, paddingTop: 16, paddingLeft: 16)
    
    view.addSubview(captionTextView)
    captionTextView.anchor(top: !viewModel.shouldShowReplyLabel ? view.safeAreaLayoutGuide.topAnchor : replyLabel.bottomAnchor, left: profileImageView.rightAnchor, right: view.rightAnchor, paddingTop: 16, paddingLeft: 12, paddingRight: 16, height: 100)
    
    actionButton.setTitle(viewModel.actionButtonTitle, for: .normal)
    captionTextView.placeholderLabel.text = viewModel.placeholderText
    replyLabel.isHidden = !viewModel.shouldShowReplyLabel
    guard let replyText = viewModel.replyText else { return }
    replyLabel.text = replyText
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
