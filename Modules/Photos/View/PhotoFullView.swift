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
    VStack() {
      PhotoView(viewModel: viewModel)
      .transition(
        .expand(
          from: CGSize(width: .infinity, height: deviceSize.height / 2),
          to: UIScreen.main.bounds.size
        )
      )
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      
      Text(viewModel.imageTitle)
        .multilineTextAlignment(.center)
        .transition(.show(to: 0, animationDuration: duration))
        .background(Color.clear)
        .frame(maxWidth: .infinity, alignment: .center)
    }
  }
}

#Preview {
  PhotoFullView(viewModel: PhotoViewModel())
}
