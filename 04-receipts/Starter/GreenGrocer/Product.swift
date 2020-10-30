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

import UIKit

private let idKey = "id"
private let nameKey = "name"
private let priceKey = "price"
private let detailsKey = "details"
private let photoNameKey = "photoName"


typealias ProductID = NSUUID

final class Product {
  let id: ProductID
  let name: String
  let price: Int
  let details: String
  let photoName: String
  
  init(id: ProductID, name: String, price: Int, details: String, photoName: String) {
    self.id = id
    self.name = name
    self.price = price
    self.details = details
    self.photoName = photoName
  }
}

extension Product {
  convenience init(name: String, price: Int, details: String, photoName: String) {
    self.init(id: NSUUID(), name: name, price: price, details: details, photoName: photoName)
  }
}

extension Product : Serializable {
  convenience init?(dict: [String : AnyObject]) {
    guard let idString = dict[idKey] as? String,
      let id = NSUUID(UUIDString: idString),
      let name = dict[nameKey] as? String,
      let price = dict[priceKey] as? Int,
      let details = dict[detailsKey] as? String,
      let photoName = dict[photoNameKey] as? String else {
        return nil
    }
    self.init(id: id, name: name, price: price, details: details, photoName: photoName)
  }
  
  var dictRepresentation : [String : AnyObject] {
    return [
      idKey            : id.UUIDString,
      nameKey          : name,
      priceKey         : price,
      detailsKey       : details,
      photoNameKey     : photoName,
    ]
  }
}

extension Product : Equatable {
  // Free function below
}

func ==(lhs: Product, rhs: Product) -> Bool {
  return lhs.id.isEqual(rhs.id)
}

extension Product : Hashable {
  var hashValue : Int {
    return id.UUIDString.hashValue
  }
}