//
//  SleepViewModel.swift
//  RookAppleHealthDemo
//
//  Created by Francisco Guerrero Escamilla on 16/03/23.
//

import Foundation
import RookAppleHealth
import RookConnectTransmission

class SleepViewModel: ObservableObject {
  
  
  // MARK:  Properties
  
  private let extractioManager = RookExtractionManager()
  private let sleepTransmissionManager: RookSleepTransmissionManager = RookSleepTransmissionManager()
  
  var message: String = ""
  
  @Published var date: Date = Date()
  @Published var sleepData: RookSleepData?
  @Published var isLoading: Bool = false
  @Published var showMessage: Bool = false
  
  // MARK:  Helpers
  
  func getSleepData() {
    isLoading = true
    extractioManager.getSleepSummary(date: date) { [weak self] result in
      DispatchQueue.main.async {
        switch result {
        case .success(let data):
          self?.sleepData = data
          debugPrint("sleep data \(data)")
        case .failure(let error):
          debugPrint("error while fecthing sleep \(error)")
        }
        self?.isLoading = false
      }
    }
  }
  
  func getSleepPermissions() {
    isLoading = true
    let permissionManager = RookPermissionExtraction()
    permissionManager.requestSleepPermissions() { [weak self] _ in
      DispatchQueue.main.async {
        self?.isLoading = false
      }
    }
  }
  
  func enqueSleepSummary() {
    guard let data = self.sleepData?.getData() else {
      return
    }
    
    self.isLoading = true
    sleepTransmissionManager.enqueueSleepSummary(with: data) { [weak self] result in
      DispatchQueue.main.async {
        self?.isLoading = false
        switch result {
        case .success(_):
          self?.message = "Summary stored."
        case .failure(let error):
          self?.message = "Error while storing summary \(error)"
        }
        self?.showMessage = true
      }
      
    }
  }
  
  func transmitSleepSummary() {
    isLoading = true
    sleepTransmissionManager.uploadSleepSummaries() { [weak self] result in
      
      DispatchQueue.main .async {
        switch result {
        case .success(let bool):
          debugPrint(bool)
          self?.message = "Summary transmited."
        case .failure(let error):
          debugPrint(error)
          self?.message = "Error while transmiting summary"
        }
        self?.isLoading = false
        self?.showMessage = true
      }
    }
  }
  
  func printSummariesStored() {
    isLoading = true
    sleepTransmissionManager.getSleepSummariesStored() { [weak self] result in
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
