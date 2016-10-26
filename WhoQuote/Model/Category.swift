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
    
    fileprivate var _name: String!
    fileprivate var _slug: String!
    fileprivate var _imageURL: String!
    fileprivate var _image: UIImage!
    
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
            print("Category Picture Exists")
        } else {
            print("Category Picture Does Not Exist")
            if let URL = _imageURL {
                Alamofire.request(URL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil)
                .response(completionHandler: { (response) in
                    self._image = UIImage(data: response.data!, scale: 1)
                    self.saveImageForUserId(self.name, image: self._image)
                })
            }
        }
        
    }
    
    func saveImageForUserId(_ id: String, image: UIImage) {
        let imageName = id + ".png"
        let imagePath = fileInDocumentsDirectory(imageName)
        _ = self.saveImage(image, path: imagePath)
    }
    
    func loadImageForUserId(_ id: String) -> UIImage? {
        let imageName = id + ".png"
        let imagePath = fileInDocumentsDirectory(imageName)
        return loadImageFromPath(imagePath)
    }
    
    func saveImage(_ image: UIImage, path: String) -> Bool {
        let pngImageData = UIImagePNGRepresentation(image)
        let result = (try? pngImageData!.write(to: URL(fileURLWithPath: path), options: [.atomic])) != nil
        return result
    }
    
    func getDocumentsURL() -> URL {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documentsURL
    }
    
    func fileInDocumentsDirectory(_ filename: String) -> String {
        let fileURL = getDocumentsURL().appendingPathComponent(filename)
        return fileURL.path
    }
    
    func loadImageFromPath(_ path: String) -> UIImage? {
        let image = UIImage(contentsOfFile: path)
        return image
        
    }
}
