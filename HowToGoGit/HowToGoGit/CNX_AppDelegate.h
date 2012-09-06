//
//  CSP_AppDelegate.h
//  HowToGoGit
//
//  Created by Thomas Dubiel on 31.08.12.
//  Copyright (c) 2012 Thomas Dubiel. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CNX_ExtraCharges.h"
#import "CNX_vehicleCalculator.h"

@interface CNX_AppDelegate : NSObject <NSApplicationDelegate> {
    CNX_ExtraCharges *charges;
    CNX_vehicleCalculator *calculator;
    NSString *fileBus;
    NSString *fileCar;
    BOOL messageSowed;
}

@property (assign) IBOutlet NSWindow *window;

// Berechnung
@property (weak) IBOutlet NSTextFieldCell *fahrPreis;
@property (weak) IBOutlet NSTextField *benzinPreis;
@property (weak) IBOutlet NSTextField *entfernung;
@property (weak) IBOutlet NSButton *checkAlleKosten;
@property (weak) IBOutlet NSTextField *verbrauchBenzin;
@property (weak) IBOutlet NSTextField *kostenFahrt;
@property (weak) IBOutlet NSImageView *imageField;
@property (weak) IBOutlet NSTextField *durchschnittVerbrauch;
@property (weak) IBOutlet NSTextField *ergebnisText;

- (IBAction)calcValueChanged:(id)sender;

// Nebenkosten
@property (weak) IBOutlet NSFormCell *kaufpreis;
@property (weak) IBOutlet NSFormCell *kmProJahr;
@property (weak) IBOutlet NSFormCell *nutzungszeit;
@property (weak) IBOutlet NSFormCell *kmInNutzungszeit;

@property (weak) IBOutlet NSFormCell *versicherung;
@property (weak) IBOutlet NSFormCell *steuer;
@property (weak) IBOutlet NSFormCell *wartung;
@property (weak) IBOutlet NSFormCell *summeNebenkosten;

@property (weak) IBOutlet NSFormCell *wvJeKm;
@property (weak) IBOutlet NSFormCell *nkJeKm;
@property (weak) IBOutlet NSFormCell *kostenJeKm;

- (IBAction)valueChanged:(id)sender;
- (IBAction)allCostsChanged:(id)sender;

// Outlets for testing
@property (weak) IBOutlet NSTextField *testPathBus;
@property (weak) IBOutlet NSTextField *testPathCar;
@property (weak) IBOutlet NSTextField *testfileManagerPath;

@end
