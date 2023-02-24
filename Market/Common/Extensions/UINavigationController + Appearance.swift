//
//  UINavigationController + Appearance.swift
//  Market
//
//  Created by Casper on 23/02/2023.
//

import UIKit

/// This extension handles the custom look of the UINavigationController
extension UINavigationController {
    
    /// Since we currently only have one design for the NavigationController in the app, we can simply use the viewDidLoad
    /// If in the future we want multiple styles, we should handle those in different functions
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()

        appearance.largeTitleTextAttributes = [.font: UIFont(name: FontKeys.Quicksand.bold.rawValue, size: 36) ?? .boldSystemFont(ofSize: 36)]
        appearance.titleTextAttributes = [.font: UIFont(name: FontKeys.Quicksand.semiBold.rawValue, size: 20) ?? .boldSystemFont(ofSize: 20)]
        
        navigationBar.standardAppearance = appearance
        navigationBar.compactAppearance = appearance
    }
}
