//
//  UserRepositoriesViewModel.swift
//  Gitivity
//
//  Created by Darul Firmansyah on 29/06/24.
//

import Combine
import SwiftUI

class UserRepositoriesViewModel : ObservableObject {
    //MARK: - Properties
    private let networkService: NetworkManagerProtocol = NetworkManager()
    private var cancellables: Set<AnyCancellable> = []
    @Published var state: PageState = .loading
    @Published var user: UserModel
    @Published var repos: [RepositoryModel] = []
    @Published var footerState: UserListFooterState = .finish
    @Published var nextRequest: [String: String]?
    
    init(user: UserModel) {
        self.user = user
    }
    
    func onAppear() {
        getUserDetail()
        getRepositories(parameters: nil)
    }
    
    //MARK: - API CALL
    func getUserDetail() {
        let response: AnyPublisher<UserModel, APIError> = networkService
            .request(.user(user.login),
                headers: nil,
                parameters: nil,
                headerInterceptor: nil
            )

        response
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                // no op
            }
            receiveValue: { [weak self] response in
                self?.user = response
            }
            .store(in: &cancellables)
    }
    
    func getRepositories(parameters: [String: String]?) {
        let response: AnyPublisher<[RepositoryModel], APIError> = networkService
            .request(
                .repositories(user.login),
                headers: nil,
                parameters: parameters,
                headerInterceptor: { [weak self] allResponseHeaders in
                    DispatchQueue.main.async {
                        self?.managePagination(allResponseHeaders: allResponseHeaders)
                    }
                })
        
        response
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.state = .error
                }
            }
            receiveValue: { [weak self] response in
                self?.repos.append(contentsOf: response.filter({ !($0.fork ?? true) }))
                self?.state = .success
            }
            .store(in: &cancellables)
    }
    
    func loadMoreContent() {
        guard footerState == .loading
        else {
            return
        }
        getRepositories(parameters: nextRequest)
    }
    
    private func managePagination(allResponseHeaders: [AnyHashable: Any]) {
        let inputLinks: String? = allResponseHeaders["Link"] as? String
        let links: [String] = (inputLinks ?? "").split(separator: ",").map { String($0) }
        
        guard !links.isEmpty
        else {
            nextRequest = nil
            footerState = .finish
            return
        }
        for link in links {
            if link.contains("next") {
                let slice: String = link.slice(from: "?", to: ">") ?? ""
                let input: [String] = slice.split(separator: "=").map { String($0) }
                
                if input.count > 1 {
                    nextRequest = [input[0]: input[1]]
                    footerState = .loading
                    break
                }
                else {
                    nextRequest = nil
                    footerState = .finish
                }
            }
            else {
                nextRequest = nil
                footerState = .finish
            }
        }
    }
    
}
