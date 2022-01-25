//
//  User.swift
//  SkiFinder
//
//  Created by Justin Lowry on 1/9/22.
//

import UIKit
import FirebaseFirestoreSwift



class User: Identifiable, Codable {
    @DocumentID var id: String?
    var uid: String
    var firstName: String
    var birthDate: Date
    var skiProficiency: String?
    var skiPassLocation: String?
    var currentLocation: String?
    var bio: String?
    var skiStyleTags: [String]
    var skiDates: SkiDates
    var skiInviteDates: [SkiInviteDates]
    var skiTypes: SkiTypes
    var profilePhotoURL: String?
    var photoURLS: [String]
    
    enum CodingKeys: String, CodingKey {
        case uid = "uid"
        case firstName = "first_name"
        case birthDate = "birth_date"
        case skiProficiency = "ski_proficiency"
        case skiPassLocation = "ski_pass_location"
        case currentLocation = "current_location"
        case bio = "bio"
        case skiStyleTags = "ski_style_tags"
        case skiDates = "ski_dates"
        case skiInviteDates = "ski_invite_dates"
        case skiTypes = "ski_types"
        case profilePhotoURL = "profile_photo_url"
        case photoURLS = "photo_urls"
        
//        var localizedText: String {
//            switch self {
//            case .uid:
//                return Constants.Firebase.User.uidKey
//            case .firstName:
//                return Constants.Firebase.User.firstNameKey
//            case .birthDate:
//                return Constants.Firebase.User.dateOfBirthKey
//            case .skiProficiency:
//                return Constants.Firebase.User.skiProficiencyKey
//            case .skiPassLocation:
//                return Constants.Firebase.User.skiPassLocationsKey
//            case .currentLocation:
//                return Constants.Firebase.User.currentLocationKey
//            case .bio:
//                return Constants.Firebase.User.bioKey
//            case .skiStyleTags:
//                return Constants.Firebase.User.skiStyleTagsKey
//            case .skiDates:
//                return Constants.Firebase.User.skiDatesKey
//            case .skiInviteDates:
//                return Constants.Firebase.User.skiInviteDatesKey
//            case .skiTypes:
//                return Constants.Firebase.User.skiTypesKey
//            case .profilePhotoURL:
//                return Constants.Firebase.User.profilePhotoURLKey
//            case .photoURLS:
//                return Constants.Firebase.User.photoURLSKey
//            }
//        }
    }
    
    
    init(uid: String,
         firstName: String,
         birthDate: Date = Date(),
         skiProficiency: String = "",
         skiPassLocation: String = "",
         currentLocation: String = "",
         bio: String = "",
         skiStyleTags: [String] = [],
         skiDates: SkiDates = SkiDates() ,
         skiInviteDates: [SkiInviteDates] = [],
         skiTypes: SkiTypes = SkiTypes(ski: false, snowboard: false),
         profilePhotoURL: String = "",
         photoURLS: [String] = []
    ) {
        self.uid = uid
        self.firstName = firstName
        self.birthDate = birthDate
        self.skiProficiency = skiProficiency
        self.skiPassLocation = skiPassLocation
        self.currentLocation = currentLocation
        self.bio = bio
        self.skiStyleTags = skiStyleTags
        self.skiDates = skiDates
        self.skiInviteDates = skiInviteDates
        self.skiTypes = skiTypes
        self.profilePhotoURL = profilePhotoURL
        self.photoURLS = photoURLS
    }
}

class SkiDates: Codable {
    var willSkiDates: [Date]
    var maybeSkiDates: [Date]
    
    enum CodingKeys: String, CodingKey {
        case willSkiDates = "will_ski_dates"
        case maybeSkiDates = "maybe_ski_dates"
    }
    
    init(willSkiDates: [Date] = [], maybeSkiDates: [Date] = []) {
        self.willSkiDates = willSkiDates
        self.maybeSkiDates = maybeSkiDates
    }
}

struct SkiInviteDates: Codable {
    var inviterID: String
    var willSkiDates: [Date]
    var maybeSkiDates: [Date]
    
    enum CodingKeys: String, CodingKey {
        case inviterID = "inviter_id"
        case willSkiDates = "will_ski_dates"
        case maybeSkiDates = "maybe_ski_dates"
    }
}

struct SkiTypes: Codable {
    var ski: Bool
    var snowboard: Bool
    
    enum CodingKeys: String, CodingKey {
        case ski
        case snowboard
    }
}
