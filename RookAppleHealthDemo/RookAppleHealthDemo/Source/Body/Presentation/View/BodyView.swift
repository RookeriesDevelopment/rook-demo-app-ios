//
//  BodyView.swift
//  RookAHAppDemo
//
//  Created by Francisco Guerrero Escamilla on 10/03/23.
//

import SwiftUI
import RookAppleHealth

struct BodyView: View {
  
  @StateObject var viewModel: BodyViewModel = BodyViewModel()
  
  var body: some View {
    
    if (viewModel.isLoading) {
      ProgressView()
    } else {
      VStack {
        Text("Body")
          .font(.system(size: 24, weight: .bold))
          .padding(12)
        
        Button(action: {
          viewModel.requestBodyPermission()
        }, label: {
          Text("Get body Permissions")
        }).padding(20)
        
        DatePicker("date to fetch",
                   selection: $viewModel.date,
                   displayedComponents: .date)
        .pickerStyle(.wheel)
        .padding(8)
        
        Button(action: {
          viewModel.getBodyData()
        }, label: {
          Text("get Body summaries")
        })
        
        Button(action: {
          viewModel.enqueBodySummary()
        }, label: {
          Text("store summary")
        }).padding(10)
        
        Button(action: {
          viewModel.printSummariesStored()
        }, label: {
          Text("get summaries stored")
        }).padding(10)
        
        Button(action: {
          viewModel.transmitBodySummary()
        }, label: {
          Text("send summaries")
        }).padding(10)
        
        List {
          LazyVStack {
            Text("weight \(viewModel.bodyData?.summaries.bodyData.body.weightKgNumber ?? 0)")
            Text("height \(viewModel.bodyData?.summaries.bodyData.body.heightCMNumber ?? 0)")
          }
        }
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
}

struct BodyView_Previews: PreviewProvider {
  static var previews: some View {
    BodyView()
  }
}
