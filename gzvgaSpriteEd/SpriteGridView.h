//
//  SpritesGridView.h
//  gzvgaSpriteEd
//
//  Created by Janis Dancis on 11/24/20.
//  Copyright © 2020 Janis Dancis. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SpriteGrid.h"

NS_ASSUME_NONNULL_BEGIN

@interface SpriteGridView : NSView

@property (nonatomic) SpriteGrid *spriteGrid;

@end

NS_ASSUME_NONNULL_END
