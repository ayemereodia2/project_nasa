//
//  ContentView.swift
//  Nasa
//
//  Created by DAVID ODIA on 13/10/2023.
//

import SwiftUI
import Combine

struct MainPhotoView: View {
  @StateObject private var viewModel:PhotoViewModel
  @State private var isFullScreenVisible = false
  @State private var showTextAfter = false
  private let deviceSize = UIScreen.main.bounds.size
  private let duration = 0.35
  
  init(viewModel: PhotoViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel)
  }
  
  var body: some View {
    VStack(alignment: .center) {
      
      if isFullScreenVisible {
        PhotoFullView(viewModel: viewModel)
      } else {
        Spacer()
        PhotoView(viewModel: viewModel){
          showTextAfter = true
        }
        .frame(height: deviceSize.height / 2)
        .frame(maxWidth: .infinity)
        .transition(
          .expand(
            from: deviceSize,
            to: CGSize(width: .infinity, height: deviceSize.height / 2))
        )
        Spacer()
      }
      
      if showTextAfter && isFullScreenVisible == false {
        
        Text(viewModel.getImageTitle())
          .multilineTextAlignment(.center)
          .lineLimit(nil)
          .transition(.show(to: 0, animationDuration: duration))
        Spacer()
      }
    }
    .alert(viewModel.getErrorTitle(), isPresented: $viewModel.showErrorMessage) {
      
      Button(viewModel.okButtonTitle(), role: .cancel) {
        viewModel.hideProgressView()
      }
      
      Button(viewModel.tryAgainButtonTitle(), role: .destructive) {
        Task {
          await viewModel.fetchPhoto()
        }
      }
      
    }
  message: {
    Text(viewModel.getErrorMessage())
  }
  .overlay {
    if viewModel.showActivityIndicator {
      ProgressView()
    }
  }
  .onTapGesture {
    withAnimation {
      isFullScreenVisible.toggle()
    }
  }
  .task {
    await viewModel.fetchPhoto()
  }
    
  }
}


#Preview {
  MainPhotoView(viewModel: PhotoViewModel())
}
