/*
* Copyright (c) 2015 Razeware LLC
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

import StoreKit
import Foundation


class IAPHelper: NSObject {
  
  static let IAPHelperPurchaseNotification = "IAPHelperPurchaseNotification"
  
  typealias ProductsRequestCompletionHandler = (products: [SKProduct]?) -> ()
  
  private let productIndentifiers: Set<String>
  private var productsRequest: SKProductsRequest?
  private var productsRequestCompletionHandler:  ProductsRequestCompletionHandler?
  
  init(prodIds: Set<String>) {
    self.productIndentifiers = prodIds
    super.init()
  }
}

//:- API
extension IAPHelper {
  func requestProducts(completionHandler: ProductsRequestCompletionHandler) {
    productsRequest?.cancel()
    productsRequestCompletionHandler = completionHandler
    
    productsRequest = SKProductsRequest(productIdentifiers: productIndentifiers)
    productsRequest?.delegate = self
    productsRequest?.start()
  }
}

//:- SKProductsRequestDelegate
extension IAPHelper: SKProductsRequestDelegate {
  func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
    productsRequestCompletionHandler?(products: response.products)
    productsRequestCompletionHandler = .None
    productsRequest = .None
  }
  
  func request(request: SKRequest, didFailWithError error: NSError) {
    print("Error: \(error.localizedDescription)")
    productsRequestCompletionHandler?(products: .None)
    productsRequestCompletionHandler = .None
    productsRequest = .None
  }
}


extension IAPHelper {

  
  private func completeTranscation(transaction: SKPaymentTransaction) {
    // TODO: Implementation
  }
  
  private func failedTransaction(transaction: SKPaymentTransaction) {
    // TODO: Implementation
  }
  
  private func deliverPurchaseNotificationForIdentifier(identifier: String?) {
    guard let identifier = identifier else { return }
    // TODO: deliver the notification
  }
}








protocol IAPContainer {
  var iapHelper : IAPHelper? { get set }
  
  func passIAPHelperToChildren()
}


extension IAPContainer where Self : UIViewController {
  func passIAPHelperToChildren() {
    for vc in childViewControllers {
      var iapContainer = vc as? IAPContainer
      iapContainer?.iapHelper = iapHelper
    }
  }
}
