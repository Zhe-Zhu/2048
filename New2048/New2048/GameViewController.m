//
//  GameViewController.m
//  New2048
//
//  Created by Chen Xiangwen on 17/4/14.
//  Copyright (c) 2014 Chen Xiangwen. All rights reserved.
//

#import "GameViewController.h"
#import "QBAnimationGroup.h"
#import "QBAnimationItem.h"
#import "QBAnimationSequence.h"
#import "Global.h"
#import "DatabaseAccessor.h"

#define pieceSize 59
#define barSize 30
#define marginWidth 13
#define timeDuration 0.5

enum Direction{
    None,
    Up,
    Down,
    Left,
    Right
};



typedef struct{
    int x;
    int y;
}position;

@interface GameViewController ()
{
    __weak UILabel * _score;
    __weak UILabel * _topTitle;
    __weak UIButton * _option;
    __weak UIImageView * _gameBackgroundImageView;
    CGPoint _initTouchPoint;
    // used to store the game state
    enum PieceState gameState[4][4];
    UIImageView * pieces[4][4];
    NSInteger  _finishedCount;
    NSInteger  _animationCount;
    NSMutableArray * _storedSequences;
    int _everBestScore;
    int _currentScore;
    __weak DMAdView * _dmAdView;
    OptionViewController *_optionViewController;
    GameOverViewController * _gameOverViewController;
}

@property(nonatomic, weak) IBOutlet UILabel * score;
@property(nonatomic, weak) IBOutlet UILabel * topTitle;
@property(nonatomic, weak) IBOutlet UIButton* option;
@property(nonatomic, weak) IBOutlet UIImageView* gameBackgroundImageView;
@property(nonatomic, assign) NSInteger finishedCount;
@property(nonatomic, assign) NSInteger animationCount;
@property(nonatomic, strong) NSMutableArray * storedSequences;





- (void)updateScore:(enum PieceState)score;

- (void)updatePieces;

- (enum Direction)calculateDirection:(CGPoint)initPoint endPoint:(CGPoint)endPoint;
- (void)updateGameState:(enum Direction)direction;

- (UIImageView *)generateNewPiece:(int)row andCol:(int)col withState:(enum PieceState)state;

- (position)randomlyChoosePos;

- (void)beginNewGame;

- (BOOL)checkIsGameOver;

//
- (void)handleUpGesture;
- (void)handleDownGesture;
- (void)handleLeftGesture;
- (void)handleRightGesture;

- (void)animationFinished;
@property(nonatomic, weak) DMAdView *dmAdView;
@property(nonatomic, strong) OptionViewController *optionViewController;

- (IBAction)setting:(id)sender;

@end

@implementation GameViewController

@synthesize score = _score;
@synthesize option = _option;
@synthesize topTitle = _topTitle;
@synthesize gameBackgroundImageView = _gameBackgroundImageView;
@synthesize finishedCount = _finishedCount;
@synthesize animationCount = _animationCount;
@synthesize storedSequences = _storedSequences;

@synthesize dmAdView = _dmAdView;
@synthesize optionViewController = _optionViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        // restore the game state
        BOOL indicator = [[DatabaseAccessor sharedInstance] restoreGameState:gameState score:&_everBestScore currentScore:&_currentScore];
        
        if (!indicator) {
            [self beginNewGame];
        }
        //        // for debug
        //        for (int i = 0; i < gameDimension; i++) {
        //            for (int j = 0; j < gameDimension; j++) {
        //                gameState[i][j] = StateNone;
        //            }
        //        }
        //        gameState[1][0] = StateA;
        //        gameState[3][0] = StateC;
        //        gameState[2][0] = StateB;
        //        gameState[3][2] = StateB;
        _storedSequences = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // for debug
    //TODO: improve this code
    
    self.view.backgroundColor = [UIColor colorWithRed:1 green:0.94 blue:0.81 alpha:1];
    _topTitle.textColor = [UIColor colorWithRed:0.87 green:0.7 blue:0.43 alpha:1];
    _score.textColor = [UIColor colorWithRed:0.97 green:0.49 blue:0.21 alpha:1];
    
    // update the UI according to the game state
    
    [self updatePieces];
    
    
    
    
    // Do any additional setup after loading the view from its nib.
    _score.text = [NSString stringWithFormat:@"%d", _currentScore];
    // add ad view
    [self initDmAdView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// track the gesture of the user.
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    CGPoint point = [touch locationInView:_gameBackgroundImageView];
    
    if ([_gameBackgroundImageView pointInside:point withEvent:nil]) {
        _initTouchPoint = point;
    }
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    CGPoint point = [touch locationInView:_gameBackgroundImageView];
    enum Direction direction = [self calculateDirection:_initTouchPoint endPoint:point];
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //        [self updateGameState:direction];
    //    });
    if (direction == StateNone) {
        return;
    }
    if ([_storedSequences count] == 0) {
        _finishedCount = 0;
        _animationCount = 0;
        [_storedSequences addObject:[NSNumber numberWithInt:direction]];
        [self updateGameState:direction];
    }
    else
    {
        [_storedSequences addObject:[NSNumber numberWithInt:direction]];
    }
}

