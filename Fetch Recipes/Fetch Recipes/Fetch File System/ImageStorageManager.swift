//
//  ImageStorageManager.swift
//  Fetch Recipes
//
//  Created by Ehab Saifan on 12/2/24.
//

import UIKit
import CryptoKit

protocol ImageFileStorageP: AnyObject {
    func saveImage(_ image: UIImage, withName name: String, completion: @escaping (Result<Void, Error>) -> Void)
    func retrieveImage(named name: String, completion: @escaping (Result<UIImage, Error>) -> Void)
}

/// Manages image saving and retrieval on disk
class ImageStorageManager: ImageFileStorageP {
    private let fileHandler: FileHandler
    
    init(fileSystemHelper: FileHandler = FileHandler()) {
        self.fileHandler = fileSystemHelper
    }
    
    private func generateUniqueFileName(for url: String) -> String {
        let data = Data(url.utf8)
        let hash = SHA256.hash(data: data)
        let hashString = hash.compactMap { String(format: "%02x", $0) }.joined()
        return "\(hashString).jpg"
    }
    
    /// Saves an image to disk
    /// - Parameters:
    ///   - image: The UIImage to save
    ///   - name: The file name for the image
    /// - Completion handler: A closure that handles the success or failure
    func saveImage(_ image: UIImage, withName name: String, completion: @escaping (Result<Void, Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                // Convert the image to JPEG data
                guard let data = image.jpegData(compressionQuality: 1.0) else {
                    // Instead of throwing an error, pass it through the completion handler
                    DispatchQueue.main.async {
                        completion(.failure(ImageStorageError.failedToConvertImageToData))
                    }
                    return
                }
                
                // Get the directory path and create it if needed
                let directory = self.fileHandler.imagesDirectory
                let uniqueName = self.generateUniqueFileName(for: name)
                let filePath = directory.appendingPathComponent(uniqueName)
                
                // Write the data to disk
                try data.write(to: filePath)
                
                // Notify the caller of success on the main thread
                DispatchQueue.main.async {
                    completion(.success(()))
                }
            } catch {
                print("Debug - Error saving image named: \(name)")
                // Return error to the main thread if saving fails
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    /// Retrieves an image from disk
    /// - Parameter name: The file name of the image
    /// - Completion handler: A closure that handles the success or failure
    func retrieveImage(named name: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            // Check if the file exists
            let directory = self.fileHandler.imagesDirectory
            let filePath = directory.appendingPathComponent(name)
            if !FileManager.default.fileExists(atPath: filePath.path) {
                // Instead of throwing, return an error through the completion handler
                DispatchQueue.main.async {
                    completion(.failure(ImageStorageError.fileNotFound))
                }
                return
            }
            
            // Try loading the image
            guard let image = UIImage(contentsOfFile: filePath.path) else {
                // Return an error if image could not be loaded
                DispatchQueue.main.async {
                    completion(.failure(ImageStorageError.failedToLoadImage))
                }
                return
            }
            
            // Return the image to the caller on the main thread
            DispatchQueue.main.async {
                completion(.success(image))
            }
        }
    }
}

/// Custom errors for image storage operations
enum ImageStorageError: Error, LocalizedError {
    case failedToConvertImageToData
    case fileNotFound
    case failedToLoadImage
    
    var errorDescription: String? {
        switch self {
        case .failedToConvertImageToData:
            return "Failed to convert image to data."
        case .fileNotFound:
            return "The file could not be found."
        case .failedToLoadImage:
            return "Failed to load the image."
        }
    }
}
