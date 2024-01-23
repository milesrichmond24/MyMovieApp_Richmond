//
//  ViewController.swift
//  MyMovieApp_Richmond
//
//  Created by Miles Richmond on 1/22/24.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var searchTerm: UITextField!
    
    var results: [NSDictionary] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        table.delegate = self
        table.dataSource = self
        
        AppData.favorites = UserDefaults.standard.value(forKey: "faves") as? [NSDictionary] ?? []
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        AppData.selected = results[indexPath.row]
        
        performSegue(withIdentifier: "viewMovie", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movie") as! resultCell
        
        cell.year.text = results[indexPath.row].value(forKey: "Year") as? String
        cell.title.text = results[indexPath.row].value(forKey: "Title") as? String
        
        return cell
    }
    
    @IBAction func search(_ sender: UIButton) {
        results.removeAll()
        let session = URLSession.shared
        
        let url = URL(string: "http://www.omdbapi.com/?s=\(searchTerm.text ?? "")&apikey=4bcb7cf5&page=1")!
        
        let dataTask = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            if let err = error {
                print("ERR: \(err)")
            } else {
                if let data = data {
                    if let json = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? NSDictionary {
                        //print(json)
                        if let search = json.value(forKey: "Search") as? NSArray {
                            DispatchQueue.main.async {
                                for searchResult in search {
                                    self.results.append(searchResult as! NSDictionary)
                                }
                                self.table.reloadData()
                                //print(self.results)
                            }
                        } else {
                            if let apiResponse = json.value(forKey: "Response") as? String {
                                if(apiResponse == "False") {
                                    if let apiError = json.value(forKey: "Error") as? String {
                                        let alertContr = UIAlertController(title: "Error", message: apiError, preferredStyle: .alert)
                                        
                                        alertContr.addAction(UIAlertAction(title: "ok", style: .default))
                                        
                                        // For some reason there is a large warning in the console with this action
                                        // I'm unsure as to why, and the program still runs afterwards, so I'm leaving it
                                        DispatchQueue.main.async {
                                            self.present(alertContr,animated: true)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        dataTask.resume()
    }
}