- (enum Direction)calculateDirection:(CGPoint)initPoint endPoint:(CGPoint)endPoint
{
    float dx = endPoint.x - initPoint.x;
    float dy = endPoint.y - initPoint.y;
    float distance = sqrt(dx * dx + dy * dy);
    if (distance < 20) {
        return None;
    }
    
    if (dy < 0 && abs(dy) > abs(dx) ) {
        return Up;
    }
    else if (dy > 0 && abs(dy) > abs(dx) )
    {
        return Down;
    }
    else if (dx > 0 && abs(dx) > abs(dy))
    {
        return Right;
    }
    else if (dx < 0 && abs(dx) > abs(dy))
    {
        return Left;
    }
    else
    {
        return None;
    }
    return None;
    
}

- (void)handleDownGesture
{
    int col, row;
    NSMutableArray * animationMovingArry = [[NSMutableArray alloc] init];
    NSMutableArray * animationMergingArry = [[NSMutableArray alloc] init];
    BOOL shoudGenerateNewPiece = NO;
    for (col = 0; col < gameDimension; col++) {
        
        row = gameDimension - 1;
        int aviablePos = gameDimension;
        enum PieceState neighborPieceState = StateNone;
        while (row >= 0) {
            if (gameState[row][col] == StateNone) {
                row--;
            }
            else
            {
                if (gameState[row][col] == neighborPieceState) {
                    
                    
                    if (row != aviablePos) {
                        neighborPieceState = gameState[row][col];
                        UIImageView * temp = pieces[row][col];
                        // add the animation, merge the same pieces.
                        
                        int temp_row = row;
                        int temp_col = col;
                        int temp_aviablePos = aviablePos;
                        enum PieceState temp_neighborPieceState = neighborPieceState;
                        UIImageView * temp_early = pieces[row][col];
                        UIImageView * temp_late = pieces[aviablePos][col];
                        
                        QBAnimationItem * item_merging = [QBAnimationItem itemWithDuration:timeDuration delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                            temp.center = CGPointMake(temp.center.x, temp.center.y - (temp_row - temp_aviablePos) * (pieceSize + marginWidth));
                        } completion:^(BOOL finished){
                            //remove one duplicated piece
                            [self animationFinished];
                            [temp_early removeFromSuperview];
                            [temp_late removeFromSuperview];
                            [self updateScore:temp_neighborPieceState];
                            pieces[temp_aviablePos][temp_col] = [self generateNewPiece:temp_aviablePos andCol:temp_col withState:temp_neighborPieceState + 1];
                            
                            // do animation;
                            
                            
                        }];
                        [animationMovingArry addObject:item_merging];
                        shoudGenerateNewPiece = YES;
                        // update the game state
                        gameState[aviablePos][col] = gameState[row][col] + 1;
                        neighborPieceState = StateNone;
                        gameState[row][col] = StateNone;
                        pieces[row][col] = nil;
                        
                    }
                    
                    
                }
                else
                {
                    
                    // add the animation
                    UIImageView * temp = pieces[row][col];
                    int temp_row = row;
                    int temp_col = col;
                    aviablePos--;
                    int temp_aviablePos = aviablePos;
                    neighborPieceState = gameState[row][col];
                    if (row != aviablePos) {
                        QBAnimationItem * item = [QBAnimationItem itemWithDuration:timeDuration delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                            
                            temp.center = CGPointMake(temp.center.x, temp.center.y - (temp_row - temp_aviablePos) * (pieceSize + marginWidth));
                        } completion:^(BOOL finished){
                            [self animationFinished];
                        }];
                        
                        
                        [animationMovingArry addObject:item];
                        shoudGenerateNewPiece = YES;
                        
                        pieces[aviablePos][col] = pieces[row][col];
                        pieces[row][col] = nil;
                        gameState[aviablePos][col] = gameState[row][col];
                        gameState[row][col] = StateNone;
                        
                    }
                    
                }
                row--;
            }
            
        }
    }
    UIImageView * randomlyGeneratedPiece = [self randomlyGeneratePiece];
    if (shoudGenerateNewPiece) {
        if (randomlyGeneratedPiece != nil) {
            randomlyGeneratedPiece.alpha = 0;
            
            QBAnimationItem * generateNewPieceAnimation = [QBAnimationItem itemWithDuration:timeDuration delay:timeDuration options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveEaseIn animations:^{
                
                randomlyGeneratedPiece.alpha = 1;
            } completion:^(BOOL finished){
                [self animationFinished];
                
            }];
            
            [animationMovingArry addObject:generateNewPieceAnimation];
        }
    }
    QBAnimationGroup * animationMovingGroup = [QBAnimationGroup groupWithItems:animationMovingArry];
    animationMovingGroup.waitUntilDone = NO;
    _animationCount = [animationMovingGroup.items count];
    if (_animationCount > 0) {
        QBAnimationSequence * sequence = [QBAnimationSequence sequenceWithAnimationGroups:[NSArray arrayWithObjects:animationMovingGroup , nil]];
        [sequence start];
    }
    else
    {
        if ([_storedSequences count] > 0) {
            [_storedSequences removeObjectAtIndex:0];
        }
        if ([_storedSequences count] > 0) {
            _finishedCount = 0;
            _animationCount = 0;
            NSNumber * num = [_storedSequences objectAtIndex:0];
            enum Direction direction = [num intValue];
            [self updateGameState:direction];
        }
    }
}

