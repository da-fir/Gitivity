//
//  GitivityApp.swift
//  Gitivity
//
//  Created by Darul Firmansyah on 28/06/24.
//

import SwiftUI

@main
struct GitivityApp: App {
    var body: some Scene {
        WindowGroup {
            UserListView(viewModel: UserListViewModel())
        }
    }
}
