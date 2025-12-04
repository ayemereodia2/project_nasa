//
//  PhotoView.swift
//  Nasa
//
//  Created by DAVID ODIA on 14/10/2023.
//

import SwiftUI

struct PhotoView: View {
  @ObservedObject var viewModel: PhotoViewModel
  
  var body: some View {
    // handle only image
    if let content = viewModel.getContentUrl(),
       content.0 == .imageForm, let url = content.1 {
      VStack(alignment: .center) {
        // check cache
        if let image = viewModel.getImage(url: url) {
           image
            .resizable()
          
        } else {
          AsyncImage(url: URL(string: url)) { phase in
            switch phase {
            case .success(let image):
              image
                .resizable()
                .onAppear {
                  viewModel.storeImage(url: url, image: image)
                }
            default:
              ProgressView()
            }
          }
        }
      }
      .onTapGesture {
        withAnimation(.spring()) {
          viewModel.fullScreen()
        }
      }
    } else {
      // check for video and create video player
    }
  }
}

#Preview {
  PhotoView(viewModel: PhotoViewModel())
}