- (void)handleUpGesture
{
    int col, row;
    NSMutableArray * animationMovingArry = [[NSMutableArray alloc] init];
    NSMutableArray * animationMergingArry = [[NSMutableArray alloc] init];
    BOOL shoudGenerateNewPiece = NO;
    for (col = 0; col < gameDimension; col++) {
        
        row = 0;
        int aviablePos = -1;
        enum PieceState neighborPieceState = StateNone;
        while (row < gameDimension) {
            if (gameState[row][col] == StateNone) {
                row++;
            }
            else
            {
                if (gameState[row][col] == neighborPieceState) {
                    
                    
                    if (row != aviablePos) {
                        neighborPieceState = gameState[row][col];
                        UIImageView * temp = pieces[row][col];
                        // add the animation, merge the same pieces.
                        
                        int temp_row = row;
                        int temp_col = col;
                        int temp_aviablePos = aviablePos;
                        enum PieceState temp_neighborPieceState = neighborPieceState;
                        UIImageView * temp_early = pieces[row][col];
                        UIImageView * temp_late = pieces[aviablePos][col];
                        
                        QBAnimationItem * item_merging = [QBAnimationItem itemWithDuration:timeDuration delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                            temp.center = CGPointMake(temp.center.x, temp.center.y - (temp_row - temp_aviablePos) * (pieceSize + marginWidth));
                        } completion:^(BOOL finished){
                            //remove one duplicated piece
                            [self animationFinished];
                            [temp_early removeFromSuperview];
                            [temp_late removeFromSuperview];
                            [self updateScore:temp_neighborPieceState];
                            pieces[temp_aviablePos][temp_col] = [self generateNewPiece:temp_aviablePos andCol:temp_col withState:temp_neighborPieceState + 1];
                            
                            // do animation;
                            
                            
                        }];
                        [animationMovingArry addObject:item_merging];
                        shoudGenerateNewPiece = YES;
                        
                        // update the game state
                        gameState[aviablePos][col] = gameState[row][col] + 1;
                        neighborPieceState = StateNone;
                        gameState[row][col] = StateNone;
                        pieces[row][col] = nil;
                        
                    }
                }
                else
                {
                    
                    // add the animation
                    int temp_row = row;
                    int temp_col = col;
                    UIImageView * temp = pieces[row][col];
                    aviablePos++;
                    int temp_aviablePos = aviablePos;
                    neighborPieceState = gameState[row][col];
                    if (row != aviablePos) {
                        QBAnimationItem * item = [QBAnimationItem itemWithDuration:timeDuration delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                            
                            temp.center = CGPointMake(temp.center.x, temp.center.y - (temp_row - temp_aviablePos) * (pieceSize + marginWidth));
                        } completion:^(BOOL finished){
                            [self animationFinished];
                        }];
                        
                        
                        [animationMovingArry addObject:item];
                        shoudGenerateNewPiece = YES;
                        
                        pieces[aviablePos][col] = pieces[row][col];
                        pieces[row][col] = nil;
                        gameState[aviablePos][col] = gameState[row][col];
                        gameState[row][col] = StateNone;
                        
                    }
                    
                }
                row++;
            }
            
        }
    }
    UIImageView * randomlyGeneratedPiece = [self randomlyGeneratePiece];
    if (shoudGenerateNewPiece) {
        if (randomlyGeneratedPiece != nil) {
            randomlyGeneratedPiece.alpha = 0;
            
            QBAnimationItem * generateNewPieceAnimation = [QBAnimationItem itemWithDuration:timeDuration delay:timeDuration options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveEaseIn animations:^{
                
                randomlyGeneratedPiece.alpha = 1;
            } completion:^(BOOL finished){
                [self animationFinished];
                
            }];
            
            [animationMovingArry addObject:generateNewPieceAnimation];
        }

    }
    QBAnimationGroup * animationMovingGroup = [QBAnimationGroup groupWithItems:animationMovingArry];
    animationMovingGroup.waitUntilDone = NO;
    _animationCount = [animationMovingGroup.items count];
    if (_animationCount > 0) {
        QBAnimationSequence * sequence = [QBAnimationSequence sequenceWithAnimationGroups:[NSArray arrayWithObjects:animationMovingGroup , nil]];
        [sequence start];
    }
    else
    {
        if ([_storedSequences count] > 0) {
            [_storedSequences removeObjectAtIndex:0];
        }
        if ([_storedSequences count] > 0) {
            _finishedCount = 0;
            _animationCount = 0;
            NSNumber * num = [_storedSequences objectAtIndex:0];
            enum Direction direction = [num intValue];
            [self updateGameState:direction];
        }
    }
}

