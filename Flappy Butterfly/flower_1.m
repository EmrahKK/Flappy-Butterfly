//
//  flower_1.m
//  Flappy Butterfly
//
//  Created by Emrah Küçükkaya on 27/07/14.
//  Copyright (c) 2014 Emrah Küçükkaya. All rights reserved.
//

#import "flower_1.h"

@implementation flower_1

- (instancetype)initWithGround:(SKNode*)ground atPoint:(CGPoint)point inScene:(SKScene*)scene inNode:(SKNode*)node {
    if (self = [super init]) {
        self = [flower_1 spriteNodeWithImageNamed:@"fl12"];
        
        // create physics body
        CGFloat offsetX = self.frame.size.width * self.anchorPoint.x;
        CGFloat offsetY = self.frame.size.height * self.anchorPoint.y;
        
        CGMutablePathRef path = CGPathCreateMutable();
        
        CGPathMoveToPoint(path, NULL, 90 - offsetX, 262 - offsetY);
        CGPathAddLineToPoint(path, NULL, 120 - offsetX, 262 - offsetY);
        CGPathAddLineToPoint(path, NULL, 120 - offsetX, 0 - offsetY);
        CGPathAddLineToPoint(path, NULL, 90 - offsetX, 0 - offsetY);
        
        CGPathCloseSubpath(path);
        
        self.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:path];
        self.physicsBody.mass = 2.0f;
        
        [node addChild:self];
        
        float m_DampingRatio = 5.0f;
        float m_Stiffness = 1.5f;
        
        self.position = CGPointMake(point.x, point.y + self.frame.size.height/2);
        
        CGFloat px = point.x + 10;
        
        // create a joint between two bodies
        
        SKPhysicsJointPin *joint = [SKPhysicsJointPin jointWithBodyA:self.physicsBody
                                                               bodyB:ground.physicsBody
                                                              anchor:CGPointMake(px, self.position.y - self.frame.size.height/2)];
        
        SKPhysicsJointSpring *springJointLeft = [SKPhysicsJointSpring jointWithBodyA:self.physicsBody
                                                                               bodyB:ground.physicsBody
                                                                             anchorA:CGPointMake(px, ground.position.y + 100)
                                                                             anchorB:CGPointMake(px - 100, ground.position.y)];
        
        SKPhysicsJointSpring *springJointRight = [SKPhysicsJointSpring jointWithBodyA:self.physicsBody
                                                                                bodyB:ground.physicsBody
                                                                              anchorA:CGPointMake(px, ground.position.y + 100)
                                                                              anchorB:CGPointMake(px + 100, ground.position.y)];
        springJointLeft.damping = m_DampingRatio;
        springJointLeft.frequency = m_Stiffness;
        
        springJointRight.damping = m_DampingRatio;
        springJointRight.frequency = m_Stiffness;
        
        [scene.physicsWorld addJoint:joint];
        [scene.physicsWorld addJoint:springJointLeft];
        [scene.physicsWorld addJoint:springJointRight];
    }
    return self;
}

@end
