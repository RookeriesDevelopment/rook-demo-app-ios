//
//  ButtonSourceView.swift
//  RookAppleHealthDemo
//
//  Created by Francisco Guerrero Escamilla on 13/07/23.
//

import SwiftUI

struct ButtonSourceView: View {
  
  // MARK:  Properties
  
  private let viewModel: SourceItemViewModel
  
  // MARK:  Inti
  
  init(viewModel: SourceItemViewModel) {
    self.viewModel = viewModel
  }
  
  // MARK:  Helpers
  
  var body: some View {
    HStack {
      if #available(iOS 15.0, *) {
        AsyncImage(
          url: viewModel.imageURL) { image in
            image.resizable()
          } placeholder: {
            ProgressView()
          }
          .frame(width: 50, height: 50)
      }
      
      VStack(alignment: .leading) {
        Text(viewModel.name)
          .font(.system(size: 18, weight: .bold))
        
        Text(viewModel.description)
          .font(.system(size: 16))
          .lineLimit(3)
        
      }
      
      Text("\(viewModel.isConnected ? "Connected" : "Connect")")
        .font(.system(size: 12, weight: .semibold))
        .padding(4)
        .background( viewModel.isConnected ? Color.green.opacity(0.3) : Color.gray.opacity(0.3) )
        .cornerRadius(5)
    }
    .frame(maxWidth: .infinity)
    .padding(8)
    .border(.black)
    
  }
}

struct ButtonSourceView_Previews: PreviewProvider {
  static var previews: some View {
    ButtonSourceView(
      viewModel: SourceItemViewModel(
        sourceDTO: DataSourcesDTO(
          name: "Polar",
          description: "Polar Flow allows you to analyze sports activity and fitness and is used with GPS-enabled heart rate monitors, fitness devices and activity trackers from Polar.* Track your training and activity and instantly see your achievements. You can view all your training and activity data on your phone on the go and wireless sync it to the Polar Flow service",
          imageUrl: "https://api-media-root.s3.us-east-2.amazonaws.com/static/img/polar.png",
          connected: false,
          authorizationURL: "https://flow.polar.com/oauth2/authorization?response_type=code&client_id=29e84950-123f-4a96-b740-0d49e47a2184&state=paco%40rookmotion.com-f693af4d")))
  }
}
