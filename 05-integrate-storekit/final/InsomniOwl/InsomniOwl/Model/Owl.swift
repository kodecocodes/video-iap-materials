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

import StoreKit

struct Owl {
  let name: String
  let cost: Decimal
  var isPurchased = false
}

extension Array where Element == Owl {
  init() {
    let ids = [
      "CarefreeOwl",
      "CouchOwl",
      "CryingOwl",
      "GoodJobOwl",
      "GoodNightOwl",
      "InLoveOwl",
      "LonelyOwl",
      "NightOwl",
      "ShyOwl"
    ].map { .prefix + $0 }

    self = [
      Owl(name: "Sleepy Owl", cost: 0.99),
      Owl(name: "Crying Owl", cost: 0.99),
      Owl(name: "Good Job Owl", cost: 0.99),
      Owl(name: "In Love Owl", cost: 0.99),
      Owl(name: "Lonely Owl", cost: 0.99),
      Owl(name: "Night Owl", cost: 0.99),
      Owl(name: "Shy Owl", cost: 0.99)
    ]
  }
}

extension StoreKit.Product.ID {
  static var prefix: Self { "com.razeware.course.iap.2022." }
}

// MARK: - Identifiable
extension Owl: Identifiable {
  var id: String { name }
}

private extension Sequence where Element: Sendable {
  func map<Transformed: Sendable>(
    priority: TaskPriority? = nil,
    _ transform: @escaping @Sendable (Element) async throws -> Transformed
  ) async rethrows -> [Transformed] {
    try await withThrowingTaskGroup(
      of: EnumeratedSequence<[Transformed]>.Element.self
    ) { group in
      for (offset, element) in enumerated() {
        group.addTask(priority: priority) {
          (offset, try await transform(element))
        }
      }

      return try await group.reduce(
        into: map { _ in nil } as [Transformed?]
      ) {
        $0[$1.offset] = $1.element
      } as! [Transformed]
    }
  }
}
