//
//  MovieDetailsViewController.swift
//  OMDBMovieApp
//
//  Created by Karumba Samuel on 20/02/2017.
//  Copyright © 2017 IBM. All rights reserved.
//

import UIKit
import Alamofire
import CoreData
import AVKit
import AVFoundation
import FBSDKShareKit
import FBSDKLoginKit
class MovieDetailsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var imgPoster: UIImageView!
    @IBOutlet weak var lblPlot: UILabel!
    let imagePicker = UIImagePickerController()
   
    
    
    
    @IBAction func bookmarkFilm(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Confirm!!", message: "Do you want to bookmark film?", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: {(action: UIAlertAction) -> Void in
            //pick movie object and save
            self.saveBookmarkedFilm()
            
           
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {(action: UIAlertAction) -> Void in
            //handle cancelation
        })
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert,animated: true,completion: nil)

    }
    func playVideo() {
        let url = URL(string:
            "http://www.ebookfrenzy.com/ios_book/movie/movie.mov")
        let player = AVPlayer(url: url!)
        let playerController = AVPlayerViewController()
        
        playerController.player = player
        self.addChildViewController(playerController)
        self.view.addSubview(playerController.view)
        playerController.view.frame = self.view.frame
        
        player.play()
        
    }
    
    @IBAction func playMovieTrailler() {
        playVideo()
    }
    
    
    func saveBookmarkedFilm() {
        //1
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        //2
        let entity = NSEntityDescription.entity(forEntityName: "Film", in: managedContext)
        
        //3 mapping
        let film = Film(entity: entity!, insertInto: managedContext)
        film.title = movie?.title
        film.type = movie?.type
        film.imdbID = movie?.imdbID
        film.poster = movie?.poster
        film.year = movie?.year
        
        //4 save
        do {
            try managedContext.save()
        } catch let error {
            print("Error: \(error)")
        }
        
        
        
    }
    
    var movie: SearchViewController.MyMovieModel? {
        
        didSet{
            title = movie?.title

            loadMovieDetails(imdbID: (movie?.imdbID)!)
            
            
        }
    }
    
    var movieInfo: MyMovieDetailsModel? {
        didSet{
            
            let posterURL = NSURL(string:(movie?.poster)!)
            
            if let imageData = NSData(contentsOf: posterURL as! URL) {
                self.imgPoster?.image = UIImage(data: imageData as Data)
            }
            
            self.lblPlot.text = movieInfo?.plot
        }
    }
    
    

    struct MyMovieDetailsModel {
        var poster = ""
        var title = ""
        var type = ""
        var year = ""
        var imdbID = ""
        var Released = ""
        var Genre = ""
        var Director = ""
        var Writer = ""
        var Actors = ""
        var plot = ""
        var Language = ""
        var Metascore = ""
        var imdbRating = ""
        var imdbVotes = ""

        init(_ objMovie: NSDictionary){
            self.poster = (objMovie ["Poster"] as? String)!
            self.title = (objMovie ["Title"] as? String)!
            self.type = (objMovie ["Type"] as? String)!
            self.year = (objMovie ["Year"] as? String)!
            self.imdbID = (objMovie ["imdbID"] as? String)!
            
            self.Released = (objMovie ["Released"] as? String)!
            self.Genre = (objMovie ["Genre"] as? String)!
            self.Director = (objMovie ["Director"] as? String)!
            self.Writer = (objMovie ["Writer"] as? String)!
            self.Actors = (objMovie ["Actors"] as? String)!
            self.Language = (objMovie ["Language"] as? String)!
            self.plot = (objMovie ["Plot"] as? String)!
            self.Metascore = (objMovie ["Metascore"] as? String)!
            self.imdbRating = (objMovie ["imdbRating"] as? String)!
            self.imdbVotes = (objMovie ["imdbVotes"] as? String)!
            
            
            
        }
        
    }
    

    func loadMovieDetails(imdbID: String) {
        
//        let imdID = movie?.imdbID
        
        Alamofire.request("http://www.omdbapi.com/?i=\(imdbID)").responseJSON { response in
            
            if let JSON = response.result.value {
                
                if let movie = JSON as? NSDictionary {
                    //pass it to a structure and add it to my movie list
                    self.movieInfo =  MyMovieDetailsModel(movie)
                    
                }
                
                
                
                print("JSON: \(JSON)")
                
                
            }
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePicker.delegate = self
        
        
       // Do any additional setup after loading the view.
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func shareButtonFacebook(_ sender: AnyObject) {
        
        var shareArray: [AnyObject] = []
        
        if self.imgPoster.image != nil {
            shareArray.append(self.imgPoster.image!)
        }
        if let website = NSURL(string :"http://www.ebookfrenzy.com/ios_book/movie/movie.mov") {
            shareArray.append(website)
        }
        let activityVc = UIActivityViewController(activityItems: shareArray, applicationActivities: nil)
        if let popoverController = activityVc.popoverPresentationController {
             popoverController.sourceView = sender as? UIView
            popoverController.sourceRect = sender.bounds
        }
        self.present(activityVc, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
             self.imgPoster.image = pickedImage
        }
       self.dismiss(animated: true, completion: nil)
        
        let video : FBSDKShareVideo = FBSDKShareVideo ()
        video.videoURL = (info[UIImagePickerControllerMediaURL] as! NSURL) as URL!
        let content : FBSDKShareVideoContent = FBSDKShareVideoContent()
        content.video = video
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }

    
    
    @IBAction func logOutPress(_ sender: AnyObject) {
        let loginManager = FBSDKLoginManager()
        loginManager.logOut() // this is an instance function
        performSegue(withIdentifier: "homeView", sender: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