- (void)handleLeftGesture
{
    int col, row;
    NSMutableArray * animationMovingArry = [[NSMutableArray alloc] init];
    NSMutableArray * animationMergingArry = [[NSMutableArray alloc] init];
    BOOL shoudGenerateNewPiece = NO;
    for (row = 0; row < gameDimension; row++) {
        col = 0;
        int aviablePos = -1;
        enum PieceState neighborPieceState = StateNone;
        while (col < gameDimension) {
            if (gameState[row][col] == StateNone) {
                col++;
            }
            else
            {
                if (gameState[row][col] == neighborPieceState) {
                    
                    
                    if (col != aviablePos) {
                        neighborPieceState = gameState[row][col];
                        UIImageView * temp = pieces[row][col];
                        // add the animation, merge the same pieces.
                        
                        int temp_row = row;
                        int temp_col = col;
                        int temp_aviablePos = aviablePos;
                        enum PieceState temp_neighborPieceState = neighborPieceState;
                        UIImageView * temp_early = pieces[row][col];
                        UIImageView * temp_late = pieces[row][aviablePos];
                        
                        QBAnimationItem * item_merging = [QBAnimationItem itemWithDuration:timeDuration delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                            temp.center = CGPointMake(temp.center.x - (temp_col - temp_aviablePos) * (pieceSize + marginWidth), temp.center.y);
                        } completion:^(BOOL finished){
                            //remove one duplicated piece
                            [self animationFinished];
                            [temp_early removeFromSuperview];
                            [temp_late removeFromSuperview];
                            [self updateScore:temp_neighborPieceState];
                            pieces[temp_row][temp_aviablePos] = [self generateNewPiece:temp_row andCol:temp_aviablePos withState:temp_neighborPieceState + 1];
                            
                            // do animation;
                            
                            
                        }];
                        [animationMovingArry addObject:item_merging];
                        shoudGenerateNewPiece = YES;
                        // update the game state
                        gameState[row][aviablePos] = gameState[row][col] + 1;
                        neighborPieceState = StateNone;
                        gameState[row][col] = StateNone;
                        pieces[row][col] = nil;
                        
                    }
                }
                else
                {
                    
                    // add the animation
                    UIImageView * temp = pieces[row][col];
                    aviablePos++;
                    int temp_row = row;
                    int temp_col = col;
                    int temp_aviablePos = aviablePos;
                    neighborPieceState = gameState[row][col];
                    if (col != aviablePos) {
                        QBAnimationItem * item = [QBAnimationItem itemWithDuration:timeDuration delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                            
                            temp.center = CGPointMake(temp.center.x - (temp_col - temp_aviablePos) * (pieceSize + marginWidth), temp.center.y);
                        } completion:^(BOOL finished){
                            [self animationFinished];
                        }];
                        
                        
                        [animationMovingArry addObject:item];
                        shoudGenerateNewPiece = YES;
                        
                        pieces[row][aviablePos] = pieces[row][col];
                        pieces[row][col] = nil;
                        gameState[row][aviablePos] = gameState[row][col];
                        gameState[row][col] = StateNone;
                        
                    }
                    
                }
                col++;
            }
            
        }
    }
    UIImageView * randomlyGeneratedPiece = [self randomlyGeneratePiece];
    if (shoudGenerateNewPiece) {
        if (randomlyGeneratedPiece != nil) {
            randomlyGeneratedPiece.alpha = 0;
            
            QBAnimationItem * generateNewPieceAnimation = [QBAnimationItem itemWithDuration:timeDuration delay:timeDuration options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveEaseIn animations:^{
                
                randomlyGeneratedPiece.alpha = 1;
            } completion:^(BOOL finished){
                [self animationFinished];
                
            }];
            
            [animationMovingArry addObject:generateNewPieceAnimation];
        }
    }
    QBAnimationGroup * animationMovingGroup = [QBAnimationGroup groupWithItems:animationMovingArry];
    animationMovingGroup.waitUntilDone = NO;
    _animationCount = [animationMovingGroup.items count];
    if (_animationCount > 0) {
        QBAnimationSequence * sequence = [QBAnimationSequence sequenceWithAnimationGroups:[NSArray arrayWithObjects:animationMovingGroup , nil]];
        [sequence start];
    }
    else
    {
        if ([_storedSequences count] > 0) {
            [_storedSequences removeObjectAtIndex:0];
        }
        if ([_storedSequences count] > 0) {
            _finishedCount = 0;
            _animationCount = 0;
            NSNumber * num = [_storedSequences objectAtIndex:0];
            enum Direction direction = [num intValue];
            [self updateGameState:direction];
        }
    }

}

