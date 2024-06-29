//
//  WebViewModel.swift
//  Gitivity
//
//  Created by Darul Firmansyah on 29/06/24.
//
import Combine
import Foundation

class WebViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var canGoBack: Bool = false
    @Published var shouldGoBack: Bool = false
    @Published var title: String = ""

    var url: String

    init(url: String) {
        self.url = url
    }
}
