//
//  GCDBlackBox.swift
//  Virtual Tourist
//
//  Created by Guilherme Ramos on 17/04/2018.
//  Copyright © 2018 Progeekt. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
