//
//  EventHrView.swift
//  RookAHAppDemo
//
//  Created by Francisco Guerrero Escamilla on 16/06/23.
//

import SwiftUI
import RookAppleHealthExtraction
import Charts
import RookAppleHealth

struct EventHrView: View {
  
  @StateObject var viewModel: EventHrViewModel = EventHrViewModel()
  
  var body: some View {
    ScrollView {
      VStack {
        
        Text("Hr Events")
          .font(.system(size: 24, weight: .bold))
          .padding(12)
        
        DatePicker("date to fetch",
                   selection: $viewModel.date,
                   displayedComponents: .date)
        .pickerStyle(.wheel)
        .padding(8)
        
        HStack {
          Picker("Please choose a type", selection: $viewModel.selectedType) {
            ForEach(viewModel.eventTypes, id: \.self) {
              Text($0)
            }
          }
          Spacer()
          Text("\(viewModel.selectedType)")
        }
        
        Button(action: {
          viewModel.getHrEvents()
        }, label: {
          Text("Get Event")
            .foregroundColor(.white)
            .font(.system(size: 16, weight: .bold))
            .frame(width: 250, height: 50)
            .background(Color.red)
            .cornerRadius(12)
            .padding(21)
        })
        
        EventList(events: viewModel.hrEvents)
          .frame(height: 230)
        
        Button(action: {
          viewModel.storeEvents()
        }, label: {
          Text("store events")
            .foregroundColor(.white)
            .font(.system(size: 16, weight: .bold))
            .frame(width: 250, height: 50)
            .background(Color.red)
            .cornerRadius(12)
            .padding(21)
        })
        
        Button(action: {
          viewModel.getStoredEvents()
        }, label: {
          Text("get event stored")
            .foregroundColor(.white)
            .font(.system(size: 16, weight: .bold))
            .frame(width: 250, height: 50)
            .background(Color.red)
            .cornerRadius(12)
            .padding(21)
        }).padding(20)
        
        Button(action: {
          viewModel.uploadEvent()
        }, label: {
          Text("upload events")
            .foregroundColor(.white)
            .font(.system(size: 16, weight: .bold))
            .frame(width: 250, height: 50)
            .background(Color.red)
            .cornerRadius(12)
            .padding(21)
        }).padding(20)
        
        Spacer()
      }
      .padding(12)
      .onAppear {
        viewModel.getLastExtractionDateTime()
      }
    }
  }
}

struct EventList: View {
  
  var events: [RookHeartRateEvent] = []
  
  var body: some View {
    ScrollView(.horizontal) {
      HStack {
        ForEach(events, id: \.metadata.datetime) { event in
          VStack {
            Text("Hr max \(event.heartRateData.hrMaxBPM ?? 0)")
            
            Text("Hr avg \(event.heartRateData.hrAvgBPM ?? 0)")
            
            Text("Hr min \(event.heartRateData.hrMinimumBPM ?? 0)")
            
            Text("hrv min \(event.heartRateData.hrvAvgSdnnNumber ?? 0)")
            
            if #available(iOS 16.0, *) {
              Chart(event.heartRateData.hrGranularDataBPM ?? [], id: \.datetime) { granular in
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

struct EventHrView_Previews: PreviewProvider {
  static var previews: some View {
    EventHrView()
  }
}
