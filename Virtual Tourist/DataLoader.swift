//
//  DataLoader.swift
//  Virtual Tourist
//
//  Created by Sergey Kravtsov on 31.03.17.
//  Copyright © 2017 Sergey Kravtsov. All rights reserved.
//

import Foundation

class DataLoader: NSObject {
    
    // MARK: - URL Session
    var session = URLSession.shared
    
    // MARK: - Get Method
    func taskForGETMethod(parameters: [String:AnyObject], completionHandlerForGET: @escaping (_ result: [String:AnyObject]?, _ error: String?) -> Void) -> URLSessionDataTask {
        let parametersForRequest = parameters
        let request = NSMutableURLRequest(url: flickrURLBuilder(parametersForRequest, withPathExtension: nil))
        print(request.url!)
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            func sendError(_ error: String) {
                print(error)
                completionHandlerForGET(nil, error)
            }
            guard (error == nil) else {
                sendError(ErrorIs.request + error!.localizedDescription)
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError(ErrorIs.statusCode)
                return
            }
            guard let data = data else {
                sendError(ErrorIs.inData)
                return
            }
            
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertedData: completionHandlerForGET)
        }
        task.resume()
        return task
    }
    
    // MARK: - URL Builder
    private func flickrURLBuilder(_ parameters: [String:AnyObject], withPathExtension: String?) -> URL {
        var components = URLComponents()
        components.scheme = Flickr.scheme
        components.host = Flickr.host
        components.path = Flickr.path + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems?.append(queryItem)
        }
        return components.url!
    }
    
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertedData: (_ result: [String:AnyObject]?, _ error: String?) -> Void) {
        
        var parsedResult: [String:AnyObject]?
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:AnyObject]
        } catch {
            completionHandlerForConvertedData(nil, ErrorIs.serialization)
        }
        completionHandlerForConvertedData(parsedResult, nil)
    }
    
    // Get images from urls stored in CoreData, show in photoAlbumCollectionViewController
    func getFlickrImages(_ photo: Photo?, completionHandlerForGetFlickrImages: @escaping (_ success: Bool, _ errorString: String?, _ imageData: Data?) -> Void) -> URLSessionTask {
        
        let flickrURL = photo?.stringURL
        let requestURL = URL(string: flickrURL!)
        let request = URLRequest(url: requestURL!)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completionHandlerForGetFlickrImages(false, error.localizedDescription, nil)
            } else {
                completionHandlerForGetFlickrImages(true, nil, data)
            }
        }
        task.resume()
        return task
    }
    
    // Get the number of pages and photos per page for a given request with pin
    func getPhotosUsingFlickr(_ pin: Pin?, completionHandlerForGETPhotosUsingFlickr: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        guard pin != nil else {
            print(ErrorIs.pin)
            completionHandlerForGETPhotosUsingFlickr(false, ErrorIs.pinCompletion)
            return
        }
        
        let parameters: [String:AnyObject]? = [
            ParameterKeys.method: Flickr.urlForSearch as AnyObject,
            ParameterKeys.APIKey: Flickr.apiKey as AnyObject,
            ParameterKeys.safeSearch: ParameterValues.safeSearch as AnyObject,
            ParameterKeys.latitude: pin?.coordinate.latitude as AnyObject,
            ParameterKeys.longitude: pin?.coordinate.longitude as AnyObject,
            ParameterKeys.radius: ParameterValues.radius as AnyObject,
            ParameterKeys.extras: ParameterValues.extras as AnyObject,
            ParameterKeys.format: ParameterValues.json as AnyObject,
            ParameterKeys.noJSONCallback: ParameterValues.disableJSONCallback as AnyObject
        ]
        
        var numberOfPagesFromRequest: Int?
        var totalNumberOfPages: Int?
        
        let _ = taskForGETMethod(parameters: parameters!) { (results, error) in
            
            guard (error == nil) else {
                print("There was an error in getFlickrPhotos")
                completionHandlerForGETPhotosUsingFlickr(false, "An error occured trying to retrieve photos from Flickr!")
                return
            }
            guard let status = results?[ResponseKeys.stat] as? String, status == ResponseValues.ok else {
                print("There was a status error in getFlickrPhotos")
                completionHandlerForGETPhotosUsingFlickr(false, "A status code error occured from Flickr!")
                return
            }
            guard let photosDictionary = results?[ResponseKeys.photos] as? [String:AnyObject], let numberOfPages = photosDictionary[ResponseKeys.pages] as? Int, let totalPerPage = photosDictionary[ResponseKeys.perPage] as? Int else {
                print("There was an error parsing photos for page number")
                completionHandlerForGETPhotosUsingFlickr(false, "An error occured downloading photos from Flickr!")
                return
            }
            numberOfPagesFromRequest = numberOfPages
            totalNumberOfPages = Int(totalPerPage)
            let numberOfPhotos = min(totalNumberOfPages!, 21)
            let pageLimit = min(numberOfPagesFromRequest!, 50)
            let randomPage = Int(arc4random_uniform(UInt32(pageLimit))) + 1
            self.getPhotosUsingPage(pin, randomPage: randomPage, perPage: numberOfPhotos, completionHandlerForGETPhotosUsingPage: completionHandlerForGETPhotosUsingFlickr)
        }
    }
    
    private func getPhotosUsingPage(_ pin: Pin?, randomPage: Int?, perPage: Int?, completionHandlerForGETPhotosUsingPage: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        guard pin != nil else {
            print("Could not acquire pin value for photo search")
            completionHandlerForGETPhotosUsingPage(false, "Could not complete photo search with page")
            return
        }
        
        let parameters: [String:AnyObject]? = [
            ParameterKeys.method: Flickr.urlForSearch as AnyObject,
            ParameterKeys.APIKey: Flickr.apiKey as AnyObject,
            ParameterKeys.safeSearch: ParameterValues.safeSearch as AnyObject,
            ParameterKeys.latitude: pin?.coordinate.latitude as AnyObject,
            ParameterKeys.longitude: pin?.coordinate.longitude as AnyObject,
            ParameterKeys.radius: ParameterValues.radius as AnyObject,
            ParameterKeys.extras: ParameterValues.extras as AnyObject,
            ParameterKeys.format: ParameterValues.json as AnyObject,
            ParameterKeys.noJSONCallback: ParameterValues.disableJSONCallback as AnyObject,
            ParameterKeys.page: randomPage as AnyObject,
            ParameterKeys.perPage: perPage as AnyObject
        ]
        
        let _ = self.taskForGETMethod(parameters: parameters!) { (results, error) in
            
            guard (error == nil) else {
                print("There was an error in getFlickrPhotos")
                completionHandlerForGETPhotosUsingPage(false, error)
                return
            }
            guard let status = results?[ResponseKeys.stat] as? String, status == ResponseValues.ok else {
                print("There was a status error in getFlickrPhotos")
                completionHandlerForGETPhotosUsingPage(false, "A status code error occured from Flickr!")
                return
            }
            guard let photosDictionary = results?[ResponseKeys.photos] as? [String:AnyObject], let photoArrayOfDictionaries = photosDictionary[ResponseKeys.photo] as? [[String:AnyObject]] else {
                print("There was an error parsing photos")
                completionHandlerForGETPhotosUsingPage(false, "An error occured downloading photos from Flickr!")
                return
            }
            
            for photoDictionary in photoArrayOfDictionaries {
                let photo = Photo(dictionary: photoDictionary, context: AppDelegate.stack.context)
                photo.pin = pin
            }
            completionHandlerForGETPhotosUsingPage(true, nil)
        }
    }
    
    // MARK: - Singleton
    class func sharedInstance() -> DataLoader {
        struct Singleton {
            static var sharedInstance = DataLoader()
        }
        return Singleton.sharedInstance
    }
}
