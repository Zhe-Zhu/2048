//
//  Global.h
//  New2048
//
//  Created by Chen Xiangwen on 17/4/14.
//  Copyright (c) 2014 Chen Xiangwen. All rights reserved.
//

#ifndef __New2048__Global__
#define __New2048__Global__



#define gameDimension 4
#define UMAppKey @"5352964b56240b09f40a2a4d"
#define WeiXinAppID @"wxefb25117003c050f"
#define QQAppID @"101067924"
#define QQAppKey @"bb44cc7defedd5ffe1be28ee6c29b6de"

#define IS_OS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define IS_OS_6_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
#define IS_IPHONE5 ([UIScreen mainScreen].bounds.size.height > 560.0)

#define IPhone5Height 568
#define IPhone4Height 480


//used as the chess piece image
//#define imageLevelA @"CUP-A"
//#define imageLevelB @"CUP-B"
//#define imageLevelC @"CUP-C"
//#define imageLevelD @"CUP-D"
//#define imageLevelE @"CUP-E"
//#define imageLevelF @"CUP-F"
//#define imageLevelG @"CUP-G"
//#define imageLevelH @"CUP-H"
//#define imageLevelI @"CUP-I"
//#define imageLevelJ @"CUP-J"
//#define imageLevelK @"CUP-K"
//#define imageLevelL @"CUP-L"

#define imageLevelA @"chess_A"
#define imageLevelB @"chess_B"
#define imageLevelC @"chess_C"
#define imageLevelD @"chess_D"
#define imageLevelE @"chess_E"
#define imageLevelF @"chess_F"
#define imageLevelG @"chess_G"
#define imageLevelH @"chess_H"
#define imageLevelI @"chess_I"
#define imageLevelJ @"chess_J"
#define imageLevelK @"chess_K"
#define imageLevelL @"chess_L"
#define imageLevelM @"chess_M"
#define imageLevelN @"chess_N"
#define imageLevelO @"chess_O"
#define imageLevelP @"chess_P"
#define imageLevelQ @"chess_Q"

//used in the gameover view
#define sharedImageLevelA @"chess_A"
#define sharedImageLevelB @"chess_B"
#define sharedImageLevelC @"chess_C"
#define sharedImageLevelD @"chess_D"
#define sharedImageLevelE @"chess_E"
#define sharedImageLevelF @"chess_F"
#define sharedImageLevelG @"chess_G"
#define sharedImageLevelH @"chess_H"
#define sharedImageLevelI @"chess_I"
#define sharedImageLevelJ @"chess_J"
#define sharedImageLevelK @"chess_K"
#define sharedImageLevelL @"chess_L"
#define sharedImageLevelM @"chess_M"
#define sharedImageLevelN @"chess_N"
#define sharedImageLevelO @"chess_O"
#define sharedImageLevelP @"chess_P"
#define sharedImageLevelQ @"chess_Q"

//#define sharedImageLevelA @"CUP-A-L"
//#define sharedImageLevelB @"CUP-B-L"
//#define sharedImageLevelC @"CUP-C-L"
//#define sharedImageLevelD @"CUP-D-L"
//#define sharedImageLevelE @"CUP-E-L"
//#define sharedImageLevelF @"CUP-F-L"
//#define sharedImageLevelG @"CUP-G-L"
//#define sharedImageLevelH @"CUP-H-L"
//#define sharedImageLevelI @"CUP-I-L"
//#define sharedImageLevelJ @"CUP-J-L"
//#define sharedImageLevelK @"CUP-K-L"
//#define sharedImageLevelL @"CUP-L-L"


//used in the shared image
//#define shareLevelA @"share_B"
//#define shareLevelB @"share_B"
//#define shareLevelC @"share_C"
//#define shareLevelD @"share_D"
//#define shareLevelE @"share_E"
//#define shareLevelF @"share_F"
//#define shareLevelG @"share_G"
//#define shareLevelH @"share_H"
//#define shareLevelI @"share_I"
//#define shareLevelJ @"share_J"
//#define shareLevelK @"share_K"
//#define shareLevelL @"share_L"


#define shareLevelA  (IS_IPHONE5 ? @"share_B_1138" : @"share_B")
#define shareLevelB  (IS_IPHONE5 ? @"share_B_1138" : @"share_B")
#define shareLevelC  (IS_IPHONE5 ? @"share_C_1138" : @"share_C")
#define shareLevelD  (IS_IPHONE5 ? @"share_D_1138" : @"share_D")
#define shareLevelE  (IS_IPHONE5 ? @"share_E_1138" : @"share_E")
#define shareLevelF  (IS_IPHONE5 ? @"share_F_1138" : @"share_F")
#define shareLevelG  (IS_IPHONE5 ? @"share_G_1138" : @"share_G")
#define shareLevelH  (IS_IPHONE5 ? @"share_H_1138" : @"share_H")
#define shareLevelI  (IS_IPHONE5 ? @"share_I_1138" : @"share_I")
#define shareLevelJ  (IS_IPHONE5 ? @"share_J_1138" : @"share_J")
#define shareLevelK  (IS_IPHONE5 ? @"share_K_1138" : @"share_K")
#define shareLevelL  (IS_IPHONE5 ? @"share_L_1138" : @"share_L")
#define shareLevelM  (IS_IPHONE5 ? @"share_M_1138" : @"share_M")
#define shareLevelN  (IS_IPHONE5 ? @"share_N_1138" : @"share_N")
#define shareLevelO  (IS_IPHONE5 ? @"share_O_1138" : @"share_O")
#define shareLevelP  (IS_IPHONE5 ? @"share_P_1138" : @"share_P")
#define shareLevelQ  (IS_IPHONE5 ? @"share_Q_1138" : @"share_Q")



#define barLevelA @"temp_a"
#define barLevelB @"temp_b"
#define barLevelC @"bra_C"
#define barLevelD @"bra_D"
#define barLevelE @"bra_E"
#define barLevelF @"bra_F"
#define barLevelG @"bra_G"
#define barLevelH @"bra_H"
#define barLevelI @"bra_I"
#define barLevelJ @"bra_J"
#define barLevelK @"bra_K"
#define barLevelL @"bra_K"

#endif /* defined(__New2048__Global__) */
