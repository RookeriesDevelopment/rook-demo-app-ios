//
//  BodyViewModel.swift
//  RookAppleHealthDemo
//
//  Created by Francisco Guerrero Escamilla on 16/03/23.
//

import Foundation
import RookAppleHealth
import RookConnectTransmission
import RookAppleHealthExtraction

class BodyViewModel: ObservableObject {
  
  private let extractioManager = RookAHExtractionManager()
  private let permissionManager = RookAHPermissionManager()
  private let bodyTransmissionManager: RookBodyTransmissionManager = RookBodyTransmissionManager()
  
  var message: String = ""
  
  @Published var date: Date = Date()
  @Published var bodyData: RookBodyData?
  @Published var isLoading: Bool = false
  @Published var showMessage: Bool = false
  
  // MARK:  Helpers
  
  func requestBodyPermission() {
    self.isLoading = true
    permissionManager.requesBodyPermissions() { [weak self] result in
      DispatchQueue.main.async {
        self?.isLoading = false
        switch result {
        case .success(let success):
          debugPrint(success)
        case .failure(let error):
          debugPrint(error)
        }
      }
    }
  }
  
  func getBodyData() {
    
    self.isLoading = true
    extractioManager.getBodySummary(date: date) { [weak self] result in
      
      DispatchQueue.main.async {
        switch result {
        case .success(let data):
          self?.bodyData = data
          debugPrint("body data \(data)")
        case .failure(let error):
          debugPrint("error while fecthing body \(error)")
        }
        self?.isLoading = false
      }
    }
  }
  
  func enqueBodySummary() {
    guard let data = self.bodyData?.getData() else {
      return
    }
    
    isLoading = true
    bodyTransmissionManager.enqueueBodySummary(with: data) { [weak self] result in
      DispatchQueue.main.async {
        self?.isLoading = false
        switch result {
        case .success(_):
          self?.message = "data was stored in local"
        case .failure(let error):
          self?.message = "Error while storing summary \(error)"
        }
        self?.showMessage = true
      }
    }
  }
  
  func transmitBodySummary() {
    isLoading = true
    bodyTransmissionManager.uploadBodySummaries() { [weak self] result in
      DispatchQueue.main.async {
        self?.isLoading = false
        switch result {
        case .success(_):
          self?.message = "Summary transmited."
        case .failure(let error):
          self?.message = "Error while transmiting summary \(error)"
        }
        self?.showMessage = true
      }
    }
  }
  
  func printSummariesStored() {
    isLoading = true
    bodyTransmissionManager.getBodySummariesStored() { [weak self] result in
      DispatchQueue.main.async {
        self?.isLoading = false
        switch result {
        case .success(let data):
          self?.message = "summaries stored in local \(data.count)"
          self?.showMessage = true
        case .failure(let error):
          self?.message = "error \(error)"
          self?.showMessage = true
        }
      }
    }
  }
  
}
