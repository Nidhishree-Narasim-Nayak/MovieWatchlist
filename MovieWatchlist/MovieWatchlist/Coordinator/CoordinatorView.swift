//
//  CoordinatorView.swift
//  MovieWatchlist
//
//  Created by Nidhishree Nayak on 25/07/26.
//

import SwiftUI

struct CoordinatorView: UIViewControllerRepresentable {

    let controller: UIViewController
    
    /// Creates the UIKit view controller used by SwiftUI
    /// - Parameter context: The current context
    /// - Returns: The view controller
    func makeUIViewController(context: Context) -> UIViewController {
        controller
    }
    
    /// Updates the UIKit view controller when SwiftUI state changes
    /// - Parameters:
    ///   - uiViewController: The view controller to update
    ///   - context: The current context
    func updateUIViewController(
        _ uiViewController: UIViewController,
        context: Context
    ) {

    }
}
