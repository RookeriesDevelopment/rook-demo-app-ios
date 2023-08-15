//
//  DataSourceViewModel.swift
//  RookAppleHealthDemo
//
//  Created by Francisco Guerrero Escamilla on 12/07/23.
//

import Foundation
import Combine

final class DataSourceViewModel: ObservableObject {
  
  // MARK:  Properties
  
  private let dataSourceNetworking: DataSourceNetworking = DataSourceNetworking()
  
  var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
  var urlSelected: URL? = nil
  
  @Published var isLoading: Bool = false
  @Published var sources: [SourceItemViewModel] = []
  
  // MARK:  Helpers
  
  private func getUserId() -> String {
    return "paco@rookmotion.com"
  }
  
  func getDataSourcesAvailable() {
    dataSourceNetworking.getDataSources(for: getUserId())
      .receive(on: DispatchQueue.main)
      .sink(receiveCompletion: { [weak self] _ in
        self?.isLoading = false
      }, receiveValue: { [weak self] response in
        self?.sources = response.dataSources.map {
          SourceItemViewModel(sourceDTO: $0)
        }
      }).store(in: &cancellables)
  }
}
