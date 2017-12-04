//
//  user.swift
//  Sepikit.octo
//
//  Created by Harry Twan on 04/12/2017.
//  Copyright © 2017 Harry Twan. All rights reserved.
//

import UIKit

struct User {
    let userName: String
    let id: UInt
    let avatarUrl: String
    let gravatarId: String
    let url: String
    let htmlUrl: String
    let followersUrl: String
    let followingUrl: String
    let gistsUrl: String
    let starredUrl: String
    let subscriptionsUrl: String
    let organizationsUrl: String
    let reposUrl: String
    let eventsUrl: String
    let receivedEventsUrl: String
    let type: String
    let siteAdmin: Bool
    let name: String
    let company: String
    let blog: String
    let location: String
    let email: String
    let hireable: Bool
    let bio: String
    let public_repos: UInt
    let public_gists: UInt
    let followers: UInt
    let following: UInt
    let createdAt: String
    let updatedAt: String
    let totalPrivateRepos: UInt
    let ownedPrivateRepos: UInt
    let privateGists: UInt
    let diskUsage: UInt
    let collaborators: UInt
    let twoFactorAuthentication: Bool
    // TODO: Need to creat the Plan struct
}
