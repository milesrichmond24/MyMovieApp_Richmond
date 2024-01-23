//
//  MovieViewController.swift
//  MyMovieApp_Richmond
//
//  Created by Miles Richmond on 1/22/24.
//

import UIKit

class MovieViewController: UIViewController {

    @IBOutlet weak var favorite_button: UIButton!
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var filmType: UILabel!
    @IBOutlet weak var imdbID: UILabel!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var movieTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setImage()
        filmType.text = "Film Type: \(AppData.selected.value(forKey: "Type") as? String ?? "?")"
        imdbID.text = "imdbID: \(AppData.selected.value(forKey: "imdbID") as? String ?? "?")"
        year.text = "Year: \(AppData.selected.value(forKey: "Year") as? String ?? "?")"
        movieTitle.text = AppData.selected.value(forKey: "Title") as? String ?? "?"
    }
    
    func setImage() {
        let session = URLSession.shared
        
        let url = URL(string: AppData.selected.value(forKey: "Poster") as? String ?? "")!
        print("\(url)")
        
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
    
    @IBAction func favoriteMovie(_ sender: UIButton) {
        if(!AppData.favorites.contains(AppData.selected)) {
            AppData.favorites.append(AppData.selected)
            print("now faved")
        } else {
            AppData.favorites.remove(at: AppData.favorites.firstIndex(of: AppData.selected)!)
        }
        
        UserDefaults.standard.setValue(AppData.favorites, forKey: "faves")
        
        
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
