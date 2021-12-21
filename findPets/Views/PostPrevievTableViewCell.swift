//
//  PostPrevievTableViewCell.swift
//  findPets
//
//  Created by Марат Саляхетдинов on 21.12.2021.
//

import UIKit

class PostPrevievTableViewCellViewModel {
    var title : String
    var imageURL : URL?
    var imageData : Data?
    
    init(title : String,imageURL : URL?){
        self.title = title
        self.imageURL = imageURL
    }
}


class PostPrevievTableViewCell: UITableViewCell {

    static let identifier = "PostPreviewTableViewCell"
    private let postImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 8
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20,weight : .medium)
        label.textAlignment = .left
        return label
    }()
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    override init(style : UITableViewCell.CellStyle, reuseIdentifier : String?) {
        super.init(style : style, reuseIdentifier : reuseIdentifier)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(postImageView)
        contentView.addSubview(titleLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        createAnchors()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        postImageView.image = nil
    }
    
    private func createAnchors(){
        postImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0).isActive = true
        postImageView.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 0).isActive = true
        postImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: 0).isActive = true
        postImageView.heightAnchor.constraint(equalToConstant: contentView.frame.height - 10).isActive = true
        postImageView.widthAnchor.constraint(equalToConstant: contentView.frame.height - 10).isActive = true

        titleLabel.leftAnchor.constraint(equalTo: postImageView.rightAnchor, constant: 20).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20).isActive = true
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 4).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: 4).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: contentView.frame.height - 10).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: contentView.frame.width - contentView.frame.height - 10).isActive = true
}
    
    func configure(with viewModel : PostPrevievTableViewCellViewModel){
        titleLabel.text = viewModel.title
        
        if let data = viewModel.imageData {
            postImageView.image = UIImage(data: data)
        }
        else if let url = viewModel.imageURL{
            let task = URLSession.shared.dataTask(with: url) {[weak self] data, _, _ in
                guard let data = data else {return}
                viewModel.imageData = data
                DispatchQueue.main.async {
                    self?.postImageView.image = UIImage(data: data)
                }
            }
            task.resume()
        }
    }
    
}
