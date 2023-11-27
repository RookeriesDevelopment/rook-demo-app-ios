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
    
    RookAHConfiguration.shared.setClientUUID(with: "")//YOUR CLEINT UUID
    RookAHConfiguration.shared.setEnvironment(.sandbox)
    
    let transmissionConfiguration: RookTransmissionConfiguration = RookTransmissionConfiguration(
      clientUUID: "",//YOUR CLEINT UUID
      secretKey: "")// YOUR SECRET KEY
    
    
    TransmissionSettings.shared.setConfiguration(transmissionConfiguration)
    TransmissionSettings.shared.setEnvironment(.sandbox)
    
    RookUserConfiguration.shared.setConfiguration(
      clientUUID: "",//YOUR CLEINT UUID
      secretKey: "")// YOUR SECRET KEY
    RookUserConfiguration.shared.setEnvironment(.sandbox)
    
    RookAHConfiguration.shared.initRookAH()
    TransmissionSettings.shared.initRookTransmission()
    RookUserConfiguration.shared.initRookUsers() { _ in
    }
    return true
  }
}
