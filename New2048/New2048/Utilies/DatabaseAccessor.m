//
//  DatabaseAccessor.m
//  New2048
//
//  Created by Chen Xiangwen on 17/4/14.
//  Copyright (c) 2014 Chen Xiangwen. All rights reserved.
//

#import "DatabaseAccessor.h"
#import "New2048AppDelegate.h"



@interface DatabaseAccessor()
{
    NSManagedObjectContext * _managedObjectContext;
}

@property(nonatomic, strong) NSManagedObjectContext * managedObjectContext;

- (void)saveContent;
@end

DatabaseAccessor * databaseAccessor;

@implementation DatabaseAccessor

@synthesize managedObjectContext = _managedObjectContext;

+ (id)sharedInstance
{
    if (!databaseAccessor)
    {
        databaseAccessor = [[DatabaseAccessor alloc] init];
        New2048AppDelegate *appDelegate = (New2048AppDelegate *)[UIApplication sharedApplication].delegate;
        databaseAccessor.managedObjectContext = appDelegate.managedObjectContext;
    }
    return databaseAccessor;
}


- (void)saveGame:(enum PieceState [gameDimension][gameDimension])state score:(int)score indicator:(BOOL)indicator
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"GameState" inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    
    NSError *error = nil;
    NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (error) {
        // handle error
    }
    else
    {
        if ([results count] > 0) {
            NSManagedObject *object = [results objectAtIndex:0];
            
            [object setValue:[NSNumber numberWithBool:indicator] forKey:@"indicator"];
            NSNumber * bestScore = [object valueForKey:@"bestScore"];
            [object setValue:[NSNumber numberWithInt:score] forKey:@"currentScore"];
            // update the score
            if ([bestScore intValue] < score) {
                [object setValue:[NSNumber numberWithInt:score] forKey:@"bestScore"];
            }

            if (indicator) {
                // update the game state
                NSMutableArray * stateArry = [[NSMutableArray alloc] init];
                for (int i = 0; i < gameDimension;i++) {
                    for (int j = 0; j < gameDimension; j++) {
                        NSNumber * scoreNum = [NSNumber numberWithInt: state[i][j]];
                        [stateArry addObject:scoreNum];
                    }
                }
                [object setValue:stateArry forKey:@"gameState"];
            }
        }
        else
        {
            NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:@"GameState" inManagedObjectContext:_managedObjectContext];
            
            // If appropriate, configure the new managed object.
            // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
            [newManagedObject setValue:[NSNumber numberWithBool:indicator] forKey:@"indicator"];
            NSMutableArray * stateArry = [[NSMutableArray alloc] init];
            for (int i = 0; i < gameDimension;i++) {
                for (int j = 0; j < gameDimension; j++) {
                    NSNumber * scoreNum = [NSNumber numberWithInt: state[i][j]];
                    [stateArry addObject:scoreNum];
                }
            }
            [newManagedObject setValue:stateArry forKey:@"gameState"];
            [newManagedObject setValue:[NSNumber numberWithInt:score] forKey:@"bestScore"];
            [newManagedObject setValue:[NSNumber numberWithInt:score] forKey:@"currentScore"];

        }
    }
    // save the updates;
    [self saveContent];
    
}

- (BOOL)restoreGameState:(enum PieceState [gameDimension][gameDimension])state score:(int *)bestScore currentScore:(int *)currentScore
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"GameState" inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    
    NSError *error = nil;
    NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (error) {
        // handle error
    }
    else
    {
        if ([results count] > 0) {
            NSManagedObject *object = [results objectAtIndex:0];
            NSNumber * indicatorNum = [object valueForKey:@"indicator"];
            BOOL indicator = [indicatorNum boolValue];
            
            if (indicator) {
                // update the score
                NSMutableArray * gameState = [object valueForKey:@"gameState"];
                for(int i = 0; i < [gameState count]; i++)
                {
                    if (i < 16) {
                        int row = i / ((int)gameDimension);
                        int col = i % ((int)gameDimension);
                        NSNumber * stateNum = [gameState objectAtIndex:i];
                        state[row][col] = [stateNum intValue];
                    }
                }
                *bestScore = [[object valueForKey:@"bestScore"] intValue];
                *currentScore = [[object valueForKey:@"currentScore"] intValue];
                return YES;
            }
            else
            {
                *bestScore = [[object valueForKey:@"bestScore"] intValue];
                *currentScore = [[object valueForKey:@"currentScore"] intValue];
                return NO;
            }
        }
        else
        {
            return NO;
        }
    }
    return NO;
    
}

- (void)saveContent
{
    // Save the context.
    NSError *error = nil;
    if (![_managedObjectContext save:&error]) {
        // NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
}
@end
