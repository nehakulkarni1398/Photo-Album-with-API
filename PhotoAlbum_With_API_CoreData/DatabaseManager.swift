//  DatabaseManager.swift
//  PhotoAlbum_With_API_CoreData

import Foundation
import UIKit
import CoreData

final class DatabaseManager {
    
    static let shared = DatabaseManager()
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var favouriteAlbum : [FaviouitePhotos] = []

    private init() {}
    
    func addFaviourite(Title: String, userId: Int32, userName: String, comments: Int32, photoId: Int32, albumId: Int32, image: Data) {
        let album = FaviouitePhotos(context: context)
        album.photoTitle = Title
        album.photoId = photoId
        album.userID = userId
        album.userName = userName
        album.comments = comments
        album.albumId = albumId
        album.image = image
        do {
            try context.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func fetchPhotos(handler: (String)->Void) {
        let request = FaviouitePhotos.fetchRequest()
        do {
            favouriteAlbum = try context.fetch(request)
            handler("Fetched")
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func deletePhoto(photo: FaviouitePhotos) {
        context.delete(photo)
        do {
            try context.save()
        } catch let error {
            print( error.localizedDescription)
        }
    }
}


