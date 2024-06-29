//
//  RepositoryModel.swift
//  Gitivity
//
//  Created by Darul Firmansyah on 29/06/24.
//

import Foundation

struct RepositoryModel : Codable, Identifiable, Equatable {
    var uuid: UUID = UUID()
    let id : Int?
    let node_id : String?
    let name : String?
    let full_name : String?
    let owner : UserModel?
    let isPrivate : Bool?
    let html_url : String?
    let description : String?
    let fork : Bool?
    let url : String?
    let stargazers_count : Int?
    let topics : [String]?
    let language : String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case node_id = "node_id"
        case name = "name"
        case full_name = "full_name"
        case owner = "owner"
        case isPrivate = "private"
        case html_url = "html_url"
        case description = "description"
        case fork = "fork"
        case url = "url"
        case stargazers_count = "stargazers_count"
        case topics = "topics"
        case language = "language"
    }
}
