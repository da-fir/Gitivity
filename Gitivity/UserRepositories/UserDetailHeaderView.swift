//
//  UserDetailHeaderView.swift
//  Gitivity
//
//  Created by Darul Firmansyah on 29/06/24.
//

import SwiftUI
struct UserDetailHeaderView: View {
    var user: UserModel
    var body: some View {
        HStack {
            HStack {
                AsyncImage(
                    url: URL(string: user.avatar_url ?? ""),
                    content: { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)
                    },
                    placeholder: {
                        ProgressView()
                            .frame(width: 50, height: 50)
                    })
                .frame(width: 50, height: 50)
                .background(Circle().fill(Color.gray))
                .fixedSize()
                .clipShape(Circle())
                VStack(spacing: 5) {
                    HStack {
                        Text(user.login)
                            .font(.callout)
                            .lineLimit(1)
                        Spacer()
                        Text("# of followers:\((user.followers ?? 0).description)")
                            .font(.caption)
                            .lineLimit(1)
                    }
                    HStack {
                        Text(user.name ?? "")
                            .font(.callout)
                            .lineLimit(1)
                        Spacer()
                        Text("# of following:\((user.following ?? 0).description)")
                            .font(.caption)
                            .lineLimit(1)
                    }
                }
            }
        }
    }
}
