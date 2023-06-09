//
//  EditProfileController.swift
//  twitter-clone
//
//  Created by Gilang Aditya Rahman on 27/04/23.
//

import Firebase
import UIKit

private let reuseIdentifier = "EditProfileCell"

protocol EditProfileContollerDelegate: AnyObject {
  func controller(_ controller: EditProfileController, wantsToUpdate user: User)
  func handleLogout()
}

class EditProfileController: UITableViewController {
  // MARK: - Properties

  public var user: User
  private lazy var headerView = EditProfileHeader(user: user)
  private let imagePicker = UIImagePickerController()
  weak var delegate: EditProfileContollerDelegate?
  private var userInfoChanged: Bool = false
  private let footerView = EditProfileFooter()
  
  private var selectedImage: UIImage? {
    didSet { headerView.profileImageView.image = selectedImage }
  }

  private var imageChanged: Bool {
    return selectedImage != nil
  }
  
  init(user: User) {
    self.user = user
    super.init(style: .plain)
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    configureNavigationBar()
    configureTableView()
    
    configureImagePicker()
  }
  
  // MARK: - Selectors

  @objc func handleCancel() {
    dismiss(animated: true, completion: nil)
  }
  
  @objc func handleDone() {
    view.endEditing(true)
    guard imageChanged || userInfoChanged else { return }
    updateUserData()
  }
  
  // MARK: - API
  
  func updateUserData() {
    if imageChanged && !userInfoChanged {
      updateProfileImage()
    }
    
    if userInfoChanged && !imageChanged {
      UserService.shared.saveUserData(user: user) { _, _ in
        self.delegate?.controller(self, wantsToUpdate: self.user)
        // self.dismiss(animated: true, completion: nil)
      }
    }
    
    if userInfoChanged && imageChanged {
      UserService.shared.saveUserData(user: user) { _, _ in
        self.updateProfileImage()
      }
    }
  }
  
  func updateProfileImage() {
    guard let image = selectedImage else { return }
    
    UserService.shared.updateProfileImage(image: image) { profileImageUrl in
      self.user.profileImageUrl = profileImageUrl
      self.delegate?.controller(self, wantsToUpdate: self.user)
    }
  }
  
  // MARK: - Helpers
  
  func configureNavigationBar() {
    let appearance = UINavigationBarAppearance()
    appearance.backgroundColor = .twitterBlue
    appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
    navigationController?.navigationBar.tintColor = .white
    navigationController?.navigationBar.standardAppearance = appearance
    navigationController?.navigationBar.compactAppearance = appearance
    navigationController?.navigationBar.scrollEdgeAppearance = appearance
    
    navigationItem.title = "Edit Profile"
    
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDone))
    //
  }
  
  func configureTableView() {
    tableView.tableHeaderView = headerView
    headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 180)
    tableView.tableFooterView = UIView()
    headerView.delegate = self
    footerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 100)
    tableView.tableFooterView = footerView
    footerView.delegate = self
    
    tableView.register(EditProfileCell.self, forCellReuseIdentifier: reuseIdentifier)
  }
  
  func configureImagePicker() {
    imagePicker.delegate = self
    imagePicker.allowsEditing = true
  }
}

extension EditProfileController: EditProfileHeaderDelegate {
  func didTapChangeProfilePhoto() {
    present(imagePicker, animated: true, completion: nil)
  }
}

extension EditProfileController {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return EditProfileOptions.allCases.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! EditProfileCell
    
    guard let option = EditProfileOptions(rawValue: indexPath.row) else { return cell }
    cell.viewModel = EditProfileViewModel(user: user, option: option)
    cell.delegate = self
    
    return cell
  }
}

extension EditProfileController {
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    guard let option = EditProfileOptions(rawValue: indexPath.row) else { return 0 }
    
    return option == .bio ? 100 : 48
  }
}

extension EditProfileController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
    guard let image = info[.editedImage] as? UIImage else { return }
    selectedImage = image
    dismiss(animated: true, completion: nil)
  }
}

extension EditProfileController: EditProfileCellDelegate {
  func updateUserInfo(_ cell: EditProfileCell) {
    guard let viewModel = cell.viewModel else { return }
    userInfoChanged = true
    
    navigationItem.rightBarButtonItem?.isEnabled = true
    
    switch viewModel.option {
    case .fullname:
      guard let fullname = cell.infoTextField.text else { return }
      user.fullname = fullname
    case .username:
      guard let username = cell.infoTextField.text else { return }
      user.username = username
    case .bio:
      user.bio = cell.biotTextView.text
    }
  }
}

extension EditProfileController: EditProfileFooterDelegate {
  func handleLogout() {
    let alert = UIAlertController(title: nil, message: "Are you sure you want to logout ?", preferredStyle: .actionSheet)
    
    alert.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: { _ in
      self.dismiss(animated: true) {
        self.delegate?.handleLogout()
      }
    }))
    
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    
    present(alert, animated: true, completion: nil)
  }
}
