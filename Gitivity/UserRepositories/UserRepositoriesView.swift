//
//  UserRepositoriesView.swift
//  Gitivity
//
//  Created by Darul Firmansyah on 29/06/24.
//

import SwiftUI

struct UserRepositoriesView: View {
    @ObservedObject
    var viewModel: UserRepositoriesViewModel
    
    var body: some View {
        List {
            Section() {
                UserDetailHeaderView(user: viewModel.user)
            }
            
            Section {
                switch viewModel.state {
                case .loading:
                    ProgressView {
                        Text("Fetching repositories ...")
                            .foregroundColor(.black)
                            .bold()
                    }
                case .empty:
                    Text("Repository is Empty ...")
                        .foregroundColor(.black)
                        .bold()
                default:
                    contentView
                }
            } header: {
                Text("\(viewModel.user.login) repositories").font(.title2)
            }
        }
        .onAppear(perform: {
            viewModel.onAppear()
        })
        .navigationTitle("Detail of \(viewModel.user.login)")
    }
    
    private var contentView: some View {
        RepositoryListContentView(
            repos: viewModel.repos,
            onScrolledAtBottom: viewModel.loadMoreContent
        )
    }
    
    struct RepositoryListContentView: View {
        let repos: [RepositoryModel]
        let onScrolledAtBottom: () -> Void
        
        var body: some View {
            ForEach(repos) { repo in
                NavigationLink(destination: RepositoriesWebView(repo: repo)) {
                    RepositoryCell(repo: repo).onAppear {
                        if self.repos.last == repo {
                            self.onScrolledAtBottom()
                        }
                    }
                }
            }
        }
    }
}
