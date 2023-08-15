//
//  SleepView.swift
//  RookAHAppDemo
//
//  Created by Francisco Guerrero Escamilla on 10/03/23.
//

import SwiftUI
import RookAppleHealth

struct SleepView: View {
  
  @StateObject var sleepVM: SleepViewModel = SleepViewModel()
  
  var body: some View {
    
    if (sleepVM.isLoading) {
      ProgressView()
        .foregroundColor(.red)
        .progressViewStyle(.circular)
    } else {
      VStack {
        
        Text("Sleep")
          .font(.system(size: 24, weight: .bold))
          .padding(12)
        
        Button(action: {
          sleepVM.getSleepPermissions()
        }, label: {
          Text("get Sleep Permissions")
        }).padding(20)
        
        DatePicker("date to fetch",
                   selection: $sleepVM.date,
                   displayedComponents: .date)
        .pickerStyle(.wheel)
        .padding(8)
        
        Button(action: {
          sleepVM.getSleepData()
        }, label: {
          Text("get sleep summary")
        }).padding(10)
        
        Button(action: {
          sleepVM.enqueSleepSummary()
        }, label: {
          Text("store summary")
        }).padding(10)
        
        Button(action: {
          sleepVM.printSummariesStored()
        }, label: {
          Text("get summaries stored")
        }).padding(10)
        
        Button(action: {
          sleepVM.transmitSleepSummary()
        }, label: {
          Text("send summaries")
        }).padding(10)
        
        List {
          LazyVStack {
            
            Text("Sleep duration \(sleepVM.sleepData?.summaries.sleepRelatedData.sleepDurationRelatedData.sleepDurationSeconds ?? 0)")
            
            Text("Sleep deep duration \(sleepVM.sleepData?.summaries.sleepRelatedData.sleepDurationRelatedData.deepSleepDurationSeconds ?? 0)")
            
            Text("Sleep ligth duration \(sleepVM.sleepData?.summaries.sleepRelatedData.sleepDurationRelatedData.lightSleepDurationSeconds ?? 0)")
            
            Text("Sleep rem duration \(sleepVM.sleepData?.summaries.sleepRelatedData.sleepDurationRelatedData.remSleepDurationSeconds ?? 0)")
          }
        }
        
        Spacer()
      }.alert(isPresented: $sleepVM.showMessage) {
        Alert(title: Text("Rook"),
              message: Text(sleepVM.message),
              dismissButton: .default(Text("Ok")) {
          sleepVM.showMessage = false
          sleepVM.message = ""
        })
      }
    }
  }
}

struct SleepView_Previews: PreviewProvider {
  static var previews: some View {
    SleepView()
  }
}
