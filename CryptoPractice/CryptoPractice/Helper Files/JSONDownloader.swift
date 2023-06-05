//
//  JSONDecoder.swift
//  CryptoPractice
//
//  Created by Austin Vesich on 5/26/23.
//

import Foundation

class JSONDownloader {
    
    // MARK: - Declaring variables
    static let shared = JSONDownloader()
    
    // MARK: - Funcs
    func downloadData <T: Decodable> (fromURL: String, model: T.Type, completion: @escaping (T) -> (), failure: @escaping (Error) -> ()) {
        guard let url = URL(string: fromURL) else {
            fatalError("ERROR: failed to form url")
        }
        
        URLSession.shared.dataTask(with: URLRequest(url: url)) { (data, _, error) in
            guard let data = data else {
                if let error = error {
                    failure(error)
                }
                return
            }
            
            do {
                let decoded = try JSONDecoder().decode(model, from: data)
                completion(decoded)
            } catch {
                failure(error)
            }
        }.resume()
    }
}
