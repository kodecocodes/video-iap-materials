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

class ShoppingListTableViewController: UITableViewController, DataStoreOwner, IAPContainer {
  
  var dataStore : DataStore?
  var iapHelper : IAPHelper?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 70
  }

  // MARK: - Table view data source
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataStore?.shoppingLists.count ?? 0
  }
  

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("ShoppingListCell", forIndexPath: indexPath)
  
    if let cell = cell as? ShoppingListTableViewCell {
      cell.shoppingList = dataStore?.shoppingLists[indexPath.row]
    }
  
    return cell
  }
  
  // MARK: - Table view delegate
  override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
  }
  
  override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
      if let shoppingList = dataStore?.shoppingLists[indexPath.row] {
        dataStore?.removeShoppingList(shoppingList)
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
      }
    }
  }

  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let destVC = segue.destinationViewController as? ShoppingListViewController {
      let selectedRowIndex = tableView.indexPathForSelectedRow
      destVC.shoppingList = dataStore?.shoppingLists[selectedRowIndex?.row ?? 0]
      destVC.dataStore = dataStore
    } else if let destVC = segue.destinationViewController as? CreateShoppingListViewController {
      destVC.dataStore = dataStore
    }
  }
  
}


extension ShoppingListTableViewController {
  @IBAction func unwindToShoppingListTableVC(unwindSegue: UIStoryboardSegue) {
    tableView.reloadData()
  }
}

