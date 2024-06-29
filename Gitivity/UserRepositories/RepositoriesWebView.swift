//
//  RepositoriesWebView.swift
//  Gitivity
//
//  Created by Darul Firmansyah on 29/06/24.
//

import SwiftUI

struct RepositoriesWebView: View {
    private let repo: RepositoryModel
    private let viewModel: WebViewModel
    
    init(repo: RepositoryModel) {
        self.repo = repo
        self.viewModel = WebViewModel(url: repo.html_url ?? "")
    }
    
    var body: some View {
        WebViewContainer(viewModel: viewModel)
              .ignoresSafeArea()
              .navigationTitle("Content of \(repo.name ?? "")")
    }
}
