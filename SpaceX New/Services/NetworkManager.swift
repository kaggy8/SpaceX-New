//
//  NetworkManager.swift
//  SpaceX New
//
//  Created by Stanislav Demyanov on 07.08.2022.
//

import Foundation

class NetworkManager {
    // MARK: - Errors for Result
    enum RocketsError: Error {
        case invalidURL
        case noData
        case decodingError
    }
    
    // MARK: - Singleton
    static let shared = NetworkManager()
    
    // MARK: - Fetch Methods
    func fetchData<T: Decodable>(dataType: T.Type, from url: String, with completion: @escaping ((Result<T, RocketsError>) -> Void)) {
        guard let url = URL(string: url) else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                completion(.failure(.noData))
                print(error?.localizedDescription ?? "No description")
                return
            }
            
            do {
                let type = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(type))
                }
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
    
    func fetchImage(from url: String?) -> Data? {
        guard let url = URL(string: url ?? " ") else {
            return nil
        }
        return try? Data(contentsOf: url)
    }
    
    // MARK: - Private init
    private init() {}
}
