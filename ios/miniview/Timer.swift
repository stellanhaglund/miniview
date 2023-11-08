//
//  Timer.swift
//  miniview
//
//  Created by Stellan Haglund on 2023-07-01.
//

import Foundation
import Dispatch

func measureExecutionTime(block: () -> Void) -> TimeInterval {
    let startTime = DispatchTime.now()
    block()
    let endTime = DispatchTime.now()
    
    let nanoTime = endTime.uptimeNanoseconds - startTime.uptimeNanoseconds
    let executionTime = Double(nanoTime) / 1_000_000_000 // Convert to seconds
    
    return executionTime
}
