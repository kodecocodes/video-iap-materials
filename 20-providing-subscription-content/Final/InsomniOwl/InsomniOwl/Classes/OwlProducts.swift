//
//  OwlProducts.swift
//  InsomniOwl
//
//  Created by Brian on 2/16/19.
//  Copyright © 2019 Razeware LLC. All rights reserved.
//

import Foundation
import UIKit
import SwiftKeychainWrapper

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
  
  public static func setRandomProduct(with paidUp: Bool) {
    if paidUp {
      KeychainWrapper.standard.set(true, forKey: OwlProducts.randomProductID)
      store.purchasedProducts.insert(OwlProducts.randomProductID)
    } else {
      KeychainWrapper.standard.set(false, forKey: OwlProducts.randomProductID)
      store.purchasedProducts.remove(OwlProducts.randomProductID)
    }
  }
  
  public static func daysRemaininOnSubscription() -> Int {
    if let expiryDate = UserSettings.shared.expirationDate {
      return Calendar.current.dateComponents([.day], from: Date(), to: expiryDate).day!
    }
    return 0
  }
  
  public static func getExpiryDateString() -> String {
    let remaining = daysRemaininOnSubscription()
    if remaining > 0, let expiryDate = UserSettings.shared.expirationDate {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "dd/MM/yyyy"
      return "Subscribed! \nExpires: \(dateFormatter.string(from:expiryDate)) (\(remaining) Days"
    }
    return "Not Subscribed"
  }
  
  public static func paidUp() -> Bool {
    var paidUp = false
    if OwlProducts.daysRemaininOnSubscription() > 0 {
      paidUp = true
    } else if UserSettings.shared.randomRemaining > 0 {
      paidUp = true
    }
    setRandomProduct(with: paidUp)
    return paidUp
  }
  
  private static func handleMonthlySubscription(months: Int) {
    UserSettings.shared.increaseRandomExpirationDate(by: months)
    setRandomProduct(with: true)
  }
  
  static let store = IAPHelper(productIDs: OwlProducts.productIDsConsumables.union(OwlProducts.productIDsNonConsumables).union(OwlProducts.productIDsNonRenewing))
  
  static func handlePurchase(purchaseIdentifier: String) {
    if productIDsConsumables.contains(purchaseIdentifier) {
      UserSettings.shared.increaseRandomRemaining(by: 5)
      setRandomProduct(with: true)
    } else if productIDsNonRenewing.contains(purchaseIdentifier), purchaseIdentifier.contains("3Months") {
      handleMonthlySubscription(months: 3)
    } else if productIDsNonRenewing.contains(purchaseIdentifier), purchaseIdentifier.contains("6Months") {
      handleMonthlySubscription(months: 3)
    } else if productIDsNonConsumables.contains(purchaseIdentifier) {
      store.purchasedProducts.insert(purchaseIdentifier)
      KeychainWrapper.standard.set(true, forKey:purchaseIdentifier)
    }
  }
  
}
