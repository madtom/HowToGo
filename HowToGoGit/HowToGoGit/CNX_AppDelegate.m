//
//  CSP_AppDelegate.m
//  How2Go
//
//  Created by Thomas Dubiel on 31.08.12.
//  Copyright (c) 2012 Thomas Dubiel. All rights reserved.
//

#import "CNX_AppDelegate.h"

@implementation CNX_AppDelegate

@synthesize fahrPreis;
@synthesize benzinPreis;
@synthesize entfernung;
@synthesize checkAlleKosten;
@synthesize verbrauchBenzin;
@synthesize kostenFahrt;
@synthesize imageField;
@synthesize durchschnittVerbrauch;
@synthesize ergebnisText;

@synthesize kaufpreis;
@synthesize kmProJahr;
@synthesize nutzungszeit;
@synthesize kmInNutzungszeit;
@synthesize versicherung;
@synthesize steuer;
@synthesize wartung;
@synthesize summeNebenkosten;
@synthesize wvJeKm;
@synthesize nkJeKm;
@synthesize kostenJeKm;

-(double) kostenProKM {
    return charges.deprication + charges.chargesPerKM;
}

-(NSString *)getKmProJahr {
    NSString *text = [NSString stringWithFormat:@"%i km", charges.milagePerAnno];
    return text;
}

-(NSString *)getNutzungszeit {
    NSString *text = [NSString stringWithFormat:@"%.1f Jahre", charges.lifeTime];
    return text;
}

-(NSString *)getKmInNutzungszeit {
    NSString *text = [NSString stringWithFormat:@"%.0f km", charges.milageLife];
    return text;
}

-(NSString *)getVerbrauch {
    NSString *text = [NSString stringWithFormat:@"%.3f Liter", calculator.fuelConsumption];
    return text;
}

-(void)prepareIcons:(NSFileManager *)fileManager {
    // get handle of File Manager and get current path
    NSString *path = [fileManager currentDirectoryPath];
    // get name of bundle => application name
    NSString *app = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
    
    // set bus picture to attribute
    fileBus = [NSString stringWithFormat:@"%@/%@.app/Contents/Resources/Bus_256.png", path, app];
    fileCar = [NSString stringWithFormat:@"%@/%@.app/Contents/Resources/Car_256.png", path, app];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *appSupport = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dir = [NSString stringWithFormat:@"%@/HowToGo", appSupport];
    NSString *fileName = [dir stringByAppendingPathComponent:@"ExtraCharges.plist"];
    BOOL exist = [fileManager fileExistsAtPath:fileName];
    if ( exist == YES) {
        charges = [NSKeyedUnarchiver unarchiveObjectWithFile:fileName];
    }
    else {
        charges = [CNX_ExtraCharges new];
    }
    
    calculator = [CNX_vehicleCalculator new];
    
    // fill view with class variables
    [kaufpreis setDoubleValue:charges.carPrice];
    [kmProJahr setStringValue:[self getKmProJahr]];
    [nutzungszeit setStringValue:[self getNutzungszeit]];
    [kmInNutzungszeit setStringValue:[self getKmInNutzungszeit]];
    [versicherung setDoubleValue:charges.insurance];
    [steuer setDoubleValue:charges.tax];
    [wartung setDoubleValue:charges.service];
    [summeNebenkosten setDoubleValue:charges.sumCharges];
    [wvJeKm setDoubleValue:charges.deprication];
    [nkJeKm setDoubleValue:charges.chargesPerKM];
    [kostenJeKm setDoubleValue:[self kostenProKM]];
    
    // fill initial values into calculation attributes
    [ergebnisText setStringValue:@""];
    
    // prepare pictures
    [self prepareIcons:fileManager];
}

-(NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {
    // speichern der Daten
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *appSupport = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dir = [NSString stringWithFormat:@"%@/HowToGo", appSupport];
    [fileManager createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *fileName = [dir stringByAppendingPathComponent:@"ExtraCharges.plist"];
    BOOL result = [NSKeyedArchiver archiveRootObject:charges toFile:fileName];
    
    if (result == YES) {
        return NSTerminateNow;
    }
    else {
        return NSTerminateCancel;
    }
}

- (IBAction)valueChanged:(id)sender {
    // get values from view and store in class variables
    [charges setCarPrice:[kaufpreis doubleValue]];
    [charges setInsurance:[versicherung doubleValue]];
    [charges setTax:[steuer doubleValue]];
    [charges setService:[wartung doubleValue]];
    
    // view new values from calculated values
    [summeNebenkosten setDoubleValue:charges.sumCharges];
    [wvJeKm setDoubleValue:charges.deprication];
    [nkJeKm setDoubleValue:charges.chargesPerKM];
    [kostenJeKm setDoubleValue:[self kostenProKM]];
}
- (IBAction)calcValueChanged:(id)sender {
    // get values from view and store in class variables
    double ticketPrice = [fahrPreis doubleValue];
    double fuelPrice = [benzinPreis doubleValue];
    double distance = [entfernung doubleValue];
    double avFuelConsumption = [durchschnittVerbrauch doubleValue];
    [calculator setTicketPrice:ticketPrice];
    [calculator setFuelPrice:fuelPrice];
    [calculator setDistance:distance];
    [calculator setEverageFuelConsumption:avFuelConsumption];
    
    double fare = [calculator calcFare:[checkAlleKosten state] withCharges:charges];
    
    if ( ticketPrice == 0 || fuelPrice == 0 || entfernung == 0 || avFuelConsumption == 0) {
        [verbrauchBenzin setStringValue:@""];
        [kostenFahrt setDoubleValue:0];
        [ergebnisText setStringValue:@""];
        [imageField setHidden:YES];
    }
    else {
        [imageField setHidden:NO];
        [verbrauchBenzin setStringValue:[self getVerbrauch]];
        [kostenFahrt setDoubleValue:fare];
        
        NSImage *bild;
        if ( ticketPrice >= fare ) {
            bild = [[NSImage alloc] initWithContentsOfFile:fileCar];
            [ergebnisText setStringValue:@"Nimm das Auto!"];
        }
        else {
            bild = [[NSImage alloc] initWithContentsOfFile:fileBus];
            [ergebnisText setStringValue:@"Nimm den Bus!"];
        }
    [imageField setImage:bild];
    }
    
}
@end
