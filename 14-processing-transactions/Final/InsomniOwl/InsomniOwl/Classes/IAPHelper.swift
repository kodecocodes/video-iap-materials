//
//  IAPHelper.swift
//  InsomniOwl
//
//  Created by Brian on 2/16/19.
//  Copyright © 2019 Razeware LLC. All rights reserved.
//

import Foundation
import StoreKit

public typealias ProductIdentifier = String
public typealias ProductsRequestCompletionHandler = (_ succees: Bool, _ products: [SKProduct]?) -> Void

class IAPHelper: NSObject {
  
  private let productIdentifiers: Set<String>
  private var productsRequest: SKProductsRequest?
  private var productsRequestCompletionHandler: ProductsRequestCompletionHandler?
  
  
  init(productIDs: Set<String>) {
    productIdentifiers = productIDs
    super.init()
  }
}

extension IAPHelper {
  
  func buyProduct(product: SKProduct) {
    let payment = SKPayment(product: product)
    SKPaymentQueue.default().add(payment)
  }
  
  
  func requestProducts(completionHandler: @escaping ProductsRequestCompletionHandler) {
    productsRequest?.cancel()
    productsRequestCompletionHandler = completionHandler
    productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
    productsRequest?.delegate = self
    productsRequest?.start()
  }
}

extension IAPHelper: SKProductsRequestDelegate {
  
  func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
      productsRequestCompletionHandler?(true, response.products)
      productsRequestCompletionHandler = .none
      productsRequest = .none
  }
  
  func request(_ request: SKRequest, didFailWithError error: Error) {
    productsRequestCompletionHandler?(false, nil)
    productsRequestCompletionHandler = .none
    productsRequest = .none
  }
  
  
}


