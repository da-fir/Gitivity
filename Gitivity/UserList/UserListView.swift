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
            Form {
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
            .navigationTitle("SwiftUI")
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
            HStack{
                AsyncImage(
                    url: URL(string: user.avatar_url ?? ""),
                    content: { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                    },
                    placeholder: {
                        ProgressView()
                            .frame(width: 100, height: 100)
                    })
                .fixedSize()
                
                Text(user.login)
                    .font(.title)
                Spacer()
            }
        }
    }
}
