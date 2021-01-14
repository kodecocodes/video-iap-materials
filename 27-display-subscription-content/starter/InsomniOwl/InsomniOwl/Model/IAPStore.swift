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

import Foundation
import StoreKit
import SwiftKeychainWrapper

class IAPStore: NSObject, ObservableObject {

  enum Keys {
    static let expirationDate = "ExpirationDate"
    static let lastRandomIndex = "LastRandomIndex"
  }

  private let productIdentifiers: Set<String>
  private var productsRequest: SKProductsRequest? = nil
  public private(set) var purchasedProducts = Set<String>()
  @Published private(set) var products = [SKProduct]()

  public var expirationDate: Date? {
    set {
      guard let value = newValue else { return }
      KeychainWrapper.standard.set(value as NSCoding, forKey: Keys.expirationDate)
    }
    get {
      KeychainWrapper.standard.object(forKey: Keys.expirationDate) as? Date
    }
  }

  public func increaseExpirationDate(by months: Int) {
    let lastDate = expirationDate ?? Date()
    let newDate = Calendar.current.date(byAdding: .month, value: months, to: lastDate)
    expirationDate = newDate
  }

  public func daysRemainingOnSubscription() -> Int {
    if let expirationDate = expirationDate {
      return Calendar.current.dateComponents([.day], from: Date(), to: expirationDate).day!
    }
    return 0
  }

  public func getExpiryDateString() -> String {
    let remaining = daysRemainingOnSubscription()
    if remaining > 0, let expiryDate = expirationDate {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "dd/MM/yyyy"
      return "Subscribed! \nExpires: \(dateFormatter.string(from: expiryDate)) (\(remaining) Days)"
    }
    return "Not Subscribed"
  }


  init(productsIDs: Set<String>) {
    productIdentifiers = productsIDs
    purchasedProducts = Set(productIdentifiers.filter { KeychainWrapper.standard.bool(forKey: $0) ?? false })
    super.init()
  }

  func requestProducts() {
    productsRequest?.cancel()
    productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
    productsRequest?.delegate = self
    productsRequest?.start()
  }

  func buyProduct(product: SKProduct) {
    let payment = SKPayment(product: product)
    SKPaymentQueue.default().add(payment)
  }

  func addPurchase(purchaseIdentifier: String) {
    if productIdentifiers.contains(purchaseIdentifier) {
      purchasedProducts.insert(purchaseIdentifier)
      KeychainWrapper.standard.set(true, forKey: purchaseIdentifier)
      DispatchQueue.main.async { [weak self] in
        self?.objectWillChange.send()
      }

    }
  }

  func isPurchased(_ productIdentifier: String) -> Bool {
    purchasedProducts.contains(productIdentifier) || daysRemainingOnSubscription() > 0
  }

  func restorePurchases() {
    SKPaymentQueue.default().restoreCompletedTransactions()
  }

  func addConsumable(productIdentifier: String, amount: Int) {
    var currentTotal = consumableAmountFor(productIdentifier: productIdentifier)
    currentTotal += amount
    KeychainWrapper.standard.set(currentTotal, forKey: productIdentifier)
    objectWillChange.send()
  }

  func consumableAmountFor(productIdentifier: String) -> Int {
    KeychainWrapper.standard.integer(forKey: productIdentifier) ?? 0
  }

  func decrementConsumable(productIdentifier: String) {
    var currentTotal = consumableAmountFor(productIdentifier: productIdentifier)
    if currentTotal > 0 {
      currentTotal -= 1
    }
    KeychainWrapper.standard.set(currentTotal, forKey: productIdentifier)
    objectWillChange.send()
  }



}

extension IAPStore: SKProductsRequestDelegate {

  func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
    DispatchQueue.main.async { [weak self] in
      self?.products = response.products
      self?.objectWillChange.send()
    }
  }

  func request(_ request: SKRequest, didFailWithError error: Error) {
    print("Failed getting products: \(error)")
  }


}
