//
//  AssemblerFactory.swift
//  TravelApplication
//
//  Created by Povilas Staskus on 9/26/18.
//  Copyright © 2018 Povilas Staskus. All rights reserved.
//

import Foundation
import Swinject
import TravelFeatureKit
import TravelDataKit

class AssemblerFactory {

    func create() -> Assembler {
        let assemblies: [Assembly] = [
            ApplicationAssembly(),
            RegionRepositoryAssembly(),
            TripRepositoryAssembly(),
            AirportRepositoryAssembly(),

            MainAssembly(),
            FavoritesAssembly(),
            FeedAssembly(),
            BookTripAssembly(),
            BookURLRepositoryAssembly(affiliateId: Constants.affiliateId)
        ]

        let assembler = Assembler(assemblies)

        return assembler
    }
}
