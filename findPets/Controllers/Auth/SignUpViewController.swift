//
//  SignUpViewController.swift
//  findPets
//
//  Created by Марат Саляхетдинов on 14.12.2021.
//

import UIKit

class SignUpViewController: UIViewController {
    //MARK: - Views
    private let emailField : UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.leftViewMode = .always
        field.keyboardType = .emailAddress
        field.placeholder = "Enter your email"
        field.layer.cornerRadius = 5
        field.backgroundColor = .systemGray
        return field
    }()
    
    private let fullName : UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.leftViewMode = .always
        field.placeholder = "Enter your full name"
        field.layer.cornerRadius = 5
        field.backgroundColor = .systemGray
        return field
    }()
    
    private let passwordField : UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.leftViewMode = .always
        field.keyboardType = .default
        field.placeholder = "Enter your password"
        field.layer.cornerRadius = 5
        field.backgroundColor = .systemGray
        return field
    }()
    
    private let buttonCreate : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.backgroundColor = .systemGreen
        button.setTitle("Create account", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(tapSignUp), for: .touchUpInside)
        return button
    }()

    
    private func addSubviews(){
        view.addSubview(fullName)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(buttonCreate)
        
        emailField.delegate = self
        passwordField.delegate = self
    }
    
    //MARK: - override func
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Account registration"
        view.backgroundColor = .systemBackground
        
        addSubviews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        createAnchors()
    }
    //MARK: - Buttons action
    @objc private func tapSignUp(){
        guard let email = emailField.text, !email.isEmpty,
              let password = passwordField.text, !password.isEmpty,
              let name = fullName.text , !name.isEmpty else {return}
        
        AuthManager.shared.signUp(email: email, password: password) {[weak self] success in
            if success {
                let newUser = User(name: name, email: email, profileImgRef: nil)
                DatabaseManager.shared.insertUser(user: newUser) { inserted in
                    guard inserted else {return}
                    UserDefaults.standard.set(email, forKey: "email")
                    UserDefaults.standard.set(name, forKey: "name")
                    DispatchQueue.main.async {
                        let vc = TabBarViewController()
                        vc.modalPresentationStyle = .fullScreen
                        self?.present(vc,animated:  true)
                        print("tap")
                    }
                }
            } else {
                print("Filed to create an account")
            }
        }
    }
    //MARK: - Layouts
    private func createAnchors(){
        let guide = view.safeAreaLayoutGuide

        fullName.topAnchor.constraint(equalToSystemSpacingBelow: guide.topAnchor, multiplier: 1).isActive = true
        fullName.leftAnchor.constraint(equalTo: view.leftAnchor,constant: 30).isActive = true
        fullName.rightAnchor.constraint(equalTo: view.rightAnchor,constant: -30).isActive = true
        fullName.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        emailField.topAnchor.constraint(equalTo: fullName.bottomAnchor, constant: 10).isActive = true
        emailField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        emailField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        emailField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 10).isActive = true
        passwordField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        passwordField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        passwordField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        buttonCreate.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 30).isActive = true
        buttonCreate.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        buttonCreate.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        buttonCreate.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
}

