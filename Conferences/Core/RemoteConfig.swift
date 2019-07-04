//
//  RemoteConfig.swift
//  Conferences
//
//  Created by Zagahr on 24/05/2019.
//  Copyright © 2019 Timon Blask. All rights reserved.
//

import Foundation
import FirebaseRemoteConfig

class Config {
    static let shared = Config()
    var homeSections: [HomeSection] {
        get {
            let configData = RemoteConfig.remoteConfig().configValue(forKey: "HomeSections").dataValue
            return (try? JSONDecoder().decode([HomeSection].self, from: configData)) ?? self.loadDefaultModels()
        }
    }

    func fetchColudValues(completionHandler: @escaping () -> ()) {
        var remoteConfig = RemoteConfig.remoteConfig()

        #if RELEASE
        let expirationDuration: TimeInterval = 3600
        remoteConfig.configSettings = RemoteConfigSettings(developerModeEnabled: false)
        #else
        let expirationDuration: TimeInterval = 0
        remoteConfig.configSettings = RemoteConfigSettings(developerModeEnabled: true)
        #endif

        remoteConfig.fetch(withExpirationDuration: expirationDuration) { (status, error) in
            RemoteConfig.remoteConfig().activateFetched()

            completionHandler()
        }
    }

    func loadDefaultModels() -> [HomeSection] {
        if let url = Bundle.main.url(forResource: "HomeSections", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode([HomeSection].self, from: data)
                return jsonData
            } catch {
                fatalError("Could not load default values")
            }
        }
        fatalError("Could not load default values")
    }
}
