//
//  Constants.swift
//  SkiFinder
//
//  Created by Justin Lowry on 1/11/22.
//

import Foundation

struct Constants {
    struct StoryBoard {
        static let mainNavVC = "MainNavViewController"
        static let mainTabBarVC = "MainTabBarViewController"
        static let loginVC = "LoginVC"
        static let signUpVC = "SignUpVC"
        static let startPageVC = "StartPageVC"
        static let editProfileVC = "EditProfileVC"
        static let feedVC = "FeedTVC"
        
        struct cells {
            static let skiUserPhotoCell = "SkiUserPhotoCell"
            static let skiUserDetailCell = "SkiUserDetailsCell"
            static let skiScheduleTitlteCell = "SkiScheduleTitlteCell"
            static let skiUserCalendarCell = "SkiUserCalendarCell"
            static let skiUserCalendarKeyCell = "SkiUserCalendarKeyCell"
        }
        
        struct segues {
            static let toEditProfileVC = "toEditProfileVC"
            static let toSkiUserProfile = "toSkiUserProfile"
            static let toEditSkiDatesVC = "toEditSkiDatesVC"
        }
    }
    
    struct Segue {
        static let toEditProfileVC = "toEditProfileVC"
    }
    
    struct Firebase {
        struct User {
            static let usersCollectionKey = "users"
            static let firstNameKey = "first_name"
            static let dateOfBirthKey = "birth_date"
            static let skiProficiencyKey = "ski_proficiency"
            static let skiPassLocationsKey = "ski_pass_location"
            static let bioKey = "bio"
            static let currentLocationKey = "current_location"
            static let skiStyleTagsKey = "ski_style_tags"
            static let skiDatesKey = "ski_dates"
            static let skiInviteDatesKey = "ski_invite_dates"
            static let profilePhotoURLKey = "profile_photo_url"
            static let photoURLSKey = "photo_urls"
            static let uidKey = "uid"
            static let skiTypesKey = "ski_types"
            
            struct skiTypes {
                static let skiKey = "ski_types.ski"
                static let snowboardKey = "ski_types.snowboard"
            }
        }
    }
}
