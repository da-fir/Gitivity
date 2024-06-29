//
//  WebViewContainer.swift
//  Gitivity
//
//  Created by Darul Firmansyah on 29/06/24.
//

import Foundation
import SwiftUI
import WebKit
// Implementation of WebView based on
// https://asynclearn.medium.com/how-to-display-a-webview-in-swiftui-d60b4bff6ba7
struct WebViewContainer: UIViewRepresentable {
    @ObservedObject var viewModel: WebViewModel

    func makeCoordinator() -> WebViewContainer.Coordinator {
        Coordinator(self, viewModel)
    }

    func makeUIView(context: Context) -> WKWebView {
        guard let url = URL(string: self.viewModel.url) else {
            return WKWebView()
        }

        let request = URLRequest(url: url)
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        webView.load(request)

        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        if viewModel.shouldGoBack {
            uiView.goBack()
            viewModel.shouldGoBack = false
        }
    }
}

extension WebViewContainer {
    class Coordinator: NSObject, WKNavigationDelegate {
        @ObservedObject private var webViewModel: WebViewModel
        private let parent: WebViewContainer

        init(_ parent: WebViewContainer, _ webViewModel: WebViewModel) {
            self.parent = parent
            self.webViewModel = webViewModel
        }

        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            webViewModel.isLoading = true
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            webViewModel.isLoading = false
            webViewModel.title = webView.title ?? ""
            webViewModel.canGoBack = webView.canGoBack
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            webViewModel.isLoading = false
        }
    }
}
