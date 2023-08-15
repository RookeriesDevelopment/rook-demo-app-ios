//
//  PhysicalView.swift
//  RookAHAppDemo
//
//  Created by Francisco Guerrero Escamilla on 06/03/23.
//

import SwiftUI
import RookAppleHealth

struct PhysicalView: View {
  
  @StateObject var viewModel: PhysicalViewModel = PhysicalViewModel()
  
  var body: some View {
    VStack {
      
      Text("Physical")
        .font(.system(size: 24, weight: .bold))
        .padding(12)
      
      Button(action: {
        viewModel.requestPhysicalPermission()
      }, label: {
        Text("get physical Permissions")
      }).padding(20)
      
      DatePicker("date to fetch",
                 selection: $viewModel.date,
                 displayedComponents: .date)
      .pickerStyle(.wheel)
      .padding(8)
      
      Button(action: {
        viewModel.getPhysicalData()
      }, label: {
        Text("get physical summarie")
      })
      
      Button(action: {
        viewModel.enquePhysicalSummary()
      }, label: {
        Text("store summary")
      }).padding(10)
      
      Button(action: {
        viewModel.printSummariesStored()
      }, label: {
        Text("get summaries stored")
      }).padding(10)
      
      Button(action: {
        viewModel.transmitSleepSummary()
      }, label: {
        Text("send summaries")
      }).padding(10)
      
      PhysicalList(physicalData: viewModel.physicalData)
      
      Spacer()
    }
    .alert(isPresented: $viewModel.showMessage) {
      Alert(title: Text("Rook"),
            message: Text(viewModel.message),
            dismissButton: .default(Text("Ok")) {
        viewModel.showMessage = false
        viewModel.message = ""
      })
    }
  }
}

struct PhysicalList: View {
  
  var physicalData: RookPhysicalData?
  
  var body: some View {
    List {
      LazyVStack {
        Text("basal calories \(physicalData?.summaries.dailyActivityRelatedData.caloriesData.caloriesBasalMetabolicRateKilocalories ?? 0)")
        
        Text("active calories \(physicalData?.summaries.dailyActivityRelatedData.caloriesData.caloriesNetActiveKilocalories ?? 0)")
        
        Text("steps \(physicalData?.summaries.dailyActivityRelatedData.distanceData.stepsPerDayNumber ?? 0)")
        
        Text("hrv \(physicalData?.summaries.dailyActivityRelatedData.heartRateData.hrvAvgSdnnNumber ?? 0)")
        
        Text("max hr \(physicalData?.summaries.dailyActivityRelatedData.heartRateData.hrMaxBPM ?? 0)")
        
        Text("min hr \(physicalData?.summaries.dailyActivityRelatedData.heartRateData.hrMinimumBPM ?? 0)")
      }
    }
  }
}

struct PhysicalView_Previews: PreviewProvider {
  static var previews: some View {
    PhysicalView()
  }
}
