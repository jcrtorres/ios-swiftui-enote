//
//  enotesApp.swift
//  enotes
//
//  Created by Julio Torres on 19/02/25.
//

import SwiftUI

@main
struct enotesApp: App {
    
    @StateObject var viewModel = ViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
