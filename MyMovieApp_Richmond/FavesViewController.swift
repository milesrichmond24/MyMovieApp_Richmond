//
//  FavesViewController.swift
//  MyMovieApp_Richmond
//
//  Created by Miles Richmond on 1/22/24.
//

import UIKit

class FavesViewController: UIViewController {

    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var filmType: UILabel!
    @IBOutlet weak var imdbID: UILabel!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var movieTitle: UILabel!
    
    var index: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if(AppData.favorites.count == 0) {
            return
        }
        setImage()
        filmType.text = "Film Type: \(AppData.favorites[index].value(forKey: "Type") as? String ?? "?")"
        imdbID.text = "imdbID: \(AppData.favorites[index].value(forKey: "imdbID") as? String ?? "?")"
        year.text = "Year: \(AppData.favorites[index].value(forKey: "Year") as? String ?? "?")"
        movieTitle.text = AppData.favorites[index].value(forKey: "Title") as? String ?? "?"
    }
    
    func setImage() {
        let session = URLSession.shared
        
        let url = URL(string: AppData.favorites[index].value(forKey: "Poster") as? String ?? "")!
        
        let dataTask = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                print("\(error)")
            } else {
                if let data = data {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.poster.image = image
                        }
                    }
                }
            }
        }
        
        dataTask.resume()
    }
    
    @IBAction func left(_ sender: UIButton) {
        if(index == 0) {
            index = AppData.favorites.count - 1
        } else {
            index -= 1
        }
        
        viewWillAppear(true)
    }
    
    @IBAction func right(_ sender: UIButton) {
        if(index == AppData.favorites.count - 1) {
            index = 0
        } else {
            index += 1
        }
        
        viewWillAppear(true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
