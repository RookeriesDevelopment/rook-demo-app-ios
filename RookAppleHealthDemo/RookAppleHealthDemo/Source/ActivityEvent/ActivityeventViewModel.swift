//
//  ActivityeventViewModel.swift
//  RookAHAppDemo
//
//  Created by Francisco Guerrero Escamilla on 16/07/23.
//

import Foundation

import Foundation
import RookAppleHealthExtraction
import RookTransmission
import RookConnectTransmission
import RookAppleHealth

class ActivityEventViewModel: ObservableObject {
  
  private let eventManager: RookAHEventExtractionManager = RookAHEventExtractionManager()
  private let eventTransmissionManager: ActivityEventTransmissionManager = ActivityEventTransmissionManager()
  
  @Published var date: Date = Date()
  @Published var activityEvents: [RookActivityEvent] = []
  
  // MARK:  Helpers
  
  func getLastExtractionDateTime() {
    guard let date: Date = eventManager.getLastExtractionDate(of: .activityEvent) else {
      return
    }
    
    debugPrint("last extraction activity \(date)")
  }
  
  
  func getActivityEvents() {
    eventManager.getActivityEvents(date: date) { [weak self] result in
      DispatchQueue.main.async {
      switch result {
        case .success(let events):
          self?.activityEvents = events
        case .failure(let failure):
          self?.activityEvents = []
          debugPrint("Error fetching event \(failure)")
        }
      }
    }
  }
  
  func storeEventsActivityEvent() {
    for event in activityEvents {
      guard let data = event.eventData else {
        continue
      }
      eventTransmissionManager.enqueActivityEvent(data) { result in
        switch result {
        case .success(let success):
          debugPrint("success enqueue events \(success)")
        case .failure(let failure):
          debugPrint(("failure enqueue event \(failure)"))
        }
      }
    }
  }
  
  func printEventsStored() {
    eventTransmissionManager.getActivityEvents { result in
      switch result {
      case .success(let events):
        debugPrint("event count \(events.count)")
        debugPrint("events info \(events)")
      case .failure(let failure):
        debugPrint("fail \(failure)")
      }
    }
  }
  
  func transmitEvents() {
    eventTransmissionManager.uploadEvents() { result in
      switch result {
      case .success(let success):
        debugPrint("success uploading \(success)")
      case .failure(let failure):
        debugPrint("failure uploading \(failure)")
      }
    }
  }
  
}
