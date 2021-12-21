//
//  PostViewController.swift
//  findPets
//
//  Created by Марат Саляхетдинов on 14.12.2021.
//

import UIKit

class PostViewController: UIViewController {
    private let tableView : UITableView = {
        let tableView = UITableView()
        tableView.register(PostPrevievTableViewCell.self, forCellReuseIdentifier: PostPrevievTableViewCell.identifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
