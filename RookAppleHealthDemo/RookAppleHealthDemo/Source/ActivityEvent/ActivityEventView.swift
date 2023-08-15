//
//  ActivityEventView.swift
//  RookAHAppDemo
//
//  Created by Francisco Guerrero Escamilla on 16/07/23.
//

import SwiftUI
import RookAppleHealthExtraction
import Charts
import RookAppleHealth

struct ActivityEventView: View {
  
  @StateObject var viewModel: ActivityEventViewModel = ActivityEventViewModel()
  
  var body: some View {
    ScrollView {
      VStack {
        
        Text("Activity Events")
          .font(.system(size: 24, weight: .bold))
          .padding(12)
        
        DatePicker("date to fetch",
                   selection: $viewModel.date,
                   displayedComponents: .date)
        .pickerStyle(.wheel)
        .padding(8)
        
        Button(action: {
          viewModel.getActivityEvents()
        }, label: {
          Text("Get Events")
            .foregroundColor(.white)
            .font(.system(size: 16, weight: .bold))
            .frame(width: 250, height: 50)
            .background(Color.red)
            .cornerRadius(12)
            .padding(21)
        })
        
        ActivityEventList(events: viewModel.activityEvents)
          .frame(height: 230)
        
        Button(action: {
          viewModel.storeEventsActivityEvent()
        }, label: {
          Text("Store activity events")
        })
        .padding(20)
        
        Button(action: {
          viewModel.printEventsStored()
        }, label: {
          Text("print activity events")
        })
        .padding(20)
        
        Button(action: {
          viewModel.transmitEvents()
        }, label: {
          Text("upload Body summaries")
        })
        .padding(20)
        
      }
      .padding(12)
      .onAppear {
        viewModel.getLastExtractionDateTime()
      }
    }
  }
}

struct ActivityEventList: View {
  
  var events: [RookActivityEvent] = []
  
  var body: some View {
    ScrollView(.horizontal) {
      HStack {
        ForEach(events, id: \.metadata.datetime) { event in
          VStack {
            
            Text("duration \(event.activityData?.activityDurationSeconds ?? 0)")
            Text("type name \(event.activityData?.activityTypeName ?? "S/N")")
            
            if #available(iOS 16.0, *) {
              Chart(event.heartRateData?.hrGranularDataBPM ?? [], id: \.datetime) { granular in
                RectangleMark(
                  x: .value("time",
                            "\(granular.datetime)"),
                  y: .value("BPM",
                            granular.bpm)
                )
              }
            }
          }
          .frame(width: 350)
        }
      }
    }
  }
}