- (void)handleRightGesture
{
    int col, row;
    NSMutableArray * animationMovingArry = [[NSMutableArray alloc] init];
    NSMutableArray * animationMergingArry = [[NSMutableArray alloc] init];
    BOOL shoudGenerateNewPiece = NO;
    for (row = 0; row < gameDimension; row++) {
        col = gameDimension - 1;
        int aviablePos = gameDimension;
        enum PieceState neighborPieceState = StateNone;
        while (col >= 0) {
            if (gameState[row][col] == StateNone) {
                col--;
            }
            else
            {
                if (gameState[row][col] == neighborPieceState) {
                    
                    
                    if (col != aviablePos) {
                        neighborPieceState = gameState[row][col];
                        UIImageView * temp = pieces[row][col];
                        // add the animation, merge the same pieces.
                        
                        int temp_row = row;
                        int temp_col = col;
                        int temp_aviablePos = aviablePos;
                        enum PieceState temp_neighborPieceState = neighborPieceState;
                        UIImageView * temp_early = pieces[row][col];
                        UIImageView * temp_late = pieces[row][aviablePos];
                        
                        QBAnimationItem * item_merging = [QBAnimationItem itemWithDuration:timeDuration delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                            temp.center = CGPointMake(temp.center.x - (temp_col - temp_aviablePos) * (pieceSize + marginWidth), temp.center.y);
                        } completion:^(BOOL finished){
                            //remove one duplicated piece
                            [self animationFinished];
                            [temp_early removeFromSuperview];
                            [temp_late removeFromSuperview];
                            [self updateScore:temp_neighborPieceState];
                            pieces[temp_row][temp_aviablePos] = [self generateNewPiece:temp_row andCol:temp_aviablePos withState:temp_neighborPieceState + 1];
                            
                            // do animation;
                            
                            
                        }];
                        [animationMovingArry addObject:item_merging];
                        shoudGenerateNewPiece = YES;
                        
                        // update the game state
                        gameState[row][aviablePos] = gameState[row][col] + 1;
                        neighborPieceState = StateNone;
                        gameState[row][col] = StateNone;
                        pieces[row][col] = nil;
                        
                    }
                }
                else
                {
                    
                    // add the animation
                    UIImageView * temp = pieces[row][col];
                    aviablePos--;
                    int temp_row = row;
                    int temp_col = col;
                    int temp_aviablePos = aviablePos;
                    neighborPieceState = gameState[row][col];
                    if (col != aviablePos) {
                        QBAnimationItem * item = [QBAnimationItem itemWithDuration:timeDuration delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                            
                            temp.center = CGPointMake(temp.center.x - (temp_col - temp_aviablePos) * (pieceSize + marginWidth), temp.center.y);
                        } completion:^(BOOL finished){
                            [self animationFinished];
                        }];
                        
                        
                        [animationMovingArry addObject:item];
                        shoudGenerateNewPiece = YES;
                        
                        pieces[row][aviablePos] = pieces[row][col];
                        pieces[row][col] = nil;
                        gameState[row][aviablePos] = gameState[row][col];
                        gameState[row][col] = StateNone;
                        
                    }
                    
                }
                col--;
            }
            
        }
    }
    UIImageView * randomlyGeneratedPiece = [self randomlyGeneratePiece];
    if (shoudGenerateNewPiece) {
        if (randomlyGeneratedPiece != nil) {
            randomlyGeneratedPiece.alpha = 0;
            
            QBAnimationItem * generateNewPieceAnimation = [QBAnimationItem itemWithDuration:timeDuration delay:timeDuration options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveEaseIn animations:^{
                
                randomlyGeneratedPiece.alpha = 1;
            } completion:^(BOOL finished){
                [self animationFinished];
                
            }];
            
            [animationMovingArry addObject:generateNewPieceAnimation];
        }
    }
    QBAnimationGroup * animationMovingGroup = [QBAnimationGroup groupWithItems:animationMovingArry];
    animationMovingGroup.waitUntilDone = NO;
    _animationCount = [animationMovingGroup.items count];
    if (_animationCount > 0) {
        QBAnimationSequence * sequence = [QBAnimationSequence sequenceWithAnimationGroups:[NSArray arrayWithObjects:animationMovingGroup , nil]];
        [sequence start];
    }
    else
    {
        if ([_storedSequences count] > 0) {
            [_storedSequences removeObjectAtIndex:0];
        }
        if ([_storedSequences count] > 0) {
            _finishedCount = 0;
            _animationCount = 0;
            NSNumber * num = [_storedSequences objectAtIndex:0];
            enum Direction direction = [num intValue];
            [self updateGameState:direction];
        }
    }
}

