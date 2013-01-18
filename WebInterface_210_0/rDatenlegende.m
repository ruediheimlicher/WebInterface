//
//  rDatenlegende.m
//  WebInterface
//
//  Created by Ruedi Heimlicher on 18.Januar.13.
//
//

#import "rDatenlegende.h"

@implementation rDatenlegende

- (id)init
{
   self = [super init];
   LegendeArray = [[[NSMutableArray alloc]initWithCapacity:0]autorelease];
   randunten=0;
   randoben = 0;
   abstandvor=-1;
   abstandnach=-1;
   mindistanz = 10;
   return self;
}

- (void)setVorgabenDic:(NSDictionary*)vorgabendic
{
   //float randunten, randoben, abstandunten, abstandoben;
if ([vorgabendic objectForKey:@"randunten"])
{
   randunten = [[vorgabendic objectForKey:@"randunten"]floatValue];
}
   if ([vorgabendic objectForKey:@"randoben"])
   {
      randoben = [[vorgabendic objectForKey:@"randoben"]floatValue];
   }
   if ([vorgabendic objectForKey:@"abstandvor"])
   {
      abstandvor = [[vorgabendic objectForKey:@"abstandvor"]floatValue];
   }
   if ([vorgabendic objectForKey:@"abstandnach"])
   {
      abstandnach = [[vorgabendic objectForKey:@"abstandnach"]floatValue];
   }

   if ([vorgabendic objectForKey:@"mindistanz"])
   {
      mindistanz = [[vorgabendic objectForKey:@"mindistanz"]floatValue];
   }

}

- (void)setLegendeArray:(NSArray*)legendearray
{
   
   // Array mit Dics zu jedem Cluster: Array mit Elementen, abstaende usw
   NSMutableArray* ClusterArray = [[[NSMutableArray alloc]initWithCapacity:0]autorelease];
   
   //LegendeArray = [NSMutableArray arrayWithArray:array];
   
   // Abstande einsetzen
   float lastposition=randunten; // effektive Position des vorherigen Elements
   float minposition = randunten;     // minimalposition fuer Element
   float distanz=0;      // effektive distanz zum vorherigen Element
   
   int clusterindex = 0;
   
   [ClusterArray addObject:[[[NSMutableArray alloc]initWithCapacity:0]autorelease]];
   
   for (int i=0;i<[legendearray count];i++)
   {
      int index = [[[legendearray objectAtIndex:i]objectForKey:@"index"]intValue];
      float tempwert = [[[legendearray objectAtIndex:i]objectForKey:@"wert"]floatValue];
      
      float legendeposition = tempwert;
      
      if (tempwert <= minposition) // zum letzten Objekt in ClusterArray zufuegen
      {
         legendeposition = minposition;
         
         if (i) // nicht unterste Position
         {
            if ([[ClusterArray lastObject]count]==0) // Array noch leer, vorheriges Objekt zufuegen
            {
               NSMutableDictionary* clusterDic = [LegendeArray lastObject];
               
               [clusterDic setObject:[NSNumber numberWithInt:clusterindex] forKey:@"clusterindex"];
               //[clusterDic setObject:[NSNumber numberWithFloat:-1]forKey:@"abstandvor"]; // erste Element in Cluster
               
               [[ClusterArray lastObject]addObject:clusterDic];

            }
            
            NSMutableDictionary* clusterDic = [[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                               [NSNumber numberWithFloat:legendeposition],@"legendeposition",
                                                [NSNumber numberWithInt:clusterindex],@"clusterindex",
                                               [NSNumber numberWithFloat:tempwert],@"wert",
                                               [NSNumber numberWithFloat:0],@"abstandvor", // kein Abstand
                                                
                                                nil];
            [[ClusterArray lastObject]addObject:clusterDic];
         }
         else // erstes Element
         {
            
         }
      }
      else // abstand ausreichend, incl randunten beim ersten öObjekt
      {
         minposition = tempwert;
         // Cluster fertig, neuen Array fuer eventuellen naechsten Cluster anfuegen
         if ([[ClusterArray lastObject]count]) // der letzte Cluster hatte Objecte
         {
            // im letzten Element abstandnach einsetzen: legendeposition - legendeposition des letzten Elements
            float lastlegendeposition = [[[[ClusterArray lastObject]lastObject]objectForKey:@"legendeposition"]floatValue];
            [[[ClusterArray lastObject]lastObject]setObject:[NSNumber numberWithFloat:legendeposition-lastlegendeposition]forKey:@"abstandnach"];
            
            [ClusterArray addObject:[[[NSMutableArray alloc]initWithCapacity:0]autorelease]];
            clusterindex ++;
         }
         
      }
      distanz = legendeposition-distanz;
      
      [LegendeArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithInt:index], @"index",
                               [NSNumber numberWithFloat:tempwert], @"wert",
                              [NSNumber numberWithFloat:legendeposition], @"legendeposition",
                               [NSNumber numberWithFloat:distanz],@"abstandvor", // kein Abstand
                               
                              nil]];
      
      
      
      NSLog(@"DatenLegende i: %d tempwert: %.2f legendeposition: %d",i,tempwert,legendeposition);
      
      minposition += mindistanz;
   
   }// for i
   
   //NSLog(@"DatenLegende LegendeArray: %@",[[LegendeArray valueForKey:@"legendeposition"]description]);
   
   for (int k=0;k<[ClusterArray count];k++)
   {
      NSLog(@"DatenLegende k: %d ClusterArray: %@",k,[[ClusterArray objectAtIndex:k ]description]);
   }
   //NSLog(@"DatenLegende ClusterArray: %@",[ClusterArray description]);
   
   
   
   

}



- (NSArray*)LegendeArray
{
   
   return LegendeArray;
}

@end
