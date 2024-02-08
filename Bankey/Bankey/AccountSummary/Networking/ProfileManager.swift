//
//  ProfileManager.swift
//  Bankey
//
//  Created by Hamit Tırpan on 8.02.2024.
//

import Foundation

protocol ProfileManagable: AnyObject{
    func fetchProfile(forUserId userId: String, completion: @escaping (Result<Profile,NetworkError>) -> Void)
}

class ProfileManager:ProfileManagable {
    func fetchProfile(forUserId userId: String, completion: @escaping (Result<Profile,NetworkError>) -> Void) {
        let url = URL(string: "https://fierce-retreat-36855.herokuapp.com/bankey/profile/\(userId)")!

        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    completion(.failure(.serverError))
                    return
                }
                
                do {
                    let profile = try JSONDecoder().decode(Profile.self, from: data)
                    completion(.success(profile))
                } catch {
                    completion(.failure(.decodingError))
                }
            }
        }.resume()
    }
}
