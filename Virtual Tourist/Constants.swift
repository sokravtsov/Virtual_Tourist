//
//  Constants.swift
//  Virtual Tourist
//
//  Created by Sergey Kravtsov on 25.03.17.
//  Copyright © 2017 Sergey Kravtsov. All rights reserved.
//

import Foundation

struct Flickr {
    static let apiKey = "5b9aa60185840dd916d9b69e6cbd6b5c"
    static let apiSecret = "b008ce6624a226a2"
    static let urlForSearch = "flickr.photos.search"
    static let scheme = "https"
    static let host = "api.flickr.com"
    static let path = "/services/rest/"
}

struct Constants {
    static let pin = "Pin"
    static let photo = "Photo"
    static let latitude = "latitude"
    static let longitude = "longitude"
    static let latitudeDelta = "latitudeDelta"
    static let longitudeDelta = "longitudeDelta"
    static let id = "id"
    static let urlM = "url_m"
    static let region = "region"
    static let pinError = "Could not find entity Pin"
    static let photoError = "Could not find entity Photo"
    static let format = "pin == %@"
}

struct Identifier {
    static let photoAlbum = "photoAlbum"
    static let photoAlbumViewCell = "PhotoAlbumViewCell"
}

struct ReuseID {
    static let pin = "pin"
}

struct ErrorIs {
    static let request = "There was an error with your request: "
    static let statusCode = "Your request returned a status code other than 2xx!"
    static let inData = "No data was returned by the request!"
    static let serialization = "Could not serialize the data from JSON"
    static let pin = "Could not acquire pin value for photo search"
    static let pinCompletion = "Could not complete photo search with pin"
    static let pageCompletion = "Could not complete photo search with page"
}

struct NetworkError {
    static let base = "There was an error in getFlickrPhotos"
    static let flickr = "An error occured trying to retrieve photos from Flickr API"
    static let status = "There was a status error in getFlickrPhotos"
    static let statusCompletion = "A status code error occured from Flickr API"
    static let numberPage = "There was an error parsing photos for page number"
    static let parsing = "There was an error parsing photos"
    static let downloading = "An error occured downloading photos from Flickr API"
}

struct ParameterKeys {
    static let method = "method"
    static let APIKey = "api_key"
    static let safeSearch = "safe_search"
    static let latitude = "lat"
    static let longitude = "lon"
    static let radius = "radius"
    static let extras = "extras"
    static let format = "format"
    static let noJSONCallback = "nojsoncallback"
    static let perPage = "per_page"
    static let page = "page"
}

struct ParameterValues {
    static let safeSearch = "1"
    static let radius = "5"
    static let extras = "url_m"
    static let json = "json"
    static let disableJSONCallback = "1"
}

struct ResponseKeys {
    static let stat = "stat"
    static let photos = "photos"
    static let photo = "photo"
    static let pages = "pages"
    static let perPage = "perpage"
    static let id = "id"
    static let mediumURL = "url_m"
}

struct ResponseValues {
    static let ok = "ok"
}

struct Animation {
    struct Duration {
        static let medium = 0.5
    }
}
