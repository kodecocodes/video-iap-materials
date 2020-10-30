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

import Foundation

private let idKey = "id"
private let nameKey = "name"
private let dateKey = "date"
private let productsKey = "products"

typealias ShoppingListID = NSUUID

struct ShoppingList {
  let id: ShoppingListID
  let name: String
  let date: NSDate
  let products: [Product]
}

extension ShoppingList {
  static var productList = [Product]()
}

extension ShoppingList {
  init(name: String, date: NSDate, products: [Product]) {
    self.init(id: NSUUID(), name: name, date: date, products: products)
  }
}

extension ShoppingList : Serializable {
  init?(dict: [String : AnyObject]) {
    guard let idString = dict[idKey] as? String,
      let id = NSUUID(UUIDString: idString),
      let name = dict[nameKey] as? String,
      let date = dict[dateKey] as? NSDate,
      let productIDList = dict[productsKey] as? [String],
      let products = mapProductIDListToProductList(productIDList) else {
        return nil
    }
    
    self.init(id: id, name: name, date: date, products: products)
  }
  
  var dictRepresentation : [String : AnyObject] {
    return [
      idKey       : id.UUIDString,
      nameKey     : name,
      dateKey     : date,
      productsKey : products.map { $0.id.UUIDString }
    ]
  }
}

// Equatable
extension ShoppingList : Equatable {
  
}

func ==(lhs: ShoppingList, rhs: ShoppingList) -> Bool {
  return lhs.id.isEqual(rhs.id)
}

private func mapProductIDListToProductList(productIDList: [String]) -> [Product]? {
  let products = productIDList.flatMap(findProductForIDString)
  if products.count == productIDList.count {
    return products
  } else {
    return nil
  }
}

private func findProductForIDString(productID: String) -> Product? {
  let uuid = NSUUID(UUIDString: productID)!
  let products = ShoppingList.productList.filter{ $0.id.isEqual(uuid) }
  if products.count == 1 {
    return products.first!
  } else {
    return nil
  }
}