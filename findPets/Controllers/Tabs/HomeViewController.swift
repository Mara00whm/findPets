//
//  ViewController.swift
//  findPets
//
//  Created by Марат Саляхетдинов on 14.12.2021.
//

import UIKit

class HomeViewController: UIViewController {

    private var posts : [Posts] = []
    //MARK: - View and constants
    private let tableView : UITableView = {
        let tableView = UITableView()
        tableView.register(PostPrevievTableViewCell.self, forCellReuseIdentifier: PostPrevievTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let addPostButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .link
        button.tintColor = .white
        button.setImage(UIImage(systemName: "square.and.pencil",withConfiguration: UIImage.SymbolConfiguration(pointSize: 32,weight: .bold)), for: .normal)
        button.layer.cornerRadius = 30
        button.layer.shadowColor = UIColor.label.cgColor
        button.layer.shadowOpacity = 0.4
        button.layer.shadowRadius = 10
        button.addTarget(self, action: #selector(didTapCreate), for: .touchUpInside)
        return button
    }()
    
    private func addViews(){
        view.addSubview(tableView)
        view.addSubview(addPostButton)
    }
    //MARK: - OVERRIDE FUNCS
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.tabBarController?.tabBar.backgroundColor = .black
        addViews()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchAllPosts()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        createAnchors()
    }
    
    private func fetchAllPosts() {
        //guard let email = user?.email else {return}
        print("FETCH POSTS")

        DatabaseManager.shared.getAllPosts { [weak self] posts in
            self?.posts = posts
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    //MARK: - @OBJC FUNCS
    @objc private func didTapCreate(){
        let vc = CreateNewPostViewController()
        vc.title = "Create post"
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC,animated: true)
    }
    func createAnchors(){
        addPostButton.rightAnchor.constraint(equalTo: view.rightAnchor,constant: -20).isActive = true
        addPostButton.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -60).isActive = true
        addPostButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        addPostButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        //addPostButton.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        
        tableView.frame = view.bounds
    }
    
    
}

extension HomeViewController : UITableViewDelegate, UITableViewDataSource {
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
