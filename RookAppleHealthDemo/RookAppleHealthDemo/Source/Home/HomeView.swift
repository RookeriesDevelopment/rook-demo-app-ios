//
//  HomeView.swift
//  RookAHAppDemo
//
//  Created by Francisco Guerrero Escamilla on 06/03/23.
//

import SwiftUI
import RookConnectTransmission

struct HomeView: View {
  
  let user: String
  
  var body: some View {
    
    VStack {
      Text(user)
        .font(.system(size: 24, weight: .bold))
      
      Spacer()
      
      List {
        
        NavigationLink(destination: {
          DataSourcesView()
        }, label: {
          Text("Data Sources Page")
        })
        
        NavigationLink(destination: {
          SleepView()
        }, label: {
          Text("Sleep")
        })
        
        NavigationLink(destination: {
          PhysicalView()
        }, label: {
          Text("Physical")
        })
        
        NavigationLink(destination: {
          BodyView()
        }, label: {
          Text("Body")
        })
        
        NavigationLink(destination: {
          EventHrView()
        }, label: {
          Text("Hr Events")
        })
        
        NavigationLink(destination: {
          EventOxygenationView()
        }, label: {
          Text("Oxygenation Events")
        })
        
        NavigationLink(destination: {
          ActivityEventView()
        }, label: {
          Text("Activity Events")
        })
        
      }
    }
    .onAppear() {
    }
  }
}
