//
//  MyScene.m
//  Flappy Butterfly
//
//  Created by Emrah Küçükkaya on 27/07/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "MyScene.h"
#import "flower_1.h"
#import "flower_2.h"
#import "flower_3.h"
#import "flower_4.h"
#import "flower_5.h"
#import "SKEase.h"

@interface MyScene()

@property (nonatomic,strong) SKAction *spriteAnimation;
@property (nonatomic, strong) SKSpriteNode *butterfly;
@property (nonatomic, strong) SKSpriteNode *backgroundNode;
@property (nonatomic, strong) SKNode *ground;
@property (nonatomic, strong) SKNode *garden;
@property (nonatomic, strong) SKNode *camera;
@property (nonatomic, strong) NSMutableArray* flowerArray;
@property (nonatomic, strong) NSMutableArray* rndPosPool;


@property (nonatomic, strong) SKNode* world;

@end

@implementation MyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.physicsWorld.gravity = CGVectorMake(0.0f, -10.0f);
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
         NSLog(@"SKScene:initWithSize %f x %f",size.width,size.height);
        
        //[self initGardenWithWidth:1000];
        [self initWorld];
    }
    return self;
}

- (void)initWorld {
    // set clouds
    self.backgroundNode = [SKSpriteNode spriteNodeWithImageNamed:@"backgroundG.png"];
    self.backgroundNode.position = CGPointMake(self.size.width/2, self.size.height/2);
    [self addChild:self.backgroundNode];
    
    self.world = [[SKNode alloc] init];
    [self addChild:self.world];
    
    self.camera = [SKNode node];
    [self.world addChild:self.camera];
    
    // fill pos pool
    self.rndPosPool = [@[] mutableCopy];
    for (int i =0 ; i < 10000; i += 100) {
        [self.rndPosPool addObject:[NSNumber numberWithInt:i]];
    }
    
    [self initGardenWithWidth:10000];
    [self addButterfly];
}

- (void)addButterfly {
    
    self.butterfly = [SKSpriteNode spriteNodeWithImageNamed:@"butterfly2.png"];
    
    self.butterfly.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.butterfly.frame.size.width/10];
    self.butterfly.physicsBody.friction = 10.0f;
    self.butterfly.physicsBody.restitution = 0.1f;
    self.butterfly.physicsBody.linearDamping = 5.0f;
    self.butterfly.physicsBody.allowsRotation = NO;
    self.butterfly.physicsBody.mass = 1;
    
    [self.world addChild:self.butterfly];
    self.butterfly.position = CGPointMake(self.frame.size.width/2, self.size.height/2);
    
    NSMutableArray *textures = [NSMutableArray arrayWithCapacity:10];
    for (int i = 1; i < 11; i++)
    {
        NSString *textureName = [NSString stringWithFormat:@"butterfly%d", i];
        SKTexture *texture = [SKTexture textureWithImageNamed:textureName];
        [textures addObject:texture];
    }
    self.spriteAnimation = [SKAction animateWithTextures:textures timePerFrame:0.03];
    
}

- (void)initGardenWithWidth:(CGFloat)gwidth {
    
    self.ground = [[SKNode alloc] init];
    self.ground.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(gwidth, 50.0f)];
    self.ground.physicsBody.dynamic = NO;
    [self.world addChild:self.ground];
    
    self.ground.position = CGPointMake(self.frame.size.width/2, 0);
    
    // add flowers
    [self addFlowers:30 gWidth:gwidth];
}

- (void)addFlowers:(int)count gWidth:(CGFloat)gWidth{
    
    for (int i=0; i < count; i++) {
        int rndValue = 1 + arc4random() % 4;
        
        SKSpriteNode* flower;
        if (rndValue == 1) {
            flower = [[flower_1 alloc] initWithGround:self.ground atPoint:CGPointMake([[self getRndFlowerPosWithRange] floatValue], self.ground.position.y) inScene:self inNode:self.world];
        } else if (rndValue == 2) {
            flower = [[flower_2 alloc] initWithGround:self.ground atPoint:CGPointMake([[self getRndFlowerPosWithRange] floatValue], self.ground.position.y) inScene:self inNode:self.world];
        } else if (rndValue == 3) {
            flower = [[flower_3 alloc] initWithGround:self.ground atPoint:CGPointMake([[self getRndFlowerPosWithRange] floatValue], self.ground.position.y) inScene:self inNode:self.world];
        } else if (rndValue == 4) {
            flower = [[flower_4 alloc] initWithGround:self.ground atPoint:CGPointMake([[self getRndFlowerPosWithRange] floatValue], self.ground.position.y) inScene:self inNode:self.world];
        } else if (rndValue == 5) {
            flower = [[flower_5 alloc] initWithGround:self.ground atPoint:CGPointMake([[self getRndFlowerPosWithRange] floatValue], self.ground.position.y) inScene:self inNode:self.world];
        }
        
        [self.flowerArray addObject:flower];
    }
    
}

- (NSNumber*)getRndFlowerPosWithRange {
    
    int randomIndex= random()%[self.rndPosPool count];
    NSNumber* randomNumber=[self.rndPosPool objectAtIndex: randomIndex];
    [self.rndPosPool removeObjectAtIndex: randomIndex];
    
    return randomNumber;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        [self flyButterfly:location];
        SKAction *repeat = [SKAction repeatAction:self.spriteAnimation count:1];
        [self.butterfly runAction:repeat];
    }
}

-(void)flyButterfly:(CGPoint)touchLocation {
    CGFloat flyDirection = (touchLocation.x - self.frame.size.width/2);
    SKAction* action;
    
    CGFloat flyStep;
    
    if (flyDirection > 0) {
        self.butterfly.xScale = 1;
        flyStep = self.garden.position.x - 50;
        action = [SKEase MoveToWithNode:self.garden
                           EaseFunction:CurveTypeSine
                                   Mode:EaseIn Time:.3f
                               ToVector:CGVectorMake(flyStep, self.garden.position.y)];
    } else {
        self.butterfly.xScale = -1;
        flyStep = self.garden.position.x + 50;
        action = [SKEase MoveToWithNode:self.garden
                           EaseFunction:CurveTypeSine
                                   Mode:EaseIn Time:.3f
                               ToVector:CGVectorMake(flyStep, self.garden.position.y)];
    }
    
    self.butterfly.physicsBody = self.butterfly.physicsBody;
    CGVector flyImpulse;
    
    if (self.butterfly.frame.origin.y < 450) {
        flyImpulse = CGVectorMake(flyDirection, 400.0f);
    } else {
        flyImpulse = CGVectorMake(flyDirection, 200.0f);
    }
    
    [self.butterfly.physicsBody applyImpulse:flyImpulse];
}

- (void)didSimulatePhysics
{
    self.camera.position = CGPointMake(self.butterfly.position.x-self.frame.size.width/2, self.camera.position.y);
    [self centerOnNode:self.camera];
}

- (void) centerOnNode: (SKNode *) node
{
    CGPoint cameraPositionInScene = [node.scene convertPoint:node.position fromNode:node.parent];
    node.parent.position = CGPointMake(node.parent.position.x - cameraPositionInScene.x, node.parent.position.y - cameraPositionInScene.y);
}

@end
