//
//  CSP_AppDelegate.m
//  HowToGoGit
//
//  Created by Thomas Dubiel on 31.08.12.
//  Copyright (c) 2012 Thomas Dubiel. All rights reserved.
//

#import "CNX_AppDelegate.h"

@implementation CNX_AppDelegate

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
    // get values from view ans store in class variables
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
@end
