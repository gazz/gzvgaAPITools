//
//  SpriteGrid.h
//  gzvgaSpriteEd
//
//  Created by Janis Dancis on 11/24/20.
//  Copyright © 2020 Janis Dancis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface SpriteGrid : NSObject

@property (nonatomic) NSURL *url;
@property (nonatomic) int spriteCount;
@property (nonatomic) int spritesPerRow;

@property (nonatomic) NSMutableArray *sprites;

- (instancetype)initWithSpriteCount:(int)spriteCount
                             perRow:(int)perRow;

- (int)paletteIndexForSprite:(int)spriteIndex atX:(int)xIndex atY:(int)yIndex;
- (void)setPaletteIndexForSprite:(int)spriteIndex atX:(int)xIndex atY:(int)yIndex paletteIndex:(int)paletteIndex;

- (void)shiftSpritesAtIndex:(int)spriteIndex offset:(int)offset;

+ (instancetype)loadFromURL:(NSURL*)url;
- (void)saveToURL:(NSURL*)url;

@end

NS_ASSUME_NONNULL_END
