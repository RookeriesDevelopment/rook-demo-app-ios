//
//  DataSourceResponseDTO.swift
//  RookAppleHealthDemo
//
//  Created by Francisco Guerrero Escamilla on 12/07/23.
//

import Foundation

struct DataSourceResponseDTO: Decodable {
  let clienteName: String
  let theme: String
  let dataSources: [DataSourcesDTO]
  
  enum CodingKeys: String, CodingKey {
    case clienteName = "client_name"
    case theme
    case dataSources = "data_sources"
  }
}

struct DataSourcesDTO: Decodable {
  let name: String
  let description: String
  let imageUrl: String
  let connected: Bool
  let authorizationURL: String?
  
  enum CodingKeys: String, CodingKey {
    case name
    case description
    case imageUrl = "image"
    case connected
    case authorizationURL = "authorization_url"
  }
}
