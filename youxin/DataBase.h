//
//  DataBase.h
//  youxin
//
//  Created by fei on 13-9-14.
//  Copyright (c) 2013年 mjc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface DataBase : NSObject{
@private
    //数据库存放地址
    NSString *dbFilepath;
    //数据库实例
    FMDatabase *mDataBase;
    
}
+(DataBase*)shareDB;
//增删改查
-(void)insertItem:(id)item;
-(void)inserArray:(NSArray*)arr;

-(NSArray*)readArrFromDB:(NSString*)tbnm;
-(void)updateItem:(id)item tablenm:(NSString*)tbmn bykey:(NSString*)key;
-(void)delItemFromTablenm:(NSString*)tbnm byKey:(NSString*)key;

@end
