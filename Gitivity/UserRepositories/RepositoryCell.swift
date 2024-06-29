//
//  RepositoryCell.swift
//  Gitivity
//
//  Created by Darul Firmansyah on 29/06/24.
//

import SwiftUI

struct RepositoryCell: View {
    let repo: RepositoryModel
    
    var body: some View {
        VStack(spacing: 5) {
            HStack {
                Text(repo.name ?? "")
                    .font(.title3)
                    .lineLimit(1)
                Spacer()
                Text(repo.language ?? "")
                    .font(.caption2)
                    .lineLimit(1)
            }
            HStack {
                Text(repo.description ?? "")
                    .font(.callout)
                    .lineLimit(0)
                Spacer()
                Text("# of stars:\((repo.stargazers_count ?? 0).description)")
                    .font(.caption)
                    .lineLimit(1)
            }
        }
    }
}
