//
//  IAPHelper.swift
//  InsomniOwl
//
//  Created by Brian on 2/16/19.
//  Copyright © 2019 Razeware LLC. All rights reserved.
//

import Foundation


public typealias ProductIdentifier = String

class IAPHelper: NSObject {
  
  private let productIdentifiers: Set<String>
  
  init(productIDs: Set<String>) {
    productIdentifiers = productIDs
    super.init()
  }
  
}