- (void)updateGameState:(enum Direction)direction
{
    switch (direction) {
        case Up:
        {
            [self handleUpGesture];
            break;
            
        }
        case Down:
        {
            [self handleDownGesture];
            break;
            
        }
        case Right:
        {
            [self handleRightGesture];
            break;
            
        }
        case Left:
        {
            [self handleLeftGesture];
            break;
            
        }
        default:
            break;
    }
    
}


- (UIImageView *)generateNewPiece:(int)row andCol:(int)col withState:(enum PieceState)state
{
    if (state == StateNone) {
        return nil;
    }
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(marginWidth + col  * (marginWidth + pieceSize), marginWidth + row  * (marginWidth + pieceSize), pieceSize, pieceSize)];
    UIImageView * barView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 23, barSize, barSize)];
    barView.backgroundColor = [UIColor redColor];
    UILabel * barLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 3, 20, 20)];
    [imageView addSubview:barView];
    [imageView addSubview:barLabel];
    switch (state) {
        case StateA:
        {
            imageView.image = [UIImage imageNamed:imageLevelA];
            barView.image = [UIImage imageNamed:barLevelA];
            [imageView addSubview:barView];
            barLabel.text = @"A";
            break;
        }
        case StateB:
        {
            imageView.image = [UIImage imageNamed:imageLevelB];
            barView.image = [UIImage imageNamed:barLevelB];
            [imageView addSubview:barView];
            barLabel.text = @"B";
            break;
        }
        case StateC:
        {
            imageView.image = [UIImage imageNamed:imageLevelC];
            barView.image = [UIImage imageNamed:barLevelC];
            barLabel.text = @"C";
            break;
        }
        case StateD:
        {
            imageView.image = [UIImage imageNamed:imageLevelD];
            barView.image = [UIImage imageNamed:barLevelD];
            barLabel.text = @"D";
            break;
        }
        case StateE:
        {
            imageView.image = [UIImage imageNamed:imageLevelE];
            barView.image = [UIImage imageNamed:barLevelE];
            barLabel.text = @"E";
            break;
        }
        case StateF:
        {
            imageView.image = [UIImage imageNamed:imageLevelF];
            barView.image = [UIImage imageNamed:barLevelF];
            barLabel.text = @"F";
            break;
        }
        case StateG:
        {
            imageView.image = [UIImage imageNamed:imageLevelG];
            barView.image = [UIImage imageNamed:barLevelG];
            barLabel.text = @"G";
            break;
        }
        case StateH:
        {
            imageView.image = [UIImage imageNamed:imageLevelH];
            barView.image = [UIImage imageNamed:barLevelH];
            barLabel.text = @"H";
            break;
        }
        case StateI:
        {
            imageView.image = [UIImage imageNamed:imageLevelI];
            barView.image = [UIImage imageNamed:barLevelI];
            barLabel.text = @"I";
            break;
        }
        case StateJ:
        {
            imageView.image = [UIImage imageNamed:imageLevelJ];
            barView.image = [UIImage imageNamed:barLevelJ];
            barLabel.text = @"J";
            break;
        }
        case StateK:
        {
            imageView.image = [UIImage imageNamed:imageLevelK];
            barView.image = [UIImage imageNamed:barLevelK];
            barLabel.text = @"K";
            break;
        }
        default:
        {
            imageView.image = [UIImage imageNamed:imageLevelK];
            barView.image = [UIImage imageNamed:barLevelK];
            barLabel.text = @"K";
            break;
            
        }
    }
    
    [_gameBackgroundImageView addSubview:imageView];
    return imageView;
    
}

- (void)updatePieces
{
    for (int i = 0; i < gameDimension; i++){
        for (int j = 0; j < gameDimension; j++) {
            if (pieces[i][j] != nil) {
                [pieces[i][j] removeFromSuperview];
                pieces[i][j] = nil;
            }
            pieces[i][j] = [self generateNewPiece:i andCol:j withState:gameState[i][j]];
        }
        
    }

}

- (position)randomlyChoosePos
{
    int count = 0;
    int temp[50];
    int k = 0;
    position pos;
    pos.x = -1;
    pos.y = -1;
    for (int i = 0; i < gameDimension; i++) {
        for (int j = 0; j < gameDimension; j++) {
            if (gameState[i][j] == StateNone) {
                count++;
                temp[k] = i * gameDimension + j;
                k++;
            }
        }
    }
    if (count != 0) {
        int x = arc4random() % count;
        if (x < count) {
            int i = temp[x] / ((int)gameDimension);
            int j = temp[x] % ((int)gameDimension);
            pos.x = i;
            pos.y = j;
            return pos;
        }
        
    }
    return pos;
}

- (void)animationFinished
{
    _finishedCount++;
    if (_finishedCount == _animationCount) {
        if ([_storedSequences count] > 0) {
            [[DatabaseAccessor sharedInstance] saveGame:gameState score:_currentScore indicator:YES];
            [_storedSequences removeObjectAtIndex:0];
        }
        if ([_storedSequences count] > 0) {
            _finishedCount = 0;
            _animationCount = 0;
            NSNumber * num = [_storedSequences objectAtIndex:0];
            enum Direction direction = [num intValue];
            [self updateGameState:direction];
        }
    }
}

