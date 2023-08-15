//
//  DatasourceWebViewModel.swift
//  RookAppleHealthDemo
//
//  Created by Francisco Guerrero Escamilla on 13/07/23.
//

import Foundation
import WebKit

final class DatasourceWebViewModel: NSObject, ObservableObject {
  
  // MARK:  Properties
  private let dataSourceURL: URL?
  private let innerWebView: WKWebView
  
  @Published var failLoadingURL: Bool = false
  
  // MARK:   Init
  
  init(dataSourceURL: URL?) {
    self.innerWebView = WKWebView(frame: .zero)
    self.dataSourceURL = dataSourceURL
    super.init()
    self.innerWebView.navigationDelegate = self
  }
  
  // MARK:  Helpers
  
  var webView: WKWebView {
    return innerWebView
  }
  
  func loadUrl() {
    guard let url = dataSourceURL else {
      failLoadingURL = true
      return
    }
    
    webView.load(URLRequest(url: url))
  }
}

extension DatasourceWebViewModel: WKNavigationDelegate {
  
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    
  }
  
}

extension DatasourceWebViewModel: WKScriptMessageHandler {
  func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
    debugPrint("dictionary \(message.body)")
    let dict = message.body as? Dictionary<String, String>
    debugPrint("dictionary \(dict)")
  }
}
