//
//  UserListView.swift
//  SandboxApp
//
//  Created by Darul Firmansyah on 28/06/24.
//
import SwiftUI

struct UserListView: View {
    @ObservedObject
    var viewModel: UserListViewModel
    
    var body: some View {
        NavigationStack {
            switch viewModel.state {
            case .loading:
                ProgressView {
                    Text("Loading ...")
                        .foregroundColor(.black)
                        .bold()
                }
            case .empty:
                Text("Page is Empty ...")
                    .foregroundColor(.black)
                    .bold()
            case .error:
                Text("Page is Error, Token Might not valid")
                    .foregroundColor(.black)
                    .bold()
            default:
                contentView
            }
        }
    }
    
    private var contentView: some View {
        UserListContentView(
            users: viewModel.users,
            isLoading: viewModel.footerState == .loading,
            onScrolledAtBottom: viewModel.loadMoreContent
        )
    }
}

struct UserListContentView: View {
    let users: [UserModel]
    let isLoading: Bool
    let onScrolledAtBottom: () -> Void
    
    var body: some View {
        List {
            reposList
            if isLoading {
                loadingIndicator
            }
        }
        .navigationTitle("Github Users")
    }
    
    private var reposList: some View {
        ForEach(users) { user in
            NavigationLink(destination: UserRepositoriesView(viewModel: UserRepositoriesViewModel(user: user))) {
                UserCell(user: user).onAppear {
                    if self.users.last == user {
                        self.onScrolledAtBottom()
                    }
                }
            }
        }
    }
    
    private var loadingIndicator: some View {
        ProgressView {
            Text("Loading Next Page ...")
                .foregroundColor(.black)
                .bold()
        }
    }
}
