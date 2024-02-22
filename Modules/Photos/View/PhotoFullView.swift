//
//  PhotoFullView.swift
//  Nasa
//
//  Created by ANDELA on 14/10/2023.
//

import SwiftUI

struct PhotoFullView: View {
  @ObservedObject var viewModel: PhotoViewModel
  private let deviceSize = UIScreen.main.bounds.size
  private let duration = 0.35

  var body: some View {
    ZStack(alignment: .bottom) {
      GeometryReader{ geometry in
        PhotoView(viewModel: viewModel){}
        .transition(
          .expand(
            from: CGSize(width: .infinity, height: deviceSize.height / 2),
            to: geometry.size)
        )
      }
      
      Text(viewModel.getImageTitle())
        .multilineTextAlignment(.center)
        .lineLimit(nil)
        .transition(.show(to: 0, animationDuration: duration))
    }
  }
}

#Preview {
  PhotoFullView(viewModel: PhotoViewModel())
}
