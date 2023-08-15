//
//  DataSourcePageView.swift
//  RookAppleHealthDemo
//
//  Created by Francisco Guerrero Escamilla on 13/07/23.
//

import SwiftUI

struct DataSourcePageView: View {
  
  @StateObject var viewModel: DatasourceWebViewModel
  
  var body: some View {
    DataSourceWebView(webView: viewModel.webView)
      .onAppear {
        viewModel.loadUrl()
      }
  }
}
