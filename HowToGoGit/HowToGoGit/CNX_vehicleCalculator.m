//
//  CSP-vehicleCalculator.m
//  HowToGo
//
//  Created by Thomas Dubiel on 26.08.12.
//  Copyright (c) 2012 Thomas Dubiel. All rights reserved.
//

#import "CNX_vehicleCalculator.h"

@implementation CNX_vehicleCalculator

@synthesize ticketPrice, fuelPrice, everageFuelConsumption, distance;
@synthesize fuelConsumption;

-(double)fuelConsumption {
    return self.everageFuelConsumption * self.distance / 100;
}

-(double)calcFare:(BOOL)considerCharges withCharges:(CNX_ExtraCharges *)charges {
    
    if (considerCharges == YES) {
        
        CNX_ExtraCharges *charges = [[CNX_ExtraCharges alloc] init];
        
        return self.fuelConsumption * self.fuelPrice + ( ( charges.chargesPerKM + charges.deprication ) * self.distance );
    }
    else {
        return self.fuelConsumption * self.fuelPrice;
    }
}

@end
