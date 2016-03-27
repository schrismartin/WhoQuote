//
//  Speaker.swift
//  WhoQuote
//
//  Created by Chris Martin on 3/26/16.
//  Copyright © 2016 schrismartin. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class Speaker: NSObject {
    var id: String!
    var image: UIImage!
    var imageURL: String!
    var name: String!
    var twitterHandle: String!
    
    override init() {
        super.init()
    }
    
    convenience init(id: String, image: UIImage, name: String?, twitterHandle: String?) {
        self.init()
        self.id = id
        self.image = image
        if let str = name { self.name = str }
        if let str = twitterHandle { self.twitterHandle = str }
    }
    
    convenience init(json: JSON) {
        self.init()
        if let str = json["name"].string { name = str }
        if let str = json["twitterId"].string { id = str }
        if let str = json["twitterHandle"].string { twitterHandle = str }
        if let str = json["imageURL"].string { imageURL = str }
        
        // Check to see if picture exists
        if let pic = loadImageForUserId(self.id) {
            self.image = pic
        } else {
            if let URL = imageURL {
                Alamofire.request(.GET, URL).response(completionHandler: { (request, response, data, error) in
                    self.image = UIImage(data: data!, scale: 1)
                    self.saveImageForUserId(self.id, image: self.image)
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
