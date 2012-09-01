//
//  CSP_AppDelegate.h
//  HowToGoGit
//
//  Created by Thomas Dubiel on 31.08.12.
//  Copyright (c) 2012 Thomas Dubiel. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CNX_ExtraCharges.h"

@interface CNX_AppDelegate : NSObject <NSApplicationDelegate> {
    CNX_ExtraCharges *charges;
}

@property (assign) IBOutlet NSWindow *window;

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

@end
