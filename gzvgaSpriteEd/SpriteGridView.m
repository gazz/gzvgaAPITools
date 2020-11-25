//
//  SpritesGridView.m
//  gzvgaSpriteEd
//
//  Created by Janis Dancis on 11/24/20.
//  Copyright © 2020 Janis Dancis. All rights reserved.
//

#import "SpriteGridView.h"

@implementation SpriteGridView

NSDictionary *paletteLookup;

- (void)awakeFromNib {
    [super awakeFromNib];
    
    paletteLookup = @{[NSNumber numberWithInt:0]: [NSColor colorWithSRGBRed:0 green:0 blue:0 alpha:1],
                      [NSNumber numberWithInt:1]: [NSColor colorWithSRGBRed:1 green:1 blue:1 alpha:1],
                      [NSNumber numberWithInt:2]: [NSColor colorWithSRGBRed:1 green:0 blue:0 alpha:1],
                      [NSNumber numberWithInt:3]: [NSColor colorWithSRGBRed:0 green:1 blue:0 alpha:1],
                      [NSNumber numberWithInt:4]: [NSColor colorWithSRGBRed:0 green:0 blue:1 alpha:1],
                      [NSNumber numberWithInt:5]: [NSColor colorWithSRGBRed:1 green:0 blue:1 alpha:1],
                      [NSNumber numberWithInt:6]: [NSColor colorWithSRGBRed:0 green:1 blue:1 alpha:1],
                      [NSNumber numberWithInt:7]: [NSColor colorWithSRGBRed:1 green:1 blue:0 alpha:1],
                      
                      [NSNumber numberWithInt:8]: [NSColor colorWithSRGBRed:0.25 green:0.25 blue:0.25 alpha:1],
                      [NSNumber numberWithInt:9]: [NSColor colorWithSRGBRed:0.5 green:0.5 blue:0.5 alpha:1],
                      [NSNumber numberWithInt:10]: [NSColor colorWithSRGBRed:0.5 green:0 blue:0 alpha:1],
                      [NSNumber numberWithInt:11]: [NSColor colorWithSRGBRed:0 green:0.5 blue:0 alpha:1],
                      [NSNumber numberWithInt:12]: [NSColor colorWithSRGBRed:0 green:0 blue:0.5 alpha:1],
                      [NSNumber numberWithInt:13]: [NSColor colorWithSRGBRed:0.5 green:0 blue:0.5 alpha:1],
                      [NSNumber numberWithInt:14]: [NSColor colorWithSRGBRed:0 green:0.5 blue:0.5 alpha:1],
                      [NSNumber numberWithInt:15]: [NSColor colorWithSRGBRed:0.5 green:0.5 blue:0 alpha:1]};
    
    SpriteGrid *sprites = [[SpriteGrid alloc] initWithSpriteCount:85 perRow:17];
    self.spriteGrid = sprites;

}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];

    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
    [[NSColor colorWithSRGBRed:0 green:0 blue:0 alpha:0.8] setFill];
    CGContextFillRect(context, dirtyRect);
    
    NSColor *gridBase = [NSColor colorWithSRGBRed:1 green:1 blue:1 alpha:1];

    int spritePixelLinesPerSprite = 12;
    int spritePixelColsPerSprite = 10;
    int spriteRows = self.spriteGrid.spriteCount / self.spriteGrid.spritesPerRow;
    int spriteColumns = self.spriteGrid.spritesPerRow;
    
    float pixelsPerSpriteCol = [self bounds].size.width / (spriteColumns * spritePixelColsPerSprite);
    float pixelsPerSpriteRow = [self bounds].size.height / (spriteRows * spritePixelLinesPerSprite);
    
    for (int sIdx = 0; sIdx < self.spriteGrid.spriteCount; sIdx++) {
        float spriteHorOffset = (sIdx % spriteColumns) * spritePixelColsPerSprite * pixelsPerSpriteCol;
        float spriteVerOffset = (sIdx / spriteColumns) * spritePixelLinesPerSprite * pixelsPerSpriteRow;
        for (int pIdx = 0; pIdx < spritePixelColsPerSprite * spritePixelLinesPerSprite; pIdx++) {
            int xIdx = pIdx % spritePixelColsPerSprite;
            int yIdx = pIdx / spritePixelColsPerSprite;
            int paletteIdx = [self.spriteGrid paletteIndexForSprite:sIdx atX:xIdx atY:yIdx];
            [[paletteLookup objectForKey:[NSNumber numberWithInt:paletteIdx]] setFill];
            NSRectFill(NSMakeRect(spriteHorOffset + xIdx * pixelsPerSpriteCol,
                                  spriteVerOffset + yIdx * pixelsPerSpriteRow,
                                  pixelsPerSpriteCol, pixelsPerSpriteRow));
        }
    }
    
    
    // grid
    for (int i = 1; i < spriteRows * spritePixelLinesPerSprite; i++) {
        if (i % spritePixelLinesPerSprite == 0) {
            [[gridBase colorWithAlphaComponent:0.3] set];
        } else {
            [[gridBase colorWithAlphaComponent:0.1] set];
        }
        float yOffset = i * pixelsPerSpriteRow - 0.5;

        [NSBezierPath strokeLineFromPoint:NSMakePoint(0, yOffset)
                                  toPoint:NSMakePoint([self bounds].size.width, yOffset)];
    }
    
    for (int i = 1; i < spriteColumns * spritePixelColsPerSprite; i++) {
        if (i % spritePixelColsPerSprite == 0) {
            [[gridBase colorWithAlphaComponent:0.3] set];
        } else {
            [[gridBase colorWithAlphaComponent:0.1] set];
        }
        float xOffset = i * pixelsPerSpriteCol - 0.5;
        
        [NSBezierPath strokeLineFromPoint:NSMakePoint(xOffset, 0)
                                  toPoint:NSMakePoint(xOffset, [self bounds].size.height)];
    }
}