// BeginNewGameDelegate 
- (void)beginNewGame
{
    // alternative: rewrite the setter function of currentScore to update the _score's text;
    _currentScore = 0;
    _score.text = [NSString stringWithFormat:@"%d", _currentScore];
    _finishedCount = 0;
    _animationCount = 0;
    for (int i = 0; i < gameDimension; i++) {
        for (int j = 0; j < gameDimension; j++) {
            gameState[i][j] = StateNone;
        }
    }
    [self updatePieces];
    [self randomlyGeneratePiece];
    [self randomlyGeneratePiece];
    [[DatabaseAccessor sharedInstance] saveGame:gameState score:_currentScore indicator:YES];
}



- (UIImageView *)randomlyGeneratePiece
{
    position pos = [self randomlyChoosePos];
    if (pos.x < 0 || pos.y < 0) {
        // game is over
        if ([self checkIsGameOver]) {
            //save the game state
            [[DatabaseAccessor sharedInstance] saveGame:gameState score:_currentScore indicator:NO];
            // jump to the gameover view.
            if (_gameOverViewController == nil) {
                _gameOverViewController = [[GameOverViewController alloc] initWithNibName:@"GameOverViewController" bundle:nil];
            }
            _gameOverViewController.view.alpha = 0.0;
            _gameOverViewController.delegate = self;
            _gameOverViewController.score = _currentScore;
            [self.view addSubview:_gameOverViewController.view];
            [UIView animateWithDuration:0.2 animations:^{
                _gameOverViewController.view.alpha = 1.0;
            } completion:^(BOOL finished) {
                
            }];

            
        }
        return nil;
    }
    else
    {
        gameState[pos.x][pos.y] = StateA;
        UIImageView * randomlyGeneratedPiece = [[UIImageView alloc] initWithFrame:CGRectMake(marginWidth + pos.y  * (marginWidth + pieceSize), marginWidth + pos.x  * (marginWidth + pieceSize), pieceSize, pieceSize)];
        randomlyGeneratedPiece.image = [UIImage imageNamed:imageLevelA];
        UIImageView * barView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 23, barSize, barSize)];
        UILabel * barLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 3, 20, 20)];
        [randomlyGeneratedPiece addSubview:barView];
        [randomlyGeneratedPiece addSubview:barLabel];
        barView.image = [UIImage imageNamed:barLevelA];
        barLabel.text = @"A";
        pieces[pos.x][pos.y] = randomlyGeneratedPiece;
        [_gameBackgroundImageView addSubview:randomlyGeneratedPiece];
        if ([self checkIsGameOver]) {
            //save the game state
            [[DatabaseAccessor sharedInstance] saveGame:gameState score:_currentScore indicator:NO];
            // jump to the gameover view.
            if (_gameOverViewController == nil) {
                _gameOverViewController = [[GameOverViewController alloc] initWithNibName:@"GameOverViewController" bundle:nil];
            }
            _gameOverViewController.view.alpha = 0.0;
            _gameOverViewController.delegate = self;
            _gameOverViewController.score = _currentScore;
            [self.view addSubview:_gameOverViewController.view];
            [UIView animateWithDuration:0.2 animations:^{
                _gameOverViewController.view.alpha = 1.0;
            } completion:^(BOOL finished) {
                
            }];
        }
        return randomlyGeneratedPiece;
    }
}

- (void)updateScore:(enum PieceState)score;
{
    int scoreDx = score;
    _currentScore += ((int)pow(2, scoreDx + 1));
    _score.text = [NSString stringWithFormat:@"%d", _currentScore];
}

