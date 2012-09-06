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

-(void)openArchives:(NSFileManager *)fileManager {
    // get Application Support path
    NSString *appSupport = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    // build path for archive files
    NSString *dir = [NSString stringWithFormat:@"%@/How2Go", appSupport];
    // build file names for vehicle and charges archive
    NSString *fileNameCharges = [dir stringByAppendingPathComponent:@"ExtraCharges.plist"];
    NSString *fileNameVehicle = [dir stringByAppendingPathComponent:@"VehicleCalculation.plist"];
    BOOL chargesExist = [fileManager fileExistsAtPath:fileNameCharges];
    BOOL vehicleExist = [fileManager fileExistsAtPath:fileNameVehicle];
    // if file exist, load data otherwise create a new empty object instance
    if ( chargesExist == YES) {
        charges = [NSKeyedUnarchiver unarchiveObjectWithFile:fileNameCharges];
    }
    else {
        charges = [CNX_ExtraCharges new];
    }
    
    if (vehicleExist == YES) {
        calculator = [NSKeyedUnarchiver unarchiveObjectWithFile:fileNameVehicle];
    }
    else {
        calculator = [CNX_vehicleCalculator new];
    }
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [self openArchives:fileManager];
    messageSowed = NO;
    
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
    [fahrPreis setDoubleValue:calculator.ticketPrice];
    [benzinPreis setDoubleValue:calculator.fuelPrice];
    [entfernung setDoubleValue:calculator.distance];
    [durchschnittVerbrauch setDoubleValue:calculator.averageFuelConsumption];
    
    // prepare pictures
    [self prepareIcons:fileManager];
    
    [self calcValueChanged:self];
}

-(BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return TRUE;
}

-(NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {
    
    NSInteger button = NSRunAlertPanel(@"How2Go", @"Wollen Sie die eigetragenen Daten sichern?", @"Ja", @"Gespeicherte Löschen", @"Nein");
    
    switch (button) {
        case 1: {  // Ja
            // create a new file manager instance
            NSFileManager *fileManager = [NSFileManager defaultManager];
            // get Application Support path
            NSString *appSupport = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            // build path for archive files and create if not exist
            NSString *dir = [NSString stringWithFormat:@"%@/How2Go", appSupport];
            [fileManager createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil];
            // build file names for vehicle and charges archive
            NSString *fileNameCharges = [dir stringByAppendingPathComponent:@"ExtraCharges.plist"];
            NSString *fileNameVehicle = [dir stringByAppendingPathComponent:@"VehicleCalculation.plist"];
    
            // save data to archive
            BOOL resultCharges = [NSKeyedArchiver archiveRootObject:charges toFile:fileNameCharges];
            BOOL resultVehicle = [NSKeyedArchiver archiveRootObject:calculator toFile:fileNameVehicle];
            if (resultCharges == YES && resultVehicle == YES) {
                return NSTerminateNow;
            }
            else {
                return NSTerminateCancel;
            }
            break;
        }
        case 0: {  // Löschen
            // create a new file manager instance
            NSFileManager *fileManager = [NSFileManager defaultManager];
            // get Application Support path
            NSString *appSupport = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            // build path for archive files and create if not exist
            NSString *dir = [NSString stringWithFormat:@"%@/How2Go", appSupport];
            [fileManager createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil];
            // build file names for vehicle and charges archive
            NSString *fileNameCharges = [dir stringByAppendingPathComponent:@"ExtraCharges.plist"];
            NSString *fileNameVehicle = [dir stringByAppendingPathComponent:@"VehicleCalculation.plist"];
            
            [fileManager removeItemAtPath:fileNameVehicle error:nil];
            [fileManager removeItemAtPath:fileNameCharges error:nil];

            return NSTerminateNow;
        }
        default: {  // Nein
            return NSTerminateNow;
        }
            
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
    [self calcValueChanged:self];
}

- (IBAction)allCostsChanged:(id)sender {
    if ([checkAlleKosten state] == TRUE && messageSowed == YES) {
        messageSowed = NO;
    }
    [self calcValueChanged:self];
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
    [calculator setAverageFuelConsumption:avFuelConsumption];
    
    if ( charges.chargesPerKM == 0 && avFuelConsumption != 0 && messageSowed == NO) {
        NSRunAlertPanel(@"How2Go", @"Es wurden noch keine Nebenkosten erfasst. Daher können sie auch nicht bei der Berechnung berücksichtigt werden!", @"OK", nil, nil);
        messageSowed = YES;
    }
    
    double fare = [calculator calcFare:[checkAlleKosten state] withCharges:charges];
    
    if ( ticketPrice == 0 || fuelPrice == 0 || distance == 0 || avFuelConsumption == 0) {
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
