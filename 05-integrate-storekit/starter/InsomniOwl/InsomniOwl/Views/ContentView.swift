///// Copyright (c) 2020 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import SwiftUI

struct ContentView: View {
  private let owls = [Owl]()

  var body: some View {
    NavigationView {
      List(owls) { owl in
        ZStack {
          Owl.Row(owl: .constant(owl))

          NavigationLink(destination: OwlDLCView()) {
            EmptyView()
          }
          .frame(width: 0)
          .opacity(0)
        }
      }
      .navigationBarHidden(true)
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}

private extension Owl {
  struct Row: View {
    @Binding var owl: Owl

    var body: some View {
      ProductRow(product: owl) {
        switch owl.isPurchased {
        case true:
          OwnedView()
        case false:
          PurchaseButton(purchasable: owl)
        }
      }
    }
  }
}

private struct ProductRow<TrailingView: View>: View {
  let product: Owl
  @ViewBuilder let trailingView: () -> TrailingView

  var body: some View {
    HStack {
      VStack(alignment: .leading, spacing: nil) {
        Text(product.name)
      }
      Spacer()
      trailingView()
    }
    .padding()
  }
}

private struct OwnedView: View {
  @Environment(\.colorScheme) private var colorScheme

  var body: some View {
    Image(systemName: "checkmark")
      .padding(10)
      .foregroundColor(colorScheme == .light ? .black : .white)
      .overlay(
        Circle()
          .stroke(
            colorScheme == .light ? Color.black : .white,
            lineWidth: 2
          )
      )
  }
}

private struct PurchaseButton: View {
  let purchasable: Owl

  var body: some View {
    Button {
      print("buy product")
    } label: {
      HStack {
        Image(systemName: "cart")
        Text("Buy")
      }
    }
    .buttonStyle(.plain)
    .padding(10)
    .foregroundColor(.yellow)
    .overlay(
      RoundedRectangle(cornerRadius: 20)
        .stroke(Color.yellow, lineWidth: 2)
    )
  }
}