- (BOOL)isFlipped {
    return true;
}

- (void)markSpritePixels:(NSPoint)point withPaletteIndex:(int)paletteIndex {
    // calculate where the click was and mark the sprite pixel
    NSPoint p = [self convertPoint:point fromView:nil];
    
    int spritePixelLinesPerSprite = 12;
    int spritePixelColsPerSprite = 10;
    int spriteRows = self.spriteGrid.spriteCount / self.spriteGrid.spritesPerRow;
    int spriteColumns = self.spriteGrid.spritesPerRow;
    
    float pixelsPerSpriteCol = [self bounds].size.width / (spriteColumns * spritePixelColsPerSprite);
    float pixelsPerSpriteRow = [self bounds].size.height / (spriteRows * spritePixelLinesPerSprite);
    
    int xIndex = p.x / pixelsPerSpriteCol;
    int yIndex = p.y / pixelsPerSpriteRow;
    int spriteIndex = xIndex / spritePixelColsPerSprite + (yIndex / spritePixelLinesPerSprite) * self.spriteGrid.spritesPerRow;
    
    int pixelX = xIndex % spritePixelColsPerSprite;
    int pixelY = yIndex % spritePixelLinesPerSprite;
    
    [self.spriteGrid setPaletteIndexForSprite:spriteIndex atX:pixelX atY:pixelY paletteIndex:paletteIndex];
}

- (void)shiftSprites:(NSPoint)point offset:(int)offset {
    NSPoint p = [self convertPoint:point fromView:nil];
    
    int spritePixelLinesPerSprite = 12;
    int spritePixelColsPerSprite = 10;
    int spriteRows = self.spriteGrid.spriteCount / self.spriteGrid.spritesPerRow;
    int spriteColumns = self.spriteGrid.spritesPerRow;
    
    float pixelsPerSpriteCol = [self bounds].size.width / (spriteColumns * spritePixelColsPerSprite);
    float pixelsPerSpriteRow = [self bounds].size.height / (spriteRows * spritePixelLinesPerSprite);
    
    int xIndex = p.x / pixelsPerSpriteCol;
    int yIndex = p.y / pixelsPerSpriteRow;
    int spriteIndex = xIndex / spritePixelColsPerSprite + (yIndex / spritePixelLinesPerSprite) * self.spriteGrid.spritesPerRow;

    [self.spriteGrid shiftSpritesAtIndex:spriteIndex offset:offset];
}

- (void)mouseDragged:(NSEvent *)theEvent {
    if (theEvent.modifierFlags == 0) {
        [self markSpritePixels:[theEvent locationInWindow] withPaletteIndex:1];
        [self setNeedsDisplay:YES];
    }
}

- (void)rightMouseDragged:(NSEvent *)theEvent {
    if (theEvent.modifierFlags == 0) {
        [self markSpritePixels:[theEvent locationInWindow] withPaletteIndex:0];
        [self setNeedsDisplay:YES];
    }
}

- (void)mouseUp:(NSEvent *)theEvent {
    if (theEvent.modifierFlags & NSEventModifierFlagOption) {
        // shift sprites right at position
        [self shiftSprites:[theEvent locationInWindow] offset:-1];
    } else {
        [self markSpritePixels:[theEvent locationInWindow] withPaletteIndex:1];
    }
    [self setNeedsDisplay:YES];
}

- (void)rightMouseUp:(NSEvent *)theEvent {
    if (theEvent.modifierFlags & NSEventModifierFlagOption) {
        // shift sprites left at position
        [self shiftSprites:[theEvent locationInWindow] offset:1];
    } else {
        [self markSpritePixels:[theEvent locationInWindow] withPaletteIndex:0];
    }
    [self setNeedsDisplay:YES];
}


@end