- (BOOL)checkIsGameOver
{
    for (int i = 0; i < gameDimension; i++) {
        for (int j = 0; j < gameDimension; j++) {
            if (gameState[i][j] == StateK) {
                return YES;
            }
            if (i > 0 && i < (gameDimension - 1) && j > 0 && j < (gameDimension - 1)) {
                if (gameState[i][j] == gameState[i - 1][j]) {
                    return NO;
                }
                if (gameState[i][j] == gameState[i + 1][j]) {
                    return NO;
                }
                if (gameState[i][j] == gameState[i][j - 1]) {
                    return NO;
                }
                if (gameState[i][j] == gameState[i][j + 1]) {
                    return NO;
                }
            }
            if (i == 0 && j > 0 && j < (gameDimension - 1)) {
                if (gameState[i][j] == gameState[i - 1][j]) {
                    return NO;
                }
                if (gameState[i][j] == gameState[i + 1][j]) {
                    return NO;
                }
                if (gameState[i][j] == gameState[i][j + 1]) {
                    return NO;
                }
            }
            if (i == (gameDimension - 1) && j > 0 && j < (gameDimension - 1)) {
                if (gameState[i][j] == gameState[i - 1][j]) {
                    return NO;
                }
                if (gameState[i][j] == gameState[i + 1][j]) {
                    return NO;
                }
                if (gameState[i][j] == gameState[i][j - 1]) {
                    return NO;
                }
                
            }
            if (j == 0 && i > 0 && i < (gameDimension - 1)) {
                if (gameState[i][j] == gameState[i][j - 1]) {
                    return NO;
                }
                if (gameState[i][j] == gameState[i][j + 1]) {
                    return NO;
                }
                if (gameState[i][j] == gameState[i + 1][j]) {
                    return NO;
                }
                
            }
            if (j == (gameDimension - 1) && i > 0 && i < (gameDimension - 1)) {
                if (gameState[i][j] == gameState[i][j - 1]) {
                    return NO;
                }
                if (gameState[i][j] == gameState[i][j + 1]) {
                    return NO;
                }
                if (gameState[i][j] == gameState[i - 1][j]) {
                    return NO;
                }
                
            }
        }
    }
    return YES;
}

- (void)dealloc
{
    _dmAdView.delegate = nil;
    _dmAdView.rootViewController = nil;
    [_dmAdView removeFromSuperview];
}

- (void)initDmAdView
{
    ////////////////////////////////////////////////////////////////////////////////////////////////
    // 创建广告视图，此处使用的是测试ID，请登陆多盟官网（www.domob.cn）获取新的ID
    // Creat advertisement view please get your own ID from domob website  56OJyM1ouMGoULfJaL   16TLwebvAchkAY6iOMd734jz
    CGSize adSize = DOMOB_AD_SIZE_320x50;
    DMAdView *dmView = [[DMAdView alloc] initWithPublisherId:@"56OJwtc4uNFRVtBlad"
                                                 placementId:@"16TLuhYlApN9ANUku_8hNMSi"
                                                        size:adSize];
    _dmAdView = dmView;
    
    // 设置广告视图的位置
    // Set the frame of advertisement view
    CGSize winSize = [UIScreen mainScreen].bounds.size;
    _dmAdView.frame = CGRectMake(0, winSize.height - 50, 320, 50);
    _dmAdView.delegate = self;
    _dmAdView.rootViewController = self; // set RootViewController
    [self.view addSubview:_dmAdView];
    
    [_dmAdView loadAd]; // start load advertisement
    
    
    //    ////////////////////////////////////////////////////////////////////////////////////////////////
    //    // 检查评价提醒，此处使用的是测试ID，请登陆多盟官网（www.domob.cn）获取新的ID
    //    // Check for rate please get your own ID from Domob website
    DMTools *_dmTools = [[DMTools alloc] initWithPublisherId:@"56OJwtc4uNFRVtBlad"];
    [_dmTools checkRateInfo];
}

#pragma mark -
#pragma mark DMAdView delegate

// 成功加载广告后，回调该方法
// This method will be used after load successfully
- (void)dmAdViewSuccessToLoadAd:(DMAdView *)adView
{
    NSLog(@"[Domob Sample] success to load ad.");
}

// 加载广告失败后，回调该方法
// This method will be used after load failed
- (void)dmAdViewFailToLoadAd:(DMAdView *)adView withError:(NSError *)error
{
    NSLog(@"[Domob Sample] fail to load ad. %@", error);
}

// 当将要呈现出 Modal View 时，回调该方法。如打开内置浏览器
// When will be showing a Modal View, this method will be called. Such as open built-in browser
- (void)dmWillPresentModalViewFromAd:(DMAdView *)adView
{
    NSLog(@"[Domob Sample] will present modal view.");
}

// 当呈现的 Modal View 被关闭后，回调该方法。如内置浏览器被关闭。
// When presented Modal View is closed, this method will be called. Such as built-in browser is closed
- (void)dmDidDismissModalViewFromAd:(DMAdView *)adView
{
    NSLog(@"[Domob Sample] did dismiss modal view.");
}

// 当因用户的操作（如点击下载类广告，需要跳转到Store），需要离开当前应用时，回调该方法
// When the result of the user's actions (such as clicking download class advertising, you need to jump to the Store), need to leave the current application, this method will be called
- (void)dmApplicationWillEnterBackgroundFromAd:(DMAdView *)adView
{
    NSLog(@"[Domob Sample] will enter background.");
}

- (IBAction)setting:(id)sender
{
    if (_optionViewController == nil) {
        _optionViewController = [[OptionViewController alloc] initWithNibName:@"OptionViewController" bundle:nil];
    }
    _optionViewController.view.alpha = 0.0;
    _optionViewController.delegate = self;
    [self.view addSubview:_optionViewController.view];
    [UIView animateWithDuration:0.2 animations:^{
        _optionViewController.view.alpha = 1.0;
    } completion:^(BOOL finished) {
        
    }];
}

@end

