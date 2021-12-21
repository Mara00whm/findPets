//
//  SignInViewController.swift
//  findPets
//
//  Created by Марат Саляхетдинов on 14.12.2021.
//

import UIKit

class SignInViewController: UIViewController {
    
    //MARK: - View
    private let headerView = SignInView()
    
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
        button.backgroundColor = .link
        button.setTitle("Sign in", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(signIn), for: .touchUpInside)
        return button
    }()
    
    private let createAccount : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Create account", for: .normal)
        button.setTitleColor(.link, for: .normal)
        button.addTarget(self, action: #selector(tapCreateAccount), for: .touchUpInside)
        return button
    }()
    
    private func addSubviews(){
        view.addSubview(headerView)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(buttonCreate)
        view.addSubview(createAccount)
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        emailField.delegate = self
        passwordField.delegate = self
    }
    
    //MARK: - override func
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sign in"
        view.backgroundColor = .systemBackground
        addSubviews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        createAnchors()
    }
    //MARK: - Button func
    
    @objc private func tapCreateAccount(){
        let vc = SignUpViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func signIn(){
        guard let email = emailField.text, !email.isEmpty,
              let password = passwordField.text, !password.isEmpty
                else {return}
        AuthManager.shared.signIn(email: email, password: password) {[weak self] success in
            if success {
                print("I am here")
                UserDefaults.standard.set(email, forKey: "email")
                let vc = TabBarViewController()
                vc.modalPresentationStyle = .fullScreen
                self?.present(vc,animated: true,completion: nil)
            } else {
                print("Some error")
            }
        }
    }

    //MARK: - Layout
    private func createAnchors(){
        let guide = view.safeAreaLayoutGuide
        
        headerView.topAnchor.constraint(equalToSystemSpacingBelow: guide.topAnchor, multiplier: 1).isActive = true
        headerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        headerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 160).isActive = true
        
        emailField.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 0).isActive = true
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
        
        createAccount.topAnchor.constraint(equalTo: buttonCreate.bottomAnchor, constant: 20).isActive = true
        createAccount.leftAnchor.constraint(equalTo: view.leftAnchor,constant: 20).isActive = true
        createAccount.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
    }
}
