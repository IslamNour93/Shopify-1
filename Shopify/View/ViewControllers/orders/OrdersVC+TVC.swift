//
//  OrdersVC+TVC.swift
//  Shopify
//
//  Created by Hassan on 14/03/2022.
//

import Foundation
import UIKit

extension OrdersVC : UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartArray.count
    }
    
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: OrdersTVC.identifier, for: indexPath) as! OrdersTVC
        cell.addButton.tag = indexPath.row
        cell.imgView.kf.setImage(with: URL(string: cartArray[indexPath.row].itemImage!))
        cell.titleLabel.text = cartArray[indexPath.row].itemName
        cell.priceLabel.text = cartArray[indexPath.row].itemPrice
        cell.addItemQuantity = {
            self.cartArray[indexPath.row].itemQuantity+=1
            self.tableView.reloadData()
        }
        cell.subItemQuantity = {
            if self.cartArray[indexPath.row].itemQuantity > 1 {
                self.cartArray[indexPath.row].itemQuantity-=1
                self.tableView.reloadData()
            }
        }
        cell.quantityLabel.text = String(cartArray[indexPath.row].itemQuantity)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at:indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
         
            showDeleteAlert(indexPath: indexPath)
           
        } else if editingStyle == .insert {
        }
    }
    
    
    func showDeleteAlert(indexPath:IndexPath){
        let alert = UIAlertController(title: "Are you sure?", message: "You will remove this item from the cart", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { [self] UIAlertAction in
            orderViewModel.deleteFromCoreData(indexPath: indexPath, cartItems: cartArray)
            self.cartArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
            self.tableView.reloadData()
            if self.cartArray.count == 0 {
                emptyCart.isHidden = false
                self.tableView.isHidden = true
                self.tableView.reloadData()

            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
}


extension OrdersVC : UITableViewDelegate
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
}

