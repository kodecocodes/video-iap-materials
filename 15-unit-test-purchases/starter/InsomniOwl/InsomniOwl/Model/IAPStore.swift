// Copyright (c) 2022 Razeware LLC
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
// distribute, sublicense, create a derivative work, and/or sell copies of the
// Software in any work that is designed, intended, or marketed for pedagogical or
// instructional purposes related to programming, coding, application development,
// or information technology.  Permission for such use, copying, modification,
// merger, publication, distribution, sublicensing, creation of derivative works,
// or sale is expressly withheld.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import StoreKit

final class IAPStore: ObservableObject {
  @Published private(set) var owls: [Owl]
  @Published private(set) var randomOwls: RandomOwls

  init() async throws {
    owls = try await .init()
    randomOwls = try await .init()
    task = Task.detached { [unowned self] in
      for await result in Transaction.updates {
        try? await processTransaction(result: result)
      }
    }
  }

  deinit {
    task.cancel()
  }

  private var task: Task<Void, Never>!
}

// MARK: - internal
extension IAPStore {
  func buy<Purchaseable: InsomniOwl.Purchaseable>(_ purchaseable: Purchaseable) async throws {
    if case .success(let result) = try await purchaseable.product.purchase() {
      try await processTransaction(result: result)
    }
  }

  func buyRandomOwl() {
    guard let randomOwl = (
      owls.enumerated()
        .filter { !$1.isPurchased }
        .randomElement()
    )
    else { return }

    owls[randomOwl.offset].isPurchased = true
    randomOwls.consumableCount -= 1
  }
}

// MARK: - private
@MainActor private extension IAPStore {
  func processTransaction(result: VerificationResult<Transaction>) throws {
    let transaction = try result.payloadValue
    switch transaction.productType {
    case .consumable:
      randomOwls.consumableCount += 3
    case .nonConsumable:
      owls[owls.firstIndex { $0.id == transaction.productID }!].isPurchased = true
    default:
      fatalError()
    }

    Task { await transaction.finish() }
  }
}
