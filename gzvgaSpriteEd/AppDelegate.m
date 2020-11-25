//
//  AppDelegate.m
//  gzvgaSpriteEd
//
//  Created by Janis Dancis on 11/24/20.
//  Copyright © 2020 Janis Dancis. All rights reserved.
//

#import "AppDelegate.h"
#import "SpriteGrid.h"
#import "SpriteGridView.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;

@property (weak) IBOutlet SpriteGridView *view;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application    
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (IBAction)newDocument:(id)sender {
    NSLog(@"create new document: %@", self.view);
    self.view.spriteGrid = [SpriteGrid new];
    self.window.title = self.view.spriteGrid.url ?
        [self.view.spriteGrid.url lastPathComponent] : @"Unsaved *";
    [self.view setNeedsDisplay:true];
}

- (IBAction)openDocument:(id)sender {
    NSLog(@"open document: %@", self.view);
    NSOpenPanel* panel = [NSOpenPanel openPanel];
    [panel setAllowedFileTypes:@[@"spr"]];
    [panel beginSheetModalForWindow:self.window completionHandler:^(NSInteger result){
        if (result == NSFileHandlingPanelOKButton) {
            NSURL*  theDoc = [[panel URLs] objectAtIndex:0];
            
            // Open  the document.
            NSLog(@"Selected document to open: %@", theDoc);

            self.view.spriteGrid = [SpriteGrid loadFromURL:theDoc];
            self.window.title = [self.view.spriteGrid.url lastPathComponent];
            [self.view setNeedsDisplay:true];
        }
        
    }];

}

- (IBAction)saveDocument:(id)sender {
    NSLog(@"save document: %@", self.view);
    if (self.view.spriteGrid.url) {
        NSLog(@"saving existing document: %@", self.view);
        [self.view.spriteGrid saveToURL:self.view.spriteGrid.url];
    } else {
        [self saveDocumentAs:sender];
    }
}

- (IBAction)saveDocumentAs:(id)sender {
    NSLog(@"save document as: %@", self.view);
    NSSavePanel* panel = [NSSavePanel savePanel];
    [panel setNameFieldStringValue:@"mysprite.spr"];
    [panel beginSheetModalForWindow:self.window completionHandler:^(NSInteger result){
        if (result == NSFileHandlingPanelOKButton) {
            NSURL*  theFile = [panel URL];
            
            // Open  the document.
            NSLog(@"Writing document to open: %@", theFile);
            [self.view.spriteGrid saveToURL:theFile];
            self.window.title = [self.view.spriteGrid.url lastPathComponent];
            [self.view setNeedsDisplay:true];
        }
        
    }];
}


@end
