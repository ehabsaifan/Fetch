//
//  FileHandler.swift
//  Fetch Recipes
//
//  Created by Ehab Saifan on 12/2/24.
//

import Foundation

class FileHandler {
    private let fileManager: FileManager
    
    init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
    }
    
    /// Gets the application's documents directory
    var documentsDirectory: URL {
        return fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    /// Gets the directory for storing images, creating it if it doesn’t exist
    var imagesDirectory: URL {
        let directory = documentsDirectory.appendingPathComponent("Images")
        createDirectoryIfNeeded(at: directory)
        return directory
    }
    
    /// Creates a directory if it doesn't already exist
    /// - Parameter url: The directory URL
    private func createDirectoryIfNeeded(at url: URL) {
        guard !fileManager.fileExists(atPath: url.path) else { return }
        do {
            try fileManager.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        } catch {
            fatalError("Failed to create directory: \(error)")
        }
    }
}
