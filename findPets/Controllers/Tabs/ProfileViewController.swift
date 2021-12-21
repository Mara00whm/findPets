//
//  ProfileViewController.swift
//  findPets
//
//  Created by Марат Саляхетдинов on 14.12.2021.
//

import UIKit

class ProfileViewController: UIViewController {

    //MARK: - VIEW AND CONSTANT
    private var posts : [Posts] = []
    let currentEmail : String
    private var user : User?
    init(currentEmail : String) {
        self.currentEmail = currentEmail
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let tableView : UITableView = {
        let tableView = UITableView()
        tableView.register(PostPrevievTableViewCell.self, forCellReuseIdentifier: PostPrevievTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let headerView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .link
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private let imageView : UIImageView = {
        let image = UIImageView(image:UIImage(systemName: "person"))
        image.tintColor = .black
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.isUserInteractionEnabled = true
        image.layer.cornerRadius = 100
        return image
    }()
    
    private let emailLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 25, weight : .bold)
        return label
    }()
    //MARK: - OVERRIDE FUNC
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .red
        signOutButton()
        setUpTable()
        fetchPosts()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        createAnchors()
    }
    
    //MARK: - SETTINGS
    private func setUpTable(){
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self

        tableViewHeader()
        fetchProfileData()
    }
    private func fetchProfileData(){
        
        DatabaseManager.shared.getProfile(email: currentEmail) { [weak self] user in
            guard let user = user else {return}
            print("here")
            self?.user = user
            
            DispatchQueue.main.async{
            self?.tableViewHeader(photoRef: user.profileImgRef, name: user.name)
            }
        }
    }
    private func signOutButton(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "sign out",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapSignOut))
    }
    
    private func tableViewHeader(photoRef : String? = nil, name : String? = nil){
        emailLabel.text = currentEmail
        tableView.tableHeaderView = headerView
        headerView.addSubview(imageView)
        headerView.addSubview(emailLabel)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapAddPhoto))
        imageView.addGestureRecognizer(tap)
        
        if let name = name {
            title = name
        }
        
        if let ref = photoRef {
            print("i am here123")
            StorageManager.shared.downloadUrlForProfilePicture(path: ref) { url in
                guard let url = url else {
                    return
                }
                let task = URLSession.shared.dataTask(with: url) { data, _, _ in
                    guard let data = data else {
                        return
                    }
                    DispatchQueue.main.async {
                        self.imageView.image = UIImage(data: data)
                    }
                }
                
                task.resume()
            }
        }

    }
    //MARK: - OBJC FUNCS
    @objc  func didTapAddPhoto(){
        print("i am here2")
        guard let myEmail = UserDefaults.standard.string(forKey: "email") else {return}
        
        guard myEmail == currentEmail else {return}
        print("i am here")
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
            self.present(picker,animated: true,completion: nil)

    }
    
    //MARK: - Sign out
    @objc private func didTapSignOut(){
        let sheet = UIAlertController(title: "Sign out", message: "Are you really want to sign out?", preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        sheet.addAction(UIAlertAction(title: "Sign out", style: .destructive, handler: { _ in
            AuthManager.shared.signOut {[weak self] success in
                if success {
                    DispatchQueue.main.async {
                        UserDefaults.standard.set(nil, forKey: "email")
                        UserDefaults.standard.set(nil, forKey: "name")
                        let signInVC = SignInViewController()
                        signInVC.navigationItem.largeTitleDisplayMode = .always
                        let navVc = UINavigationController(rootViewController: signInVC)
                        navVc.navigationBar.prefersLargeTitles = true
                        navVc.modalPresentationStyle = .fullScreen
                        self?.present(navVc, animated: true, completion: nil)
                    }
                }
            }
        }))
        present(sheet, animated: true, completion: nil)
    }
    
    private func createAnchors(){
        
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true

        headerView.heightAnchor.constraint(equalTo:view.widthAnchor).isActive = true
        headerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true

        imageView.topAnchor.constraint(equalTo: headerView.topAnchor,constant: 50).isActive = true
        imageView.leftAnchor.constraint(equalTo: headerView.leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: headerView.rightAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        emailLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20).isActive = true
        emailLabel.leftAnchor.constraint(equalTo: headerView.leftAnchor).isActive = true
        emailLabel.rightAnchor.constraint(equalTo: headerView.rightAnchor).isActive = true
    }
    
    private func fetchPosts() {
        //guard let email = user?.email else {return}
        print("FETCH POSTS")
        print(currentEmail)
        DatabaseManager.shared.getPosts(for: currentEmail) { posts in
            self.posts = posts
            print(posts)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

extension ProfileViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostPrevievTableViewCell.identifier, for: indexPath) as? PostPrevievTableViewCell else {fatalError()}
        cell.configure(with: .init(title: post.title, imageURL: post.headerImgURL))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        160
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = ViewPostViewController(post: posts[indexPath.row])
        vc.title = "Post"
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension ProfileViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.editedImage] as? UIImage else {return}
        
        StorageManager.shared.uploadUserImage(email: currentEmail,
                                              image: image) { [weak self] success in
            guard let strongSelf = self else {return}
            if success {
                DatabaseManager.shared.updateProfileImg(email : strongSelf.currentEmail) { updated in
                    guard updated else {return}
                    DispatchQueue.main.async {
                        strongSelf.fetchProfileData()
                    }
                }
            }
        }
    }
    
}

