//
//  PhysicalViewModel.swift
//  RookAppleHealthDemo
//
//  Created by Francisco Guerrero Escamilla on 16/03/23.
//

import Foundation
import RookConnectTransmission
import RookAppleHealthExtraction
import RookAppleHealth

class PhysicalViewModel: ObservableObject {
  
  // MARK:  Properties
  
  private let extractioManager: RookAHExtractionManager = RookAHExtractionManager()
  private let permissionManager: RookAHPermissionManager = RookAHPermissionManager()
  private let physicalTransmissionManager: RookPhysicalTransmissionManager = RookPhysicalTransmissionManager()
  
  var message: String = ""
  
  @Published var date: Date = Date()
  @Published var physicalData: RookPhysicalData?
  @Published var isLoading: Bool = false
  @Published var showMessage: Bool = false
  
  // MARK:  Helpers
  
  func requestPhysicalPermission() {
    self.isLoading = true
    permissionManager.requestPhysicalPermissions() { [weak self] _ in
      DispatchQueue.main.async {
        self?.isLoading = false
      }
    }
  }
  
  func getPhysicalData() {
    isLoading = true
    extractioManager.getPhysicalSummary(date: date) { [weak self] result in
      
      DispatchQueue.main.async {
        switch result {
        case .success(let data):
          self?.physicalData = data
          debugPrint("physical data \(data)")
        case .failure(let error):
          debugPrint("error while fecthing physical \(error)")
        }
        self?.isLoading = false
      }
    }
  }
  
  func enquePhysicalSummary() {
    guard let data = self.physicalData?.getData() else {
      return
    }
    self.isLoading = true
    physicalTransmissionManager.enqueuePhysicalSummary(with: data) { [weak self] result in
      DispatchQueue.main.async {
        switch result {
        case .success(_):
          self?.message = "data was stored in local"
        case .failure(let error):
          self?.message = "Error while storing summary \(error)"
        }
        self?.isLoading = false
        self?.showMessage = true
      }
    }
  }
  
  func transmitSleepSummary() {
    isLoading = true
    physicalTransmissionManager.uploadPhysicalSummaries() { [weak self] result in
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
    isLoading = false
    physicalTransmissionManager.getPhysicalSummariesStored() { [weak self] result in
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
