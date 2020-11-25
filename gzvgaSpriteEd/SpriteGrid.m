//
//  SpriteGrid.m
//  gzvgaSpriteEd
//
//  Created by Janis Dancis on 11/24/20.
//  Copyright © 2020 Janis Dancis. All rights reserved.
//

#import "SpriteGrid.h"

@interface Sprite : NSObject

@property NSMutableArray *pixels;
@property int columns;

- (int)paletteIndexForX:(int)x y:(int)y;
- (void)setPaletteIndexForX:(int)x y:(int)y paletteIndex:(int)index;
- (NSData *)spriteBytes;

@end

@implementation Sprite

- (instancetype)initWithCols:(int)columns {
    self = [super init];
    self.columns = columns;
    self.pixels = [NSMutableArray arrayWithCapacity:120];
    for (int i = 0; i < 120; i++){
        [self.pixels addObject:[NSNumber numberWithInt:0]];
    }
    return self;
}

- (NSData *)spriteBytes {
    NSMutableData *mutData = [NSMutableData new];
    for (int i = 0; i < 120; i+= 2) {
        char byte = ([[self.pixels objectAtIndex:i] intValue] << 4) +
            ([[self.pixels objectAtIndex:i+1] intValue] & 0xf);
        [mutData appendBytes:&byte length:1];
    }
    return mutData;
}

- (void)setSpriteBytes:(char *)bytes {
    for (int i = 0; i < 60; i++) {
        char byte = bytes[i];
        
        [self.pixels replaceObjectAtIndex:(i*2) withObject:[NSNumber numberWithInt:(byte>>4)]];
        [self.pixels replaceObjectAtIndex:(i*2)+1 withObject:[NSNumber numberWithInt:(byte & 0xf)]];
    }

}

- (int)paletteIndexForX:(int)x y:(int)y {
    return [[self.pixels objectAtIndex:(x + y * self.columns)] intValue];
}

- (void)setPaletteIndexForX:(int)x y:(int)y paletteIndex:(int)index {
    [self.pixels replaceObjectAtIndex:(x + y * self.columns) withObject:[NSNumber numberWithInt:index]];
}

@end


@implementation SpriteGrid

- (instancetype)init {
    self = [self initWithSpriteCount:85 perRow:17];
    return self;
}

- (instancetype)initWithSpriteCount:(int)spriteCount
                             perRow:(int)perRow {
    self = [super init];
    self.spriteCount = spriteCount;
    self.spritesPerRow = perRow;
    self.sprites = [NSMutableArray arrayWithCapacity:spriteCount];
    // prefill
    for (int i = 0; i < spriteCount; i++) {
        [self.sprites addObject:[[Sprite alloc] initWithCols:10]];
    }
    return self;
}

- (int)paletteIndexForSprite:(int)spriteIndex atX:(int)xIndex atY:(int)yIndex {
    return [[self.sprites objectAtIndex:spriteIndex] paletteIndexForX:xIndex y:yIndex];
}


- (void)setPaletteIndexForSprite:(int)spriteIndex atX:(int)xIndex atY:(int)yIndex paletteIndex:(int)paletteIndex {
    [[self.sprites objectAtIndex:spriteIndex] setPaletteIndexForX:xIndex y:yIndex paletteIndex:paletteIndex];
}

- (void)setSprite:(int)spriteIndex fromBytes:(char *)bytes {
    [[self.sprites objectAtIndex:spriteIndex] setSpriteBytes:bytes];
}

+ (instancetype)loadFromURL:(NSURL*)url {
    SpriteGrid *obj = [[self alloc] init];
    obj.url = url;
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    char bytes[60];
    for (int i = 0; i < obj.spriteCount; i++) {
        [data getBytes:bytes range:NSMakeRange(i * 60, 60)];
        [obj setSprite:i fromBytes:bytes];
    }

    // read fom the binay file
    return obj;
}

- (void)saveToURL:(NSURL*)url {
    self.url = url;

    NSMutableData *mutableData = [NSMutableData new];
    for (Sprite *sprite in self.sprites) {
        [mutableData appendData:[sprite spriteBytes]];
    }
    
    [mutableData writeToURL:self.url atomically:true];
}

- (void)shiftSpritesAtIndex:(int)spriteIndex offset:(int)offset {
    NSArray *untouchedSprites = [self.sprites subarrayWithRange:(NSRange){.location = 0, .length = spriteIndex}];
    
    NSArray *shiftedSprites;
    NSLog(@"Doing shift from sprite: %d, with offset: %d", spriteIndex, offset);
    if (offset >= 0) {
        NSLog(@"Doing positive shift");
        shiftedSprites = [[self.sprites subarrayWithRange:(NSRange){.location = spriteIndex + offset, .length = self.spriteCount - spriteIndex - offset}]
                          arrayByAddingObjectsFromArray:[self.sprites subarrayWithRange:(NSRange){.location = spriteIndex, .length = offset}]];
    } else {
        NSLog(@"Doing negative shift");
        shiftedSprites = [[self.sprites subarrayWithRange:(NSRange){.location = self.spriteCount - abs(offset), .length = abs(offset)}]
                          arrayByAddingObjectsFromArray:[self.sprites subarrayWithRange:(NSRange){.location = spriteIndex, .length = self.spriteCount - spriteIndex}]];
    }
    
    self.sprites = [[untouchedSprites arrayByAddingObjectsFromArray:shiftedSprites] mutableCopy];
}

@end
