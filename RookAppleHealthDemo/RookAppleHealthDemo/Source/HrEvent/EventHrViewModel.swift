//
//  EventHrViewModel.swift
//  RookAHAppDemo
//
//  Created by Francisco Guerrero Escamilla on 16/06/23.
//

import Foundation
import RookAppleHealthExtraction
import RookTransmission
import RookConnectTransmission
import RookAppleHealth

final class EventHrViewModel: ObservableObject {
  
  // MARK:  Properties
  
  private let eventManager: RookAHEventExtractionManager = RookAHEventExtractionManager()
  private let evenetTransmissionManager: HeartRateEventTransmissionManager = HeartRateEventTransmissionManager()
  
  @Published var date: Date = Date()
  @Published var hrEvents: [RookHeartRateEvent] = []
  
  var eventTypes = ["Body", "Physical"]
  @Published var selectedType = "Body"
  
  // MARK:  Helpers
  
  func getLastExtractionDateTime() {
    let dateBody: Date? = eventManager.getLastExtractionDate(of: .heartRateBodyEvent)
    let datePhysical: Date? = eventManager.getLastExtractionDate(of: .heartRatePhysicalEvent)
    
    debugPrint("last extraction activity \(dateBody)")
    debugPrint("last extraction activity \(datePhysical)")
  }
  
  func getHrEvents() {
    if selectedType == "Body" {
      getHrBodyEvents()
    } else {
      getHrPhysicalEvents()
    }
  }
  
  private func getHrBodyEvents() {
    eventManager.getBodyHeartRateEvents(date: date) { [weak self] result in
      DispatchQueue.main.async {
      switch result {
        case .success(let events):
          self?.hrEvents = events
        case .failure(let failure):
          self?.hrEvents = []
          debugPrint("Error fetching event \(failure)")
        }
      }
    }
  }
  
  private func getHrPhysicalEvents() {
    eventManager.getPhysicalHeartRateEvents(date: date) { [weak self] result in
      DispatchQueue.main.async {
      switch result {
        case .success(let events):
          self?.hrEvents = events
        case .failure(let failure):
          self?.hrEvents = []
          debugPrint("Error fetching event \(failure)")
        }
      }
    }
  }
  
  func storeEvents() {
    for event in hrEvents {
      guard let data = event.dataEvent else { continue }
      evenetTransmissionManager.enqueueHrEvent(data) { result in
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
    evenetTransmissionManager.getHrEventsStored { result in
      switch result {
      case .success(let events):
        debugPrint(" events stored \(events.count)")
      case .failure(let failure):
        debugPrint("Error \(failure)")
      }
    }
    
    evenetTransmissionManager.getBodyHrEventsStored { result in
      switch result {
      case .success(let events):
        debugPrint(" events stored \(events.count)")
      case .failure(let failure):
        debugPrint("Error \(failure)")
        
      }
    }
  }
  
  func uploadEvent() {
    evenetTransmissionManager.uploadHrEvents { result in
      
      switch result {
      case .success(let success):
        debugPrint("upload succesfully \(success)")
      case .failure(let failure):
        debugPrint("Errro while uploading \(failure)")
      }
      
    }
  }
  
}
