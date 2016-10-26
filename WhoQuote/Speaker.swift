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
                Alamofire.request(URL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).response(completionHandler: { (response) in
                    
                    self.image = UIImage(data: response.data!, scale: 1)
                    self.saveImageForUserId(self.id, image: self.image)
                })
            }
        }
        
    }
    
    func saveImageForUserId(_ id: String, image: UIImage) {
        let imageName = id + ".png"
        let imagePath = fileInDocumentsDirectory(imageName)
        self.saveImage(image, path: imagePath)
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
