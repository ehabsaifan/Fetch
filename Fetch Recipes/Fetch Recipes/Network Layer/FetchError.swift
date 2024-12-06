//
//  FetchError.swift
//  Fetch Recipes
//
//  Created by Ehab Saifan on 12/2/24.
//

import Foundation

enum FetchError: Error, Equatable {
    case noData, decoding(String), imageDataCorrubted
    case invalidURL
}

extension FetchError: CustomStringConvertible {
    var description: String {
        switch self {
        case .noData:
            return "Response has no data"
        case .decoding(let string):
            return "Decoding Error. \(string)"
        case .imageDataCorrubted:
            return "Image data corrubted"
        case .invalidURL:
            return "Invalid URL."
        }
    }
}
