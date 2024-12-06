//
//  NetworkManager.swift
//  Fetch Recipes
//
//  Created by Ehab Saifan on 12/2/24.
//

import UIKit

protocol DataTaskDownloadable: AnyObject {
    func execute<T: Decodable>(request: URLRequest, completion: @escaping (Result<T, Error>)-> Void)
}

protocol ImageDownloadable {
    func downloadImage(request: URLRequest, completion: @escaping (Result<UIImage, Error>)-> Void) -> UUID
    func cancelTask(id: UUID)
}

class NetworkManager: DataTaskDownloadable {
    static let baseURL = "https://d3jbb8n5wk0qxi.cloudfront.net"
    
    enum FetchPath: String {
        case recipes = "/recipes.json"
        case malformedRecipes = "/recipes-malformed.json"
        case emptyRecipes = "/recipes-empty.json"
    }
    
    private let session = URLSession.shared
    private var tasks = [UUID: URLSessionDataTask]()
    
    func execute<T: Decodable>(request: URLRequest, completion: @escaping (Result<T, Error>)-> Void) {
        session.dataTask(with: request) { data, response, error in
            if let error {
                completion(.failure(error))
                return
            }
            
            guard let data else {
                completion(.failure(FetchError.noData))
                return
            }
            
            do {
                let obj = try JSONDecoder().decode(T.self, from: data)
                completion(.success(obj))
            } catch let error {
                completion(.failure(FetchError.decoding(error.localizedDescription)))
                return
            }
        }.resume()
    }
}

extension NetworkManager: ImageDownloadable {
    @discardableResult
    func downloadImage(request: URLRequest, completion: @escaping (Result<UIImage, Error>)-> Void) -> UUID {
        let task = session.dataTask(with: request) { data, response, error in
            if let error {
                completion(.failure(error))
                return
            }
            
            guard let data,
                  !data.isEmpty else {
                completion(.failure(FetchError.noData))
                return
            }
            
            guard let image = UIImage(data: data) else {
                completion(.failure(FetchError.imageDataCorrubted))
                return
            }
            
            completion(.success(image))
        }
        let uuid = UUID()
        tasks[uuid] = task
        task.resume()
        return uuid
    }
    
    func cancelTask(id: UUID) {
        guard let task = tasks[id] else {
            return
        }
        task.cancel()
        tasks[id] = nil
    }
}

