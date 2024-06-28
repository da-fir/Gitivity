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
        default:
            contentView
        }
    }
    
    private var contentView: some View {
        ListView(
            users: viewModel.users,
            isLoading: viewModel.footerState == .loading,
            onScrolledAtBottom: viewModel.loadMoreContent
        )
    }
}

struct ListView: View {
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
    }
    
    private var reposList: some View {
        ForEach(users) { user in
            UserCell(user: user).onAppear {
                if self.users.last == user {
                    self.onScrolledAtBottom()
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
    
    struct UserCell: View {
        let user: UserModel
        
        var body: some View {
            HStack(alignment: .center) {
                Image
                Text(user.login).font(.title)
            }
        }
    }
}


struct AsyncWebImageView: View {
    private var url: URL
    private var placeHolder: Image
    init(url: URL, placeHolder: Image) {
        self.url = url
        self.placeHolder = placeHolder
    }
    var body: some View {
        placeHolder
            .resizable()
            .onAppear { }
            .onDisappear { }
    }
}
