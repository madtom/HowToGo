//
//  CSP-vehicleCalculator.h
//  HowToGo
//
//  Created by Thomas Dubiel on 26.08.12.
//  Copyright (c) 2012 Thomas Dubiel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSP-ExtraCharges.h"

@interface CSP_vehicleCalculator : NSObject {
    
    // Instanzvariablen
    double ticketPrice;
    double fuelPrice;
    double everageFuelConsumption;
    double distance;
    double fuelConsumption;
    // double fare;
}

@property (assign) double ticketPrice, fuelPrice, everageFuelConsumption, distance;
@property (readonly) double fuelConsumption;

-(double)calcFare:(BOOL)considerCharges withCharges:(CSP_ExtraCharges *)charges;

@end
