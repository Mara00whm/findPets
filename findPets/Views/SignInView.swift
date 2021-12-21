//
//  SignInView.swift
//  findPets
//
//  Created by Марат Саляхетдинов on 15.12.2021.
//

import UIKit

class SignInView: UIView {

    private let imageView : UIImageView = {
        let image = UIImageView(image: UIImage(named: "appstore"))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.backgroundColor = .blue
        return image
    }()
    
    private let labelInfo : UILabel = {
        let labelInfo = UILabel()
        labelInfo.translatesAutoresizingMaskIntoConstraints = false
        labelInfo.textAlignment = .center
        labelInfo.font = .systemFont(ofSize: 20, weight: .medium)
        labelInfo.text = "Find your friend"
        return labelInfo
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        clipsToBounds = false
        
        addSubview(imageView)
        addSubview(labelInfo)
        setupAnchors()
        
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func setupAnchors(){
        imageView.backgroundColor = .white
        imageView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        imageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        imageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        
        
        labelInfo.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20).isActive = true
        labelInfo.leftAnchor.constraint(equalTo: imageView.leftAnchor).isActive = true
        labelInfo.rightAnchor.constraint(equalTo: imageView.rightAnchor).isActive = true
    }
    
}
