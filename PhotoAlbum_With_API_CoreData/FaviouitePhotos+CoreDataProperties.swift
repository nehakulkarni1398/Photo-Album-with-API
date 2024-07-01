//
//  FaviouitePhotos+CoreDataProperties.swift
//  PhotoAlbum_With_API_CoreData
//
//  Created by Mandar Choudhary on 17/06/24.
//
//

import Foundation
import CoreData


extension FaviouitePhotos {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FaviouitePhotos> {
        return NSFetchRequest<FaviouitePhotos>(entityName: "FaviouitePhotos")
    }

    @NSManaged public var photoTitle: String?
    @NSManaged public var userID: Int32
    @NSManaged public var userName: String?
    @NSManaged public var comments: Int32
    @NSManaged public var photoId: Int32
    @NSManaged public var albumId: Int32
    @NSManaged public var image: Data

}

extension FaviouitePhotos : Identifiable {

}
