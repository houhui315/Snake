//
//  PlayGame.h
//  Snake
//
//  Created by MacBook on 11-10-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface PlayGame : CCLayer {
    CCArray *snakes; //蛇
    int snakeLength;     //蛇的长度
    float  snakeWidth;  //蛇的图片边长
    CGSize screenSize;  //屏幕的尺寸
    CCSprite *food;     //食物
    int widthNum;       //蛇在x轴能走几步
    int heightNum;      //蛇在y轴能走几步
    int x;        //蛇当前的x坐标
    int y;        //蛇当前的y坐标
    CCMenu *pausem;  //暂停
    CCMenu *resumem;    //开始
}
+(CCScene *) scene;
@end
