//
//  TableScreenViewController.swift
//  ShiftLabApp
//
//  Created by Станислав Дейнекин on 31.07.2024.
//

import UIKit

class TableScreenViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var username: String?
    var products: [Product] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
                
        fetchProducts()
    }
        
    @IBAction func showGreetingModal(_ sender: UIButton) {
        let greetingVC = GreetingViewController()
        greetingVC.username = self.username
        greetingVC.modalPresentationStyle = .overFullScreen
        present(greetingVC, animated: true, completion: nil)
    }
    
    func fetchProducts() {
            guard let url = URL(string: "https://fakestoreapi.com/products") else { return }
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    print("Ошибка: \(error.localizedDescription)")
                    return
                }
                
                guard let data = data else { return }
                
                do {
                    self.products = try JSONDecoder().decode([Product].self, from: data)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } catch {
                    print("Ошибка декодирования: \(error.localizedDescription)")
                }
            }
            
            task.resume()
        }
    
    func numberOfSections(in tableView: UITableView) -> Int {
           return 1
       }
       
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return products.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
           let product = products[indexPath.row]
           cell.textLabel?.text = "\(product.title) - $\(product.price)"
           return cell
       }

}
