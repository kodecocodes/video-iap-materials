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

class ShoppingListViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var nameLabel: MultilineLabelThatWorks!
  @IBOutlet weak var dateLabel: MultilineLabelThatWorks!
  @IBOutlet weak var totalCostLabel: UILabel!
  
  var dataStore : DataStore?
  var shoppingList : ShoppingList? {
    didSet {
      updateViewForShoppingList()
    }
  }
  
  private static var dateFormatter : NSDateFormatter = {
    let df = NSDateFormatter()
    df.dateStyle = .ShortStyle
    return df
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    configureTableView(tableView)
    updateViewForShoppingList()
  }
}

extension ShoppingListViewController {
  private func updateViewForShoppingList() {
    if let shoppingList = shoppingList {
      nameLabel?.text = shoppingList.name
      dateLabel?.text = self.dynamicType.dateFormatter.stringFromDate(shoppingList.date)
      totalCostLabel?.text = "$\(shoppingList.products.reduce(0){ $0 + $1.price })"
    }
    tableView?.reloadData()
  }
  
  private func configureTableView(tableView: UITableView) {
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 100
    tableView.dataSource = self
    tableView.backgroundColor = UIColor.clearColor()
    tableView.backgroundView?.backgroundColor = UIColor.clearColor()
    tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 49, right: 0)
    tableView.separatorStyle = .None
  }
}


extension ShoppingListViewController : UITableViewDataSource {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return shoppingList?.products.count ?? 0
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("ProductCell", forIndexPath: indexPath)
    if let cell = cell as? ProductTableViewCell {
      cell.product = shoppingList?.products[indexPath.row]
    }
    cell.backgroundView?.backgroundColor = UIColor.clearColor()
    cell.backgroundColor = UIColor.clearColor()
    cell.contentView.backgroundColor = UIColor.clearColor()
    return cell
  }
}