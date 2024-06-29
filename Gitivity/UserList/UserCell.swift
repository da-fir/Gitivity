//
//  UserCell.swift
//  Gitivity
//
//  Created by Darul Firmansyah on 29/06/24.
//

import SwiftUI

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
