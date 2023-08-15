//
//  NetworkManager.swift
//  RookMotionFrancisco
//
//  Created by Francisco Guerrero Escamilla on 08/03/21.
//

import Foundation
import Combine
import RookAppleHealthExtraction

public enum NetworkResponse: String {
  case success
}

enum ErrorNetworking: String, Error {
  case invalidData
  case authenticationError = "You need to be authenticated first."
  case badRequest = "Bad request"
  case outdated = "The url you requested is outdated."
  case failed = "Network request failed."
  case noData = "Response returned with no data to decode."
  case unableToDecode = "We could not decode the response."
}

fileprivate enum ResultAPI<String> {
  case success
  case exception(String)
  case failure(Error)
}

public struct NetworkManager<T: EndPointType> {
  private let router = Router<T>()
  
  public init() {
    
  }
  
  private func handleNetworkResponse(_ response: HTTPURLResponse) -> ResultAPI<String> {
    switch response.statusCode {
    case 200...299: return .success
    case 300...399: return .exception(response.description)
    case 401...408: return .exception(ErrorNetworking.authenticationError.rawValue)
    case 409: return .exception("info duplicated")
    case 410...421: return .failure(ErrorNetworking.authenticationError)
    case 422: return  .exception(response.description)
    case 423...500: return .failure(ErrorNetworking.authenticationError)
    case 501...599: return .failure(ErrorNetworking.badRequest)
    case 600: return .failure(ErrorNetworking.outdated)
    case -1009: return .exception("time out")
    default: return .failure(ErrorNetworking.failed)
    }
  }
  
  private func decode<Object: Decodable>(data: Data?, response: URLResponse?) throws -> Object {
    if let response = response as? HTTPURLResponse {
      let result = self.handleNetworkResponse(response)
      switch result {
      case .success:
        guard let responseData = data else {
          throw ErrorNetworking.invalidData
        }
        do {
          let apiResponse = try JSONDecoder().decode(Object.self, from: responseData)
          return apiResponse
        } catch {
          throw error
        }
      case .exception( _):
        guard let responseData = data else {
          throw ErrorNetworking.invalidData
        }
        do {
          let apiResponse = try JSONDecoder().decode(Object.self, from: responseData)
          return apiResponse
        } catch {
          throw error
        }
      case .failure(let networkFailureError):
        throw networkFailureError
      }
    } else {
      throw ErrorNetworking.invalidData
    }
  }
}

extension NetworkManager where T == DataSourceEndPoint {
  
  func getDataSourcesAvailable<T: Decodable>(for userId: String) -> AnyPublisher<T, Error> {
    self.router.request(.getDataSources(clientUUID: "9593d0ec-47c1-4477-a8ce-10d3f4f43127",
                                        userId: userId))
    .tryMap { response -> T in
      let result: T = try self.decode(data: response.data,
                                      response: response.response)
      return result
    }.mapError({ error in
      return error
    }).receive(on: DispatchQueue.main).eraseToAnyPublisher()
  }
}
