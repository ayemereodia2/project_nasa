//
//  ContentView.swift
//  Nasa
//
//  Created by DAVID ODIA on 13/10/2023.
//

import SwiftUI

struct MainPhotoView: View {
  // MARK: - properties
  @StateObject var viewModel: PhotoViewModel = PhotoViewModel()
  private let titleAnimationDuration: TimeInterval = 0.35
  
  var body: some View {
    GeometryReader { proxy in
      let halfHeight = proxy.size.height * 0.5
      
      VStack(spacing: 16) {
          if viewModel.isFullScreen {
            PhotoView(viewModel: viewModel)
              .transition(
                .expand(
                  from: CGSize(width: .infinity, height: halfHeight),
                  to: CGSize(width: .infinity, height: proxy.size.height)
                )
              )
            
          } else {
            PhotoView(viewModel: viewModel)
              .transition(
                .expand(
                  from: CGSize(width: .infinity, height: proxy.size.height),
                  to: CGSize(width: .infinity, height: halfHeight)
                )
              )
          }
        
        if viewModel.shouldShowTitle {
          bottomTitle
        }
      }
      .task {
        await viewModel.fetchPhoto()
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .alert(viewModel.errorTitle, isPresented: $viewModel.showErrorMessage) {
        dismissButton
        tryAgainButton
      } message: {
        Text(viewModel.errorMessage)
      }
    }
  }
  
  // MARK: - tryAgain Button
  @ViewBuilder
  var tryAgainButton: some View {
    Button(viewModel.tryAgainButtonTitle, role: .destructive) {
      Task {
        await viewModel.fetchPhoto()
      }
    }
  }
  
  // MARK: - Ok Button
  @ViewBuilder
  var dismissButton: some View {
    Button(viewModel.okButtonTitle, role: .cancel) {
      viewModel.dismiss()
    }
  }
  
  // MARK: - Bottom Image Title
  @ViewBuilder
  var bottomTitle: some View {
    Text(viewModel.imageTitle)
      .multilineTextAlignment(.center)
      .padding(.horizontal)
      .padding(.bottom, 20)
      .transition(.opacity.combined(with: .move(edge: .bottom)))
  }
}
