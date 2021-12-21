//
//  AuthManager.swift
//  findPets
//
//  Created by Марат Саляхетдинов on 14.12.2021.
//
//signIn signOut signUp
import Foundation
import FirebaseAuth

final class AuthManager {
    static let shared = AuthManager()
    
    private let auth = Auth.auth()
    
    private init () {
        
    }
    
    public var isSignedIn : Bool {
        return auth.currentUser != nil
    }
    
    //MARK: - Sign preferences
    public func signUp(email : String, password : String, compl : @escaping (Bool) -> (Void)) {
        guard !email.isEmpty && !password.isEmpty && password.count > 5 else {return}
        
        auth.createUser(withEmail: email, password: password) { result, error in
            guard result != nil && error == nil else {
                compl(false)
                return
            }
            compl(true)
        }
    }
    
    public func signIn(email : String, password : String, compl : @escaping (Bool) -> (Void)) {
        guard !email.isEmpty && !password.isEmpty && password.count > 5 else {return}
        
        auth.signIn(withEmail: email, password: password) { result, error in
            guard result != nil && error == nil else {
                compl(false)
                return
            }
            compl(true)
        }
    }
    
    public func signOut(compl : (Bool) -> (Void)) {
        do {
            try auth.signOut()
            compl(true)
        } catch {
            print(error)
            compl(false)
        }
    }
    
}
