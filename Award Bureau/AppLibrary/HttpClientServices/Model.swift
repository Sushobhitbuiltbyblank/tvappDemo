//
//  Model.swift
//  Award Bureau
//
//  Created by Sushobhit Jain on 01/09/18.
//  Copyright © 2018 Sushobhit Jain. All rights reserved.
//

import Foundation

struct loginResponse:Encodable,Decodable {
    var token:String?
    var first_name:String?
    var last_name:String?
    var refresh_token:String?
    var error:String?
}

struct CategoryModel:Encodable,Decodable {
    var category:String?
    var titles:[TitleModel]?
}

struct TitleModel:Encodable,Decodable {
    var id:String?
    var name:String?
    var rep_image:String?
    var screener_id:String?
    var vendor_id:String?
}

struct LogoutResponse:Encodable,Decodable {
    var message:String?
    var error:String?
}

struct TitleResponse:Encodable,Decodable {
    var name:String?
    var prefix:String?
    var rep_image:String?
    var genres:[String]?
    var country:String?
    var director:String?
    var rating:String?
    var release_date:String?
    var synopsis:String?
    var writer:String?
}

struct PlayResponse:Encodable,Decodable {
    var vendor_id:String?
    var play_location:Int?
    var play_location_id:String?
    var anti_piracy:String?
    var watermark:Bool?
    var error:String?
}

struct Response:Encodable,Decodable {
    var error:String?
}

struct preplayResponse:Encodable,Decodable {
    var prefix:String?
    var drm:drmUrlModel?
    var playURL:String?
    var sid:String?
}

struct AssetsResponse {
    var duration:Double?
    var poster_url:String?
    var msg:String?
    var error:String?
}

struct LegalModel:Encodable,Decodable {
    var error:String?
    var description:String?
}

struct drmUrlModel:Encodable,Decodable {
    var fairplayCertificateURL:String?
}
