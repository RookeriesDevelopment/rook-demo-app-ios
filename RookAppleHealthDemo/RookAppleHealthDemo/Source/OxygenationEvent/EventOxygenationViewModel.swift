//
//  EventOxygenationViewModel.swift
//  RookAHAppDemo
//
//  Created by Francisco Guerrero Escamilla on 27/06/23.
//

import Foundation
import RookAppleHealth
import RookAppleHealthExtraction
import RookTransmission

class EventOxygenationViewModel: ObservableObject {
  
  private let eventManager: RookAHEventExtractionManager = RookAHEventExtractionManager()
  private let oxygenationEventTransmisionManager: OxygenationEventTransmissionManager = OxygenationEventTransmissionManager()
  
  @Published var date: Date = Date()
  @Published var  oxygenationEvents: [RookOxygentationEvent] = []
  
  var eventTypes = ["Body", "Physical"]
  @Published var selectedType = "Body"
  
  // MARK:  Helpers
  
  func getLastExtractionDateTime() {
    let dateBody: Date? = eventManager.getLastExtractionDate(of: .oxygenationBodyEvent)
    let datePhysical: Date? = eventManager.getLastExtractionDate(of: .oxygenationPhysicalEvent)
    
    debugPrint("last extraction activity \(dateBody)")
    debugPrint("last extraction activity \(datePhysical)")
  }
  
  func getOxygenationEvents() {
    if selectedType == "Body" {
      getSaturationBodyEvents()
    } else {
      getSaturationPhysicalEvents()
    }
  }
  
  private func getSaturationBodyEvents() {
    eventManager.getBodyOxygenationEvents(date: date) { [weak self] result in
      DispatchQueue.main.async {
      switch result {
        case .success(let events):
          self?.oxygenationEvents = events
        case .failure(let failure):
          self?.oxygenationEvents = []
          debugPrint("Error fetching event \(failure)")
        }
      }
    }
  }
  
  private func getSaturationPhysicalEvents() {
    eventManager.getPhysicalOxygenationEvents(date: date) { [weak self] result in
      DispatchQueue.main.async {
      switch result {
        case .success(let events):
          self?.oxygenationEvents = events
        case .failure(let failure):
          self?.oxygenationEvents = []
          debugPrint("Error fetching event \(failure)")
        }
      }
    }
  }
  
  func storeEvents() {
    for event in oxygenationEvents {
      guard let data = event.dataEvent else { continue }
      oxygenationEventTransmisionManager.enqueueOxygenationEvent(data) { result in
        switch result {
        case .success(let success):
          debugPrint("stored \(success)")
        case .failure(let failure):
          debugPrint("error while storing \(failure)")
        }
      }
    }
  }
  
  func getStoredEvents() {
    oxygenationEventTransmisionManager.getBodyOxygenationEvents { result in
      switch result {
      case .success(let events):
        debugPrint(" events stored \(events.count)")
      case .failure(let failure):
        debugPrint("Error \(failure)")
      }
    }
  }
  
  func uploadEvent() {
    oxygenationEventTransmisionManager.uploadEvent { result in
      
      switch result {
      case .success(let success):
        debugPrint("upload succesfully \(success)")
      case .failure(let failure):
        debugPrint("Errro while uploading \(failure)")
      }
      
    }
  }
  
}
