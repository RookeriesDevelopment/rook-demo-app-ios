//
//  AppDelegate.swift
//  RookAppleHealthDemo
//
//  Created by Francisco Guerrero Escamilla on 10/03/23.
//

import Foundation
import UIKit
import RookAppleHealthExtraction
import RookConnectTransmission
import RookTransmission
import RookUserSDK

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    
    RookAHConfiguration.shared.setClientUUID(with: "9593d0ec-47c1-4477-a8ce-10d3f4f43127")
    
    let transmissionConfiguration: RookTransmissionConfiguration = RookTransmissionConfiguration(
      urlAPI: "https://api.rook-connect.dev",
      clientUUID: "9593d0ec-47c1-4477-a8ce-10d3f4f43127",
      secretKey: "YR9GoQ3mP0zey5nZ9w3WHQMvtvFvMdnefblx")
    
    
    TransmissionSettings.shared.setConfiguration(transmissionConfiguration)
    
    RookUserConfiguration.shared.setConfiguration(urlAPI: "https://api.rook-connect.dev",
                                                  clientUUID: "9593d0ec-47c1-4477-a8ce-10d3f4f43127",
                                                  secretKey: "YR9GoQ3mP0zey5nZ9w3WHQMvtvFvMdn")
    
    RookAHConfiguration.shared.initRookAH()
    TransmissionSettings.shared.initRookTransmission()
    RookUserConfiguration.shared.initRookUsers() { _ in
    }
    return true
  }
}
