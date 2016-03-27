//
//  Category.swift
//  WhoQuote
//
//  Created by Chris Martin on 3/26/16.
//  Copyright © 2016 schrismartin. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class Category: NSObject {
    
    private var _name: String!
    private var _slug: String!
    private var _imageURL: String!
    private var _image: UIImage!
    
    var name: String! {
        get {
            return _name
        }
    }
    
    var slug: String! {
        get {
            return _slug
        }
    }
    
    var image: UIImage {
        return _image != nil ? _image : UIImage()
    }
    
    override init() {
        super.init()
    }
    
    convenience init(name: String, slug: String) {
        self.init()
        
        self._name = name
        self._slug = slug
    }
    
    convenience init(json: JSON) {
        self.init()
        if let str = json["name"].string { _name = str }
        if let str = json["slug"].string { _slug = str }
        if let str = json["imageURL"].string { _imageURL = str }
        
        // Check to see if picture exists
        if let pic = loadImageForUserId(self.name) {
            self._image = pic
        } else {
            if let URL = _imageURL {
                Alamofire.request(.GET, URL).response(completionHandler: { (request, response, data, error) in
                    self._image = UIImage(data: data!, scale: 1)
                    self.saveImageForUserId(self.name, image: self._image)
                })
            }
        }
        
    }
    
    func saveImageForUserId(id: String, image: UIImage) {
        let imageName = id + ".png"
        let imagePath = fileInDocumentsDirectory(imageName)
        self.saveImage(image, path: imagePath)
    }
    
    func loadImageForUserId(id: String) -> UIImage? {
        let imageName = id + ".png"
        let imagePath = fileInDocumentsDirectory(imageName)
        return loadImageFromPath(imagePath)
    }
    
    func saveImage(image: UIImage, path: String) -> Bool {
        let pngImageData = UIImagePNGRepresentation(image)
        let result = pngImageData!.writeToFile(path, atomically: true)
        return result
    }
    
    func getDocumentsURL() -> NSURL {
        let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        return documentsURL
    }
    
    func fileInDocumentsDirectory(filename: String) -> String {
        let fileURL = getDocumentsURL().URLByAppendingPathComponent(filename)
        return fileURL.path!
    }
    
    func loadImageFromPath(path: String) -> UIImage? {
        let image = UIImage(contentsOfFile: path)
        return image
        
    }
}
