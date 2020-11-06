//
//  GameOver.m
//  Snake
//
//  Created by MacBook on 11-11-3.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "GameOver.h"
#import "PlayGame.h"


@implementation GameOver
+(CCScene *) scene
{
    CCScene *scene=[CCScene node];
    GameOver *layer=[GameOver node];
    [scene addChild:layer];
    return scene;
}
-(void) onRestart:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionShrinkGrow transitionWithDuration:1 scene:[PlayGame node]]];
}
-(void) onExit:(id)sender
{
    exit(0);
}
-(id) init
{
    if ((self=[super init])) {
        CGSize screenSize=[[CCDirector sharedDirector] winSize];
        CCLabelTTF *label=[CCLabelTTF labelWithString:@"Game Over" fontName:@"Marker Felt" fontSize:64];
        label.position=CGPointMake(screenSize.width*0.5, screenSize.height*0.5);
        [self addChild:label];
        
        CCLabelTTF *restart=[CCLabelTTF labelWithString:@"Play Again" fontName:@"Marker Felt" fontSize:24];
        CCMenuItemLabel *restartMenu=[CCMenuItemLabel itemWithLabel:restart target:self selector:@selector(onRestart:)];
        CCMenu *mRestart=[CCMenu menuWithItems:restartMenu, nil];
        mRestart.position=CGPointMake(300, 100);
        [self addChild:mRestart];
        
        CCLabelTTF *exit=[CCLabelTTF labelWithString:@"Exit" fontName:@"Marker Felt" fontSize:24];
        CCMenuItemLabel *exitMenu=[CCMenuItemLabel itemWithLabel:exit target:self selector:@selector(onExit:)];
        CCMenu *mExit=[CCMenu menuWithItems:exitMenu, nil];
        mExit.position=CGPointMake(100, 100);
        [self addChild:mExit];
    }
    return self;
}
-(void) dealloc
{
    [super dealloc];
}
@end
