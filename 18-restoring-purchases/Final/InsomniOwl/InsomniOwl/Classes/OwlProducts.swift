//
//  OwlProducts.swift
//  InsomniOwl
//
//  Created by Brian on 2/16/19.
//  Copyright © 2019 Razeware LLC. All rights reserved.
//

import Foundation
import UIKit

public struct OwlProducts {
  
  static let productIDsNonConsumables: Set<ProductIdentifier> = [
    "com.razeware.video.tutorial.iap.CarefreeOwl",
    "com.razeware.video.tutorial.iap.GoodJobOwl",
    "com.razeware.video.tutorial.iap.CouchOwn",
    "com.razeware.video.tutorial.iap.NightOwl",
    "com.razeware.video.tutorial.iap.LonelyOwl",
    "com.razeware.video.tutorial.iap.ShyOwl",
    "com.razeware.video.tutorial.iap.CryingOwl",
    "com.razeware.video.tutorial.iap.GoodNightOwl",
    "com.razeware.video.tutorial.iap.InLoveOwl"
  ]
  static let randomProductID = "com.razeware.video.tutorial.iap.RandomOwls"
  static let productIDsConsumables: Set<ProductIdentifier> = [randomProductID]
  
  static let productIDsNonRenewing: Set<ProductIdentifier> = [
    "com.razeware.video.tutorial.iap.3MonthsOfRandom",
    "com.razeware.video.tutorial.iap.6MonthsOfRandom"
  ]
  
  static let randomImages = [
    UIImage(named: "CarefreeOwl"),
    UIImage(named: "GoodJobOwl"),
    UIImage(named: "CouchOwl"),
    UIImage(named: "NightOwl"),
    UIImage(named: "LonelyOwl"),
    UIImage(named: "ShyOwl"),
    UIImage(named: "CryingOwl"),
    UIImage(named: "GoodNightOwl"),
    UIImage(named: "InLoveOwl")
  ]
  
  public static func resourceName(for productIdentifier: String) -> String? {
    return productIdentifier.components(separatedBy: ".").last
  }
  
  
  static let store = IAPHelper(productIDs: OwlProducts.productIDsConsumables.union(OwlProducts.productIDsNonConsumables).union(OwlProducts.productIDsNonRenewing))
  
  static func handlePurchase(purchaseIdentifier: String) {
    if productIDsNonConsumables.contains(purchaseIdentifier) {
      store.purchasedProducts.insert(purchaseIdentifier)
    }
  }
  
}
