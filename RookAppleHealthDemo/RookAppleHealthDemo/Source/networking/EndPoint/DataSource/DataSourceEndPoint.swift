//
//  DataSourceEndPoint.swift
//  RookAppleHealthDemo
//
//  Created by Francisco Guerrero Escamilla on 12/07/23.
//

import Foundation

enum DataSourceEndPoint {
  case getDataSources(clientUUID: String, userId: String)
}

extension DataSourceEndPoint: EndPointType {
  var baseUrl: URL? {
    guard let url: URL = URL(string: "https://api.rook-connect.dev") else {
      return nil
    }
    return  url
  }
  
  var path: String {
    switch self {
    case .getDataSources(let clientUUID, let userId):
      return "/api/v1/client_uuid/\(clientUUID)/user_id/\(userId)/configuration"
    }
  }
  
  var httpMethod: HTTPMethod {
    switch self {
    case .getDataSources:
      return .get
    }
  }
  
  var task: HTTPTask {
    switch self {
    case .getDataSources:
      return .request
    }
  }
  
  var headers: HTTPHeaders? {
    return nil
  }
  
  
}
