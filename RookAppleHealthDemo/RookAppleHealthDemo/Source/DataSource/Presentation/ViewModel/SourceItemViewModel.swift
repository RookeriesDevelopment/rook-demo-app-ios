//
//  SourceViewModel.swift
//  RookAppleHealthDemo
//
//  Created by Francisco Guerrero Escamilla on 12/07/23.
//

import Foundation

struct SourceItemViewModel: Identifiable {
  
  private let sourceDTO: DataSourcesDTO
  
  let id: UUID = UUID()
  
  init(sourceDTO: DataSourcesDTO) {
    self.sourceDTO = sourceDTO
  }
  
  var name: String {
    return sourceDTO.name
  }
  
  var imageURL: URL? {
    guard let url = URL(string: sourceDTO.imageUrl) else {
      return nil
    }
    return url
  }
  
  var description: String {
    return sourceDTO.description
  }
  
  var isConnected: Bool {
    return sourceDTO.connected
  }
  
  var urlConnect: URL? {
    guard let url = URL(string: sourceDTO.authorizationURL ?? "") else {
      return nil
    }
    return url
  }
}
