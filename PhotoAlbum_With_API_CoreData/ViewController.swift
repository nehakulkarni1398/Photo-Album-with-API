//  ViewController.swift
//  PhotoAlbum_With_API_CoreData

import UIKit
import SDWebImage

class ViewController: UIViewController {
    @IBOutlet weak var photoTableView: UITableView!
    var photoArray : [Photos] = []
    var albumId = 0
    var apiImageLoadFlag = true

    override func viewDidLoad() {
        super.viewDidLoad()
        photoApiCall()
    }

    @IBAction func favouritePhotosDisplay(_ sender: UIBarButtonItem) {
        apiImageLoadFlag = false
        DatabaseManager.shared.fetchPhotos { str in
            DispatchQueue.main.async {
                self.photoTableView.reloadData()
            }
        }
    }
    
    @IBAction func backToHomeScreen(_ sender: UIBarButtonItem) {
        photoApiCall()
        self.apiImageLoadFlag = true
    }
}

// MARK: API Handling

extension ViewController {
    
    func photoApiCall() {
        let str = "https://jsonplaceholder.typicode.com/photos"
        guard let url = URL(string: str) else {return}
        URLSession.shared.dataTask(with: url) { [unowned self] (serverData, serverResponse, error) in
            guard let serverData = serverData else {return}
            if error == nil {
                do {
                    self.photoArray = try JSONDecoder().decode([Photos].self, from: serverData)
                    DispatchQueue.main.async {
                        self.photoTableView.reloadData()
                    }
                } catch let err {
                    print(err.localizedDescription)
                }
            } else
            {
                print(error?.localizedDescription ?? "demo")
            }
        }.resume()
    }
}

// MARK: UITableView Handling

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if apiImageLoadFlag == true{
            return photoArray.count
        }
        else
        {
            return DatabaseManager.shared.favouriteAlbum.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if apiImageLoadFlag == true {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? CutomTableViewCell else {return UITableViewCell()}
            let photoObj = photoArray[indexPath.row]
            if let imagUrl = URL(string: photoObj.thumbnailUrl) {
                
                cell.albumId.text = String(photoObj.albumId)
                cell.photoId.text = String(photoObj.id)
                cell.photoTitle.text = photoObj.title
                cell.albumImage.sd_setImage(with: imagUrl)
            }
            return cell
        }
        else
        {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? CutomTableViewCell else {return UITableViewCell()}
                let photoObj = DatabaseManager.shared.favouriteAlbum[indexPath.row]
                cell.albumImage.image = UIImage(data: photoObj.image)
                cell.albumId.text = String(photoObj.albumId)
                cell.photoId.text = String(photoObj.photoId)
                cell.photoTitle.text = photoObj.photoTitle
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if apiImageLoadFlag == true{
            let photo = photoArray[indexPath.row]
            guard let photoDetailVC = storyboard?.instantiateViewController(withIdentifier: "PhotoDetailsViewController") as? PhotoDetailsViewController else {return}
            guard let imagUrl = URL(string: photo.thumbnailUrl) else {return}
            photoDetailVC.albumId = photo.albumId
            photoDetailVC.photoTitle = photo.title
            photoDetailVC.imageUrl = imagUrl
            photoDetailVC.photoId = photo.id
            navigationController?.pushViewController(photoDetailVC, animated: true)
        }
        else {
                let photoObj = DatabaseManager.shared.favouriteAlbum[indexPath.row]
                let actionController = UIAlertController(title: "Actions", message: "Do you want delete photot?", preferredStyle: .actionSheet)
                let deleteAction = UIAlertAction(title: "Delete", style: .default) { act in
                    DatabaseManager.shared.deletePhoto(photo: photoObj)
                    DatabaseManager.shared.favouriteAlbum.remove(at: indexPath.row)
                    self.photoTableView.deleteRows(at: [indexPath], with: .automatic)
            }
            let moreDatialAction = UIAlertAction(title: "More Details", style: .default) { act in
                guard let photDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "PhotoDetailsViewController") as? PhotoDetailsViewController else {return}
                photDetailViewController.albumId = Int(photoObj.albumId)
                photDetailViewController.photoTitle = photoObj.photoTitle ?? "Name not Found"
                photDetailViewController.imageData = photoObj.image
                photDetailViewController.photoId = Int(photoObj.photoId)
                photDetailViewController.userName = photoObj.userName
                photDetailViewController.userId = Int(photoObj.userID)
                photDetailViewController.comments = Int(photoObj.comments)
                self.navigationController?.pushViewController(photDetailViewController, animated: true)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            actionController.addAction(deleteAction)
            actionController.addAction(cancelAction)
            actionController.addAction(moreDatialAction)
            self.present(actionController, animated: true)
        }
    }
}



