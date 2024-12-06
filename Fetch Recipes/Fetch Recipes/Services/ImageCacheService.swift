//
//  ImageCacheService.swift
//  Fetch Recipes
//
//  Created by Ehab Saifan on 12/2/24.
//

import UIKit

class ImageCacheService {
    private let networkManager: ImageDownloadable
    private let imageFileStorage: ImageFileStorageP
    private let cache: NSCache<NSURL, UIImage>
    
    private var uuids: [String: UUID]
    
    init(networkManager: ImageDownloadable,
         imageFileStorage: ImageFileStorageP,
         cache: NSCache<NSURL, UIImage> = NSCache(),
         cacheLimit: Int = 100) {
        self.networkManager = networkManager
        self.imageFileStorage = imageFileStorage
        self.cache = cache
        self.cache.countLimit = cacheLimit
        self.uuids = [:]
    }
    
    func getImage(url urlString: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        assert(Thread.isMainThread, "This call should happen on main thread")
        
        guard let nsURL = NSURL(string: urlString) else {
            print("Debug Error- Should constructed NSURL: \(urlString)")
            completion(.failure(FetchError.invalidURL))
            return
        }
        
        // Load image from memory cache
        if let cachedImage = cache.object(forKey: nsURL) {
            print("Debug - cachedImage: \(urlString)")
            completion(.success(cachedImage))
            return
        }
        
        // Check disk for the image
        getImageFromDesk(url: urlString) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let diskImage):
                print("Debug - getImageFromDesk: \(urlString)")
                    completion(.success(diskImage))
                    // Cache the image in memory
                    self.cache.setObject(diskImage, forKey: nsURL)
            case .failure:
                // On failure, fallback to fetching from the server
                let uuid = self.getImageFromServer(url: urlString) { [weak self] result in
                    guard let self else { return }
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let image):
                            print("Debug - gotImageFromServer: \(urlString)")
                            completion(.success(image))
                            // Save to desk
                            self.saveImageToDesk(url: urlString, image: image)
                            // Save to memory
                            self.cache.setObject(image, forKey: nsURL)
                            
                        case .failure(let error):
                            print("Debug Error- Should got image: \(error.localizedDescription) | \(urlString)")
                            completion(.failure(error))
                        }
                    }
                }
                self.uuids[urlString] = uuid
            }
        }
    }
}

// MARK: - File Storage Methods
extension ImageCacheService {
    private func getImageFromDesk(url urlString: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        imageFileStorage.retrieveImage(named: urlString, completion: completion)
    }
    
    private func saveImageToDesk(url: String, image: UIImage) {
        imageFileStorage.saveImage(image, withName: url) { result in
            switch result {
            case .success(_):
                print("Debug - Success saving image named: \(url)")
            case .failure(_):
                print("Debug - Failed saving image named: \(url)")
            }
        }
        
    }
}

// MARK: - Server Methods
extension ImageCacheService {
    private func getImageFromServer(url urlString: String, completion: @escaping (Result<UIImage, Error>)-> Void) -> UUID {
        assert(Thread.isMainThread, "This call should happen on main thread")
        
        let url = URL(string: urlString)!
        let request = URLRequest(url: url)
        
        // cancel previous call
        cancelImageDownload(url: urlString)
        
        // Get new one
        let uuid = networkManager.downloadImage(request: request, completion: completion)
        return uuid
    }

    private func cancelImageDownload(url: String) {
        assert(Thread.isMainThread, "This call should happen on main thread")
        
        guard let uuid = uuids[url] else {
            return
        }
        networkManager.cancelTask(id: uuid)
        uuids[url] = nil
    }
}

