//
//  DatasourceWebView.swift
//  RookAppleHealthDemo
//
//  Created by Francisco Guerrero Escamilla on 13/07/23.
//

import SwiftUI
import WebKit

struct DataSourceWebView: UIViewRepresentable {
  
  typealias UIViewType = WKWebView
  
  let webView: WKWebView
  
  func makeUIView(context: Context) -> WKWebView {
    webView
  }
  
  func updateUIView(_ uiView: WKWebView, context: Context) {
    
  }
  
}
