//
//  RookAppleHealthDemoApp.swift
//  RookAppleHealthDemo
//
//  Created by Francisco Guerrero Escamilla on 10/03/23.
//

import SwiftUI
import RookAppleHealthExtraction

@main
struct RookAppleHealthDemoApp: App {
  
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  
  var body: some Scene {
    WindowGroup {
      UserView()
    }
  }
}
