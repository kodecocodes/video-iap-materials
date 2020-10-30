/*
 * Copyright (c) 2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit
import StoreKit
import SwiftKeychainWrapper

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    SKPaymentQueue.default().add(self)

		return true
	}
}

extension AppDelegate: SKPaymentTransactionObserver {
  
  func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
    
    for transaction in transactions {
      switch transaction.transactionState {
      case .purchased, .restored:
        completeTransaction(transaction)
      case .failed:
        failedTransaction(transaction)
      default:
        print("Unhandled transaction state")
      }
    }
    
  }
  
  fileprivate func completeTransaction(_ transaction: SKPaymentTransaction) {
    deliverPurchaseNotification(for: transaction.payment.productIdentifier)
    SKPaymentQueue.default().finishTransaction(transaction)
  }
  
  fileprivate func failedTransaction(_ transaction: SKPaymentTransaction) {
    if let transactionError = transaction.error as NSError?,
       let localizedDescription = transaction.error?.localizedDescription,
      transactionError.code != SKError.paymentCancelled.rawValue {
      print("Transaction error: \(localizedDescription)")
    }
    SKPaymentQueue.default().finishTransaction(transaction)
  }
  
  fileprivate func deliverPurchaseNotification(for identifier: String?) {
    guard let identifier = identifier else { return }
    NotificationCenter.default.post(name: .purchaseNotification, object: identifier)
    OwlProducts.handlePurchase(purchaseIdentifier: identifier)
  }
  
}

extension Notification.Name {
  static let purchaseNotification = Notification.Name("PurchaseNotification")
}
