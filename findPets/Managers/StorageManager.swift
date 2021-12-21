//
//  StorageManager.swift
//  findPets
//
//  Created by Марат Саляхетдинов on 14.12.2021.
//

import Foundation
import FirebaseStorage
import UIKit

final class StorageManager {
    static let shared = StorageManager()
    
    private let container = Storage.storage()
    
    private init(){}
    
    public func uploadUserImage(email : String,image : UIImage?, compl : @escaping(Bool)->Void) {
        let path = email
                    .replacingOccurrences(of: "@", with: "_")
                    .replacingOccurrences(of: ".", with: "_")

                guard let pngData = image?.pngData() else {
                    return
                }

                container
                    .reference(withPath: "profile_pictures/\(path)/photo.png")
                    .putData(pngData, metadata: nil) { metadata, error in
                        guard metadata != nil, error == nil else {
                            compl(false)
                            return
                        }
                        compl(true)
                    }
    }
    
    public func downloadUrlForUserImage(user : User, compl : @escaping(URL?)->Void) {
        
    }
    
    public func downloadUrlForProfilePicture(
            path: String,
            completion: @escaping (URL?) -> Void
        ) {
            container.reference(withPath: path)
                .downloadURL { url, _ in
                    completion(url)
                }
        }
    
    public func uploadPostsHeaderImage(email : String, image : UIImage,postid : String, compl : @escaping(Bool)->Void) {
        let path = email
                    .replacingOccurrences(of: "@", with: "_")
                    .replacingOccurrences(of: ".", with: "_")

        guard let pngData = image.pngData() else {
                    return
                }

                container
                    .reference(withPath: "posts/\(path)/\(postid).png")
                    .putData(pngData, metadata: nil) { metadata, error in
                        guard metadata != nil, error == nil else {
                            compl(false)
                            return
                        }
                        compl(true)
                    }
    }
    
    public func downloadUrlForPostHeader(email : String, postid : String, compl : @escaping(URL?)->Void) {
        
        let emailComponent = email
                    .replacingOccurrences(of: "@", with: "_")
                    .replacingOccurrences(of: ".", with: "_")
                container
                    .reference(withPath: "posts/\(emailComponent)/\(postid).png")
                    .downloadURL { url, error in
                        guard error == nil else {return}
                        compl(url)
                    }
    }
    
}
