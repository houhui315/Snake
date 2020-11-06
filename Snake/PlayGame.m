//
//  PlayGame.m
//  Snake
//
//  Created by MacBook on 11-10-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "PlayGame.h"
#import "GameOver.h"


@implementation PlayGame
typedef enum direction
{
    left,right,up,down
}Direction;    //方向
Direction direction;    //定义方向

typedef struct{
    Direction data[4];       //保存用户输入的方向
    int front;       //队列头
    int rear;        //队列尾       
}CirQueue;
CirQueue queue;     //定义队列

+(CCScene *) scene
{
    CCScene *scene=[CCScene node];
    PlayGame *layer=[PlayGame node];
    [scene addChild:layer];
    return scene;
}
-(void) push_Queue:(Direction)d     //入队列
{
    if (queue.rear==4) {           //队列已满,无法增加
        return;
    }
    queue.data[(queue.rear)%4]=d;
    queue.rear=(queue.rear+1)%4;
}
-(void) pop_Queue:(Direction *)d    //出队列
{
    if (queue.front==queue.rear) {     //队列为空，无元素弹出
        return;
    }
    *d=queue.data[queue.front];
    queue.front=(queue.front+1)%4;
}
-(void) getTop_Queue:(Direction *)d   //取队列元素
{
    if (queue.front==queue.rear) {
        return;
    }
    *d=queue.data[queue.front];
}
-(void) setFood
{
    int widthRam=random() % widthNum;
    int heightRam=random() % heightNum;
    if (food) {         //如果食物不为空，则重新设置位置
        food.position=CGPointMake(widthRam * snakeWidth+snakeWidth*0.5, heightRam*snakeWidth+snakeWidth*0.5);
        for (int i=0; i<snakeLength; i++) {
            CCSprite *snake=[snakes objectAtIndex:i];
            if (ccpDistance(snake.position, food.position)<20) {        //若食物放在与蛇身上，则重新放食物
                [self setFood];
                CCLOG(@"重新设置食物");
                break;
            }
        }
    }else{          //如果食物为空，则初始化食物
        food=[CCSprite spriteWithFile:@"my_Icon_Small.png"];
        food.position=CGPointMake(widthRam * snakeWidth+snakeWidth*0.5, heightRam*snakeWidth+snakeWidth*0.5);
        [self addChild:food];
    }
}
-(void) gameOver
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionShrinkGrow transitionWithDuration:0.1 scene:[GameOver node]]];
}
-(void) setSnakeMove:(CGPoint)pos             //让蛇移动
{
    CCSprite *tempSnake1,*tempSnake2,*headSnake;
    headSnake=[snakes objectAtIndex:0];
    float actualDiatance=ccpDistance(headSnake.position, food.position);
    if (actualDiatance<snakeWidth*0.8) {    //吃到一个食物，长度加1
        CCSprite *snake=[CCSprite spriteWithFile:@"my_Icon_Small.png"];
        [self addChild:snake];
        [snakes addObject:snake];
        snakeLength++;
        [self setFood];
    }
    for (int i=snakeLength-1; i>0; i--) {        //让蛇全身除头外移动
        tempSnake1=[snakes objectAtIndex:i];
        tempSnake2=[snakes objectAtIndex:i-1];
        tempSnake1.position=tempSnake2.position;
    }
    tempSnake2.position=pos;            //蛇头移动
    for (int i=4; i<snakeLength; i++) {        //让蛇全身除头外移动
        tempSnake1=[snakes objectAtIndex:i];
        if (ccpDistance(tempSnake1.position, tempSnake2.position)==0) {
            //蛇撞到了自己的身体，游戏结束
            CCLOG(@"蛇撞到了自己!");
            [self gameOver];
        }
    }
}
-(void) setSnakePos:(ccTime)delta        //设定蛇头的新坐标并判断是否撞墙
{
    if (queue.front!=queue.rear) {  //对列为空，则不改变方向
        Direction dr;
        [self pop_Queue:&dr];    //队列不为空，则弹出队列元素
        direction=dr;
    }
    CGPoint headpos;
    CCSprite *snakehead=[snakes objectAtIndex:0];
    switch (direction) {
        case left:
            headpos=CGPointMake(snakehead.position.x-snakeWidth, snakehead.position.y);
            x--;
            if (x>=0) {
                [self setSnakeMove:headpos];      //蛇移动
            }else{
                //撞墙了
                [self gameOver];
            }
            break;
        case right:
            headpos=CGPointMake(snakehead.position.x+snakeWidth, snakehead.position.y);
            x++;
            if (x<=widthNum) {
                [self setSnakeMove:headpos];        //蛇移动
            }else{
                //撞墙了
                [self gameOver];
            }
            break;
        case up:
            headpos=CGPointMake(snakehead.position.x, snakehead.position.y+snakeWidth);
            y++;
            if (y<=heightNum) {
                [self setSnakeMove:headpos];        //蛇移动
            }else{
                //撞墙了
                [self gameOver];
            }
            break;
        case down:
            headpos=CGPointMake(snakehead.position.x, snakehead.position.y-snakeWidth);
            y--;
            if (y>=0) {
                [self setSnakeMove:headpos];        //蛇移动
            }else{
                //撞墙了
                [self gameOver];
            }
            break;
    }
}
-(void) onLeft:(id)sender       //点击left
{
    if (direction==right) {     //如果蛇的方向与点击的方向相反
        return;
    }
    Direction dr=left;
    if (dr!=direction) {
        [self push_Queue:dr];       //如果点击的方向与当前蛇的方向不同，则加入队列中
    }
}
-(void) onRight:(id)sender
{
    if (direction==left) {
        return;
    }
    Direction dr=right;
    if (dr!=direction) {
        [self push_Queue:dr];       //如果点击的方向与当前蛇的方向不同，则加入队列中
    }
}
-(void) onUp:(id)sender
{
    if (direction==down) {
        return;
    }
    Direction dr=up;
    if (dr!=direction) {
        [self push_Queue:dr];       //如果点击的方向与当前蛇的方向不同，则加入队列中
    }
}
-(void) onDown:(id)sender
{
    if (direction==up) {
        return;
    }
    Direction dr=down;
    if (dr!=direction) {
        [self push_Queue:dr];       //如果点击的方向与当前蛇的方向不同，则加入队列中
    }
}
-(void) onPause:(id)sender      //暂停
{
    [[CCDirector sharedDirector] pause];
    pausem.visible=false;
    resumem.visible=true;
}
-(void) onResume:(id)sender     //开始
{
    [[CCDirector sharedDirector] resume];
    resumem.visible=false;
    pausem.visible=true;
}
-(void) initLabels          //初始化菜单
{
    CCLabelTTF *left=[CCLabelTTF labelWithString:@"Left" fontName:@"Marker Felt" fontSize:20];
    CCMenuItemLabel *menuleft=[CCMenuItemLabel itemWithLabel:left target:self selector:@selector(onLeft:)];
    CCMenu *leftm=[CCMenu menuWithItems:menuleft, nil];
    leftm.position=CGPointMake(25,50);              //初始化left标签
    [self addChild:leftm z:1];
        
    CCLabelTTF *right=[CCLabelTTF labelWithString:@"Right" fontName:@"Marker Felt" fontSize:20];
    CCMenuItemLabel *menuright=[CCMenuItemLabel itemWithLabel:right target:self selector:@selector(onRight:)];
    CCMenu *rightm=[CCMenu menuWithItems:menuright, nil];
    rightm.position=CGPointMake(75,50);             //初始化right标签
    [self addChild:rightm z:1];
        
    CCLabelTTF *up=[CCLabelTTF labelWithString:@"Up" fontName:@"Marker Felt" fontSize:20];
    CCMenuItemLabel *menuup=[CCMenuItemLabel itemWithLabel:up target:self selector:@selector(onUp:)];
    CCMenu *upm=[CCMenu menuWithItems:menuup, nil];
    upm.position=CGPointMake(50,75);                //初始化up标签
    [self addChild:upm z:1];
        
    CCLabelTTF *down=[CCLabelTTF labelWithString:@"Down" fontName:@"Marker Felt" fontSize:20];
    CCMenuItemLabel *menudown=[CCMenuItemLabel itemWithLabel:down target:self selector:@selector(onDown:)];
    CCMenu *downm=[CCMenu menuWithItems:menudown, nil];
    downm.position=CGPointMake(50,25);              //初始化down标签
    [self addChild:downm z:1];
    
    CCLabelTTF *pause=[CCLabelTTF labelWithString:@"Pause" fontName:@"Marker Felt" fontSize:24];
    CCMenuItemLabel *menuPause=[CCMenuItemLabel itemWithLabel:pause target:self selector:@selector(onPause:)];
    pausem=[CCMenu menuWithItems:menuPause, nil];
    pausem.position=CGPointMake(300, 50);           //初始化pause标签
    [self addChild:pausem z:1];
    pausem.visible=true;
    
    CCLabelTTF *resume=[CCLabelTTF labelWithString:@"Resume" fontName:@"Marker Felt" fontSize:24];
    CCMenuItemLabel *menuResume=[CCMenuItemLabel itemWithLabel:resume target:self selector:@selector(onResume:)];
    resumem=[CCMenu menuWithItems:menuResume, nil];
    resumem.position=CGPointMake(300, 50);        //初始化resume标签
    [self addChild:resumem z:1];
    resumem.visible=false;
}
-(void) initSnakes      //初始化蛇
{
    snakeLength=5;               //初始化蛇长度为5
    snakes=[[CCArray alloc] initWithCapacity:50];  //最大长度为50
    for (int i=0; i<snakeLength; i++) {
        CCSprite *snake=[CCSprite spriteWithFile:@"my_Icon_Small.png"];
        [snakes addObject:snake];
        [self addChild:snake z:0 tag:2];
        snake.position=CGPointMake(snakeWidth*snakeLength-snakeWidth*i-snakeWidth*0.5, screenSize.height*0.5);
    }
    x=snakeLength;      //蛇的x坐标
    y=heightNum*0.5;    //蛇的y坐标
    direction=right;        //初始化方向向右
}
-(void) initQueue       //初始化队列
{
    queue.front=0;
    queue.rear=0;
}
-(id) init
{
    if((self=[super init])){
        screenSize=[[CCDirector sharedDirector] winSize];
        CCSprite *tempsnake=[CCSprite spriteWithFile:@"my_Icon_Small.png"];
        snakeWidth=[tempsnake texture].contentSize.width;      //得到蛇的图片的宽
        
        widthNum=(int)(screenSize.width/snakeWidth);       //蛇在x轴能走几步
        heightNum=(int)(screenSize.height/snakeWidth);     //蛇在y轴能走几步
        
        [self initQueue];       //初始化队列
        [self initLabels];      //初始化标签
        [self initSnakes];      //初始化蛇
        [self setFood];         //设置食物
        [self schedule:@selector(setSnakePos:) interval:0.5f];  //预约函数让蛇移动
    }
    return self;
}
-(void) dealloc
{
    [snakes release];
    snakes=nil;
    [super dealloc];
}
@end
