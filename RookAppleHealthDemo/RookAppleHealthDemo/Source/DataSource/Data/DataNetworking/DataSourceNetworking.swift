//
//  DataSourceNetworking.swift
//  RookAppleHealthDemo
//
//  Created by Francisco Guerrero Escamilla on 12/07/23.
//

import Foundation
import Combine

class DataSourceNetworking {
  
  // MARK:  Properties
  
  let networkManager: NetworkManager<DataSourceEndPoint> = NetworkManager<DataSourceEndPoint>()
  
  // MARK:  Helpers
  
  func getDataSources(for userId: String) -> AnyPublisher<DataSourceResponseDTO, Error> {
    let cancelable: AnyPublisher<DataSourceResponseDTO, Error> = networkManager.getDataSourcesAvailable(for: userId)
    return cancelable
      .mapError({ error in
        error as Error
      })
      .eraseToAnyPublisher()
  }
  
}
