//
//  UserListViewModel.swift
//  SandboxApp
//
//  Created by Darul Firmansyah on 28/06/24.
//

import Combine
import Foundation

class UserListViewModel : ObservableObject {
    //MARK: - Properties
    private let networkService: NetworkManagerProtocol = NetworkManager()
    private var cancellables: Set<AnyCancellable> = []
    
    @Published var users: [UserModel] = []
    @Published var state: PageState = .loading
    @Published var footerState: UserListFooterState = .finish
    @Published var nextRequest: [String: String]?
    
    init() {
        getUsers(parameters: nil)
    }
    
    
    //MARK: - PAGINATION
    func loadMoreContent() {
        guard footerState == .loading
        else {
            return
        }
        getUsers(parameters: nextRequest)
    }
    
    //MARK: - API CALL
    func getUsers(parameters: [String: String]?) {
        if users.isEmpty {
            state = .loading
        }
        
        let response: AnyPublisher<[UserModel], APIError> = networkService.request(.users, headers: nil, parameters: parameters,
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
            self?.users.append(contentsOf: response)
            self?.state = .success
        }
        .store(in: &cancellables)
    }
    
    private func managePagination(allResponseHeaders: [AnyHashable: Any]) {
        let inputLinks: String? = allResponseHeaders["Link"] as? String
        let links: [String] = (inputLinks ?? "").split(separator: ",").map { String($0) }
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
