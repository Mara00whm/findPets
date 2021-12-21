//
//  CreateNewPostViewController.swift
//  findPets
//
//  Created by Марат Саляхетдинов on 14.12.2021.
//

import UIKit

class CreateNewPostViewController: UIViewController {

    //MARK: - VIEWS AND CONSTANTS
    //Title
    private var selectedHeaderImage : UIImage?
    
    private let titleField : UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.autocorrectionType = .yes
        field.autocapitalizationType = .words
        field.leftViewMode = .always
        field.placeholder = "Enter your title"
        field.layer.cornerRadius = 5
        field.backgroundColor = .systemGray
        return field
    }()
    
    //Image
    private let headerImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.image = UIImage(systemName: "photo")
        imageView.backgroundColor = .tertiarySystemBackground
        return imageView
    }()
    //Text
    private let textView : UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = true
        textView.font = .systemFont(ofSize: 25)
        textView.backgroundColor = .secondarySystemBackground
        return textView
    }()
    
    //MARK: - OVERRIDE FUNCS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        configureBarButtomItems()
        addToView()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        createAnchors()
    }
    //MARK: - CONFIGURE FUNC
    private func configureBarButtomItems(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(didTapCancel))
    
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Post", style: .done, target: self, action: #selector(didTapPost))
    }
    
    private func addToView(){
        view.addSubview(textView)
        view.addSubview(headerImageView)
        view.addSubview(titleField)
        
        textView.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapAddPhoto))
        headerImageView.addGestureRecognizer(tap)
    }
    
    private func createAnchors(){
        let guide = view.safeAreaLayoutGuide
        
        titleField.topAnchor.constraint(equalToSystemSpacingBelow: guide.topAnchor, multiplier: 1).isActive = true
        
        //titleField.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        titleField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        titleField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
        headerImageView.topAnchor.constraint(equalTo: titleField.bottomAnchor, constant: 5).isActive = true
        headerImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        headerImageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        headerImageView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        textView.topAnchor.constraint(equalTo: headerImageView.bottomAnchor, constant: 5).isActive = true
        textView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        textView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        textView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    //MARK: - OBJC FUNC
    @objc private func didTapAddPhoto(){
        
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        present(picker,animated: true)
    }
    
    @objc private func didTapCancel(){
        dismiss(animated: true)
    }
    
    @objc private func didTapPost(){
        guard let title = titleField.text,
              let body = textView.text,
              let currentEmail = UserDefaults.standard.string(forKey: "email"),
              let headerImage = selectedHeaderImage,
              !title.trimmingCharacters(in: .whitespaces).isEmpty,
              !body.trimmingCharacters(in: .whitespaces).isEmpty
        else {
            let alert = UIAlertController(title: "Enter post details", message: "Check title, text or image", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
            present(alert,animated: true)
            return
            
        }
        print("starting upload")
        let postid = UUID().uuidString
        StorageManager.shared.uploadPostsHeaderImage(email: currentEmail,
                                                     image: headerImage,
                                                     postid: postid) { suc in
            guard suc else {return}
            StorageManager.shared.downloadUrlForPostHeader(email: currentEmail, postid: postid) { url in
                guard let headerURL = url else {print("Failed to upload url for header")
                                                      return}
                
                let post = Posts(id: postid,
                                 title: title,
                                 timeWas: Date().timeIntervalSince1970,
                                 text: body,
                                 headerImgURL: headerURL)
                DatabaseManager.shared.insertPost(with: post, email: currentEmail) { [ weak self] suc in
                    guard suc else {
                        print("i can't insert ost")
                        return
                    }
                        DispatchQueue.main.async{
                                self?.didTapCancel()
                    }
                }
            }
            //print("starting upload")
        }
        print("end upload")
    }
}

extension CreateNewPostViewController : UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
    }
}

extension CreateNewPostViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[.originalImage] as? UIImage else {return}
        
        selectedHeaderImage = image
        headerImageView.image = image
    }
    
    
}
