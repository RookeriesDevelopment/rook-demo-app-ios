//
//  DataSourcesView.swift
//  RookAppleHealthDemo
//
//  Created by Francisco Guerrero Escamilla on 13/07/23.
//

import SwiftUI

struct DataSourcesView: View {
  
  @StateObject var viewModel: DataSourceViewModel = DataSourceViewModel()
  @State var isSourcePagePresented: Bool = false
  
  var body: some View {
    VStack {
      if (viewModel.isLoading) {
        ProgressView()
      } else {
        List(viewModel.sources) { item in
          Button(action: {
            self.viewModel.urlSelected = item.urlConnect
            self.isSourcePagePresented = true
          }, label: {
            ButtonSourceView(viewModel: item)
          })
        }
        .listStyle(.plain)
      }
    }.onAppear {
      viewModel.getDataSourcesAvailable()
    }
    .sheet(isPresented: $isSourcePagePresented, onDismiss: {
      viewModel.getDataSourcesAvailable()
    }) {
      DataSourcePageView(viewModel: DatasourceWebViewModel(dataSourceURL: viewModel.urlSelected))
    }
  }
}

struct DataSourcesView_Previews: PreviewProvider {
  static var previews: some View {
    DataSourcesView()
  }
}
