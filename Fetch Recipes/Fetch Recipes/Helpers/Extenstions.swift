//
//  Extenstions.swift
//  Fetch Recipes
//
//  Created by Ehab Saifan on 12/3/24.
//

import UIKit

extension UIViewController {
    var appDelegate: AppDelegate {
        UIApplication.shared.delegate as! AppDelegate
    }
    
    func alert(_ error: Error) {
        let alert = UIAlertController(title: "Error",
                                      message: error.localizedDescription,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
}

extension UITableViewCell {
    static var identifier: String {
        String(describing: self)
    }
}

extension UIImage {
    static var defaultCuisine: UIImage {
        UIImage(named: "cuisine")!.withRenderingMode(.alwaysTemplate)
    }
}

extension UIView {
    func makeRoundEdges(radius: CGFloat = 12, color: UIColor = .lightGray) {
        layer.cornerRadius = radius
        layer.borderWidth = 1
        layer.borderColor = color.cgColor
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        clipsToBounds = true
    }
}
