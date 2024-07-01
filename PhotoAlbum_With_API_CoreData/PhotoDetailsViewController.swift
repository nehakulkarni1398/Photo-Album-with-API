//
//  PhotoDetailsViewController.swift
//  PhotoAlbum_With_API_CoreData
//
//  Created by Mandar Choudhary on 14/06/24.
//

import UIKit
import SDWebImage

class PhotoDetailsViewController: UIViewController {

    @IBOutlet weak var addFavouriteController: UISwitch!
    @IBOutlet weak var showNumberOfComments: UILabel!
    @IBOutlet weak var showUserName: UILabel!
    @IBOutlet weak var showUserId: UILabel!
    @IBOutlet weak var showPhotoTitle: UILabel!
    @IBOutlet weak var myImage: UIImageView!
    
    var albumArray : [Albums] = []
    var commentArray : [Comments] = []
    var userArray : [User] = []
    var albumId : Int?
    var photoId : Int?
    var photoTitle = ""
    var imageUrl : URL?
    var userId : Int?
    var userName: String?
    var comments: Int?
    var imageData: Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userApiCall()
        commentsApiCall()
        
        guard let userId = userId, let comments = comments , let imageData = imageData else {return}
        showPhotoTitle.text = photoTitle
        showUserName.text = userName
        showUserId.text = String(userId)
        showNumberOfComments.text = String(comments)
        myImage.image = UIImage(data: imageData)
    }
    
    func albumApiCall() {
        let albumStr = "https://jsonplaceholder.typicode.com/albums"
        guard let albumUrl = URL(string: albumStr) else {return}
        URLSession.shared.dataTask(with: albumUrl) { (albumData, albumResponse, error) in
            guard let albumData = albumData else {return}
            if error == nil {
                do {
                    self.albumArray = try JSONDecoder().decode([Albums].self, from: albumData)
                    self.reloadView()
                } catch let err {
                    print(err.localizedDescription)
                }
            } else {
                print(error?.localizedDescription ?? "")
            }
        }.resume()
    }
    
    func reloadView() {
        DispatchQueue.main.async {
            guard let albumId = self.albumId else {return}
            for album in self.albumArray {
                if (album.id == albumId){
                    self.myImage.sd_setImage(with: self.imageUrl)
                    self.showPhotoTitle.text = self.photoTitle
                    self.showUserId.text = String(album.userId)
                    self.userId = album.userId
                }
            }
            guard let userId = self.userId else{return}
            for user in self.userArray {
                if user.id == userId
                {
                    self.showUserName.text = user.username
                }
            }
        }
    }
    
    func userApiCall() {
        let userStr = "https://jsonplaceholder.typicode.com/users"
        guard let userUrl = URL(string: userStr) else {return}
        URLSession.shared.dataTask(with: userUrl) { (userData, userResponse, error) in
            guard let userData = userData else {return}
            if error == nil {
                do {
                    self.userArray = try JSONDecoder().decode([User].self, from: userData)
                    self.albumApiCall()
                }catch let err {
                    print(err.localizedDescription)
                }
            } else {
                    print(error?.localizedDescription ?? "")
                }
            }.resume()
    }
    
    func commentsApiCall() {
        let commentStr = "https://jsonplaceholder.typicode.com/photos/%7B:id%7D/comments"
        guard let commentUrl = URL(string: commentStr) else {return}
        URLSession.shared.dataTask(with: commentUrl) { (commentData, commentResponse, error) in
            guard let commentData = commentData else {return}
            if error == nil {
                do {
                    self.commentArray = try JSONDecoder().decode([Comments].self, from: commentData)
                    DispatchQueue.main.async {
                        var commentCounter = 0
                        for comment in self.commentArray {
                                if comment.postId == self.photoId
                                {
                                    commentCounter += 1
                                }
                            }
                        self.showNumberOfComments.text = String(commentCounter)
                        }
                    }catch let err {
                        print(err.localizedDescription)
                    }
                } else {
                    print(error?.localizedDescription ?? "")
                }
            }.resume()
    }

    @IBAction func cancelButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func updateDetails(_ sender: UIButton) {
        
        if addFavouriteController.isOn {
            DatabaseManager.shared.fetchPhotos { str in
                guard let id = photoId else{return}
                let filterPhots = DatabaseManager.shared.favouriteAlbum.filter { photo in
                    photo.photoId == id
                }
                if filterPhots.count > 0 {
                        let alertController = UIAlertController(title: "Opps!!!", message: "Photo is already availabel", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "Ok", style: .default)
                        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                        alertController.addAction(okAction)
                        alertController.addAction(cancelAction)
                        self.present(alertController, animated: true)
                    } else {
                        guard let imageUrl = imageUrl else {return}
                        do {
                            let imageData = try Data(contentsOf: imageUrl)
                            DatabaseManager.shared.addFaviourite(Title: showPhotoTitle.text!, userId: Int32(showUserId.text!) ?? 0, userName: showUserName.text!, comments: Int32(showNumberOfComments.text!) ?? 0, photoId: Int32(self.photoId ?? 0), albumId: Int32(self.albumId ?? 0), image: imageData)
                            let alertController = UIAlertController(title: "Done", message: "Image Saved as Favourite", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "Ok", style: .default)
                            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                            alertController.addAction(okAction)
                            alertController.addAction(cancelAction)
                            self.present(alertController, animated: true)
                        } catch let error {
                            print(error.localizedDescription)
                        }
                }
            }
        }
        else
        {
            let alertController = UIAlertController(title: "Failed!!!", message: "check with your data", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true)
        }
        
    }
}

