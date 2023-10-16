//
//  HtmlView.swift
//  Crypto
//
//  Created by Abu Raihan Rony on 16/10/23.
//

import SwiftUI
import WebKit
import Combine

struct HTMLView: UIViewRepresentable {
    
    let htmlContent: String
        
    private let webView = WKWebView()
    var sizeObserver: NSKeyValueObservation?
        
    func makeUIView(context: Context) -> WKWebView {
        webView.scrollView.isScrollEnabled = false
        return webView
    }
        
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.loadHTMLString(htmlContent, baseURL: nil)
    }
}
