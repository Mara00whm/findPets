//
//  TabBarViewController.swift
//  findPets
//
//  Created by Марат Саляхетдинов on 14.12.2021.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    

   private func setUp(){
       guard let currentEmail = UserDefaults.standard.string(forKey: "email") else {return}
        let home = HomeViewController()
       home.title = "Home"
        let profile = ProfileViewController(currentEmail: currentEmail)
       profile.title = "Info"
       
       home.navigationItem.largeTitleDisplayMode = .always
       profile.navigationItem.largeTitleDisplayMode = .always
       
       let nav1 = UINavigationController(rootViewController: home)
       let nav2 = UINavigationController(rootViewController: profile)
       
       nav1.navigationBar.prefersLargeTitles = true
       nav2.navigationBar.prefersLargeTitles = true
       
       nav1.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
       nav2.tabBarItem = UITabBarItem(title: "Info", image: UIImage(systemName: "person.circle"), tag: 1)
       
       setViewControllers([nav1,nav2], animated: true)
    }

}
