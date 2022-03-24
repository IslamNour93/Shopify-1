//
//  OrdersVC.swift
//  Shopify
//
//  Created by Hassan on 14/03/2022.
//

import UIKit

class OrdersVC: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var emptyCart: UIImageView!
    
    var cartArray : [OrderItemModel] = []
    let orderViewModel = OrderViewModel()
    var orderProduct : [OrderItem] = []
    var order = Order()
    let networking = Networking()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(OrdersTVC.nib(), forCellReuseIdentifier: OrdersTVC.identifier)
        setCartItems()
        //retriveCartItems()
        setTotalPrice()
        checkCartIsEmpty()
    }
    
    @IBAction func proccedToCheckout(_ sender: Any) {
        orderViewModel.bindingEmptyCartAlert = {
            self.showAlertError(title: "No Items!", message: "There is no items to checkout, please go and select items you love")
        }
        let checkoutVC = UIStoryboard(name: "Checkout", bundle: nil).instantiateViewController(withIdentifier: "PaymentViewController") as! PaymentViewController
        navigationController?.pushViewController(checkoutVC, animated: false)
        
    }
    
    func checkCartIsEmpty(){
        if cartArray.count == 0 {
            tableView.isHidden = true
            emptyCart.isHidden = false
        }
    }
    
    func retriveCartItems(){
        orderViewModel.getItemsInCart { cartItems, error in
            guard let items = cartItems else {return}
            self.cartArray = items
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func setCartItems(){
        orderViewModel.getSelectedProducts { orders, error in
            guard let orders = orders else {return}
            self.cartArray = orders
            self.tableView.reloadData()
        }
    }
    
    func setTotalPrice(){
        orderViewModel.calcTotalPrice { totalPrice in
            guard let totalPrice = totalPrice else { return }
            Helper.shared.setTotalPrice(totalPrice:totalPrice)
            self.totalPriceLabel.text = String(totalPrice)
        }
    }
}
