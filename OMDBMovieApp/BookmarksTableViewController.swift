//
//  BookmarksTableViewController.swift
//  OMDBMovieApp
//
//  Created by Karumba Samuel on 21/02/2017.
//  Copyright © 2017 IBM. All rights reserved.
//

import UIKit
import CoreData
import  FBSDKLoginKit
    
    class BookmarksTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
        
        
        var urlString = "http://api.androidhive.info/json/movies.json"
        
         var posterArray = [String]()
        var titleArray = [String]()
        var typeArray = [String]()
        var yearArray = [String]()
        var imdbID = [String]()
        
        var selectedMovie = Dictionary<String,String>()
    
        @IBOutlet weak var tableView: UITableView!
        
        override func viewDidLoad() {
            self.downloadJsonUrl()
        }
        
        
        func downloadJsonUrl(){
            let url = NSURL(string: urlString)
            URLSession.shared.dataTask(with: (url as? URL)!, completionHandler: {(data, response, error) -> Void in
                if let jsonArray = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSArray {
                    for array in jsonArray! {
                        if let movie = array as? NSDictionary {
                            
                            if let title = movie.value(forKey: "title") {
                                self.titleArray.append(title as! String)
                            }
                            
                            if let type = movie.value(forKey: "rating") {
                                let type = String(format: "%.1f", type as! Double)
                                self.typeArray.append("\(type)")
                            }
                            
                            if let image = movie.value(forKey: "image") {
                                self.imdbID.append(image as! String)
                            }
                            
                            if let year = movie.value(forKey: "releaseYear") {
                                self.yearArray.append("\(year)")
                            }
                            
                        
                            
                            OperationQueue.main.addOperation({
                                self.tableView.reloadData()
                            })
                        }
                    }
                }
                
            }).resume()
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return titleArray.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
            cell.titleLabel.text = titleArray[indexPath.row]
            cell.typeLabel.text = typeArray[indexPath.row]
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            selectedMovie["title"] = titleArray[indexPath.row]
            selectedMovie["type"] = typeArray[indexPath.row]
            selectedMovie["image"] = imdbID[indexPath.row]
            selectedMovie["year"] = yearArray[indexPath.row]
          
            performSegue(withIdentifier: "movieInfoView", sender: self)
        }
        
        
        
        @IBAction func logOutPressed(_ sender: UIButton) {
            let loginManager = FBSDKLoginManager()
            loginManager.logOut() // this is an instance function
            performSegue(withIdentifier: "homeView", sender: nil)
        }
        
     
        }
        
        
        
        

