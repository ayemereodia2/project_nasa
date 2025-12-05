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
      VStack(alignment: .center) {
        // check cache
        if let image = viewModel.imageResult {
           image
            .resizable()
          
        } else {
          AsyncImage(url: URL(string: viewModel.result?.1 ?? "")) { phase in
            switch phase {
            case .success(let image):
              image
                .resizable()
                .onAppear {
                  Task {
                    await viewModel.cacheImage(url: viewModel.result?.1 ?? "", image: image)
                  }
                }
            default:
              ProgressView()
            }
          }
        }
      }
      .task {
       await viewModel.fetchPhoto()
      }
      .onTapGesture {
        withAnimation(.spring()) {
          viewModel.fullScreen()
        }
      }
  }
}

#Preview {
  PhotoView(viewModel: PhotoViewModel())
}
