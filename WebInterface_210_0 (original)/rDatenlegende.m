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
   LegendeArray = [[NSMutableArray alloc]initWithCapacity:0];
   randunten=12;
   randoben = 0;
   abstandvor=-1;
   abstandnach=-1;
   mindistanz = 12;
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
   NSMutableArray* ClusterArray = [[NSMutableArray alloc]initWithCapacity:0];
   
   //LegendeArray = [NSMutableArray arrayWithArray:array];
   
   // Abstande einsetzen
   float lastposition=randunten; // effektive Position des vorherigen Elements
   float minposition = randunten;     // minimalposition fuer Element
   float distanz=0;      // effektive distanz zum vorherigen Element
   
   int clusterindex = 0;
   
   [ClusterArray addObject:[[NSMutableArray alloc]initWithCapacity:0]];
   
   for (int i=0;i<[legendearray count];i++)
   {
      int index = [[[legendearray objectAtIndex:i]objectForKey:@"index"]intValue];
      float tempwert = [[[legendearray objectAtIndex:i]objectForKey:@"wert"]floatValue];
      
      float legendeposition = tempwert;
      
      if (tempwert < minposition) // zum letzten Objekt in ClusterArray zufuegen
      {
         legendeposition = minposition;
         
         if (i) // nicht unterste Position
         {
            if ([[ClusterArray lastObject]count]==0) // Array noch leer, vorher in LegendeArray eingefuegtes  Objekt einfuegen
            {
               NSMutableDictionary* prevclusterDic = [LegendeArray lastObject];
               
               //NSLog(@"prevclusterDic abstandvor: %.2f",[[prevclusterDic  objectForKey:@"abstandvor"]floatValue]);
               //NSLog(@"prevclusterDic lastposition: %.2f",[[prevclusterDic  objectForKey:@"lastposition"]floatValue]);

               [prevclusterDic setObject:[NSNumber numberWithInt:clusterindex] forKey:@"clusterindex"];
                
               //NSNumber numberWithFloat:lastposition], @"lastposition",
                
               //[clusterDic setObject:[NSNumber numberWithFloat:-1]forKey:@"abstandvor"]; // erste Element in Cluster
               
               [[ClusterArray lastObject]addObject:prevclusterDic];

            }
            
            NSMutableDictionary* clusterDic = [[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                               [NSNumber numberWithFloat:legendeposition],@"legendeposition",
                                                [NSNumber numberWithInt:clusterindex],@"clusterindex",
                                               [NSNumber numberWithInt:index],@"index",
                                               [NSNumber numberWithFloat:tempwert],@"wert",
                                               [NSNumber numberWithFloat:lastposition], @"lastposition",
                                               [NSNumber numberWithFloat:0],@"abstandvor", // kein Abstand, zweites Element des Clusters
                                                
                                                nil];
            [[ClusterArray lastObject]addObject:clusterDic];
         }
         else // erstes Element
         {
         }
      }
      else // abstand ausreichend, incl randunten beim ersten Objekt
      {
         minposition = tempwert;
         // Cluster fertig, neuen Array fuer eventuellen naechsten Cluster anfuegen
         if ([[ClusterArray lastObject]count]) // der letzte Cluster hatte Elemente
         {
            // im letzten Element abstandnach einsetzen: legendeposition - legendeposition des letzten Elements
            float lastlegendeposition = [[[[ClusterArray lastObject]lastObject]objectForKey:@"legendeposition"]floatValue];
            [[[ClusterArray lastObject]lastObject]setObject:[NSNumber numberWithFloat:legendeposition-lastlegendeposition]forKey:@"abstandnach"];
            
            [ClusterArray addObject:[[NSMutableArray alloc]initWithCapacity:0]];
            clusterindex ++;
         }
         
      }
      distanz = legendeposition-distanz; // Bei Element 0 Abstand von 0-Linie
      
      [LegendeArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithInt:index], @"index",
                               [NSNumber numberWithFloat:tempwert], @"wert",
                              [NSNumber numberWithFloat:legendeposition], @"legendeposition",
                               [NSNumber numberWithFloat:lastposition], @"lastposition",
                               [NSNumber numberWithFloat:distanz],@"abstandvor", // Abstand
                               
                              nil]];
      
      
      
      //NSLog(@"DatenLegende i: %d tempwert: %.2f legendeposition: %d",i,tempwert,legendeposition);
      
      lastposition = legendeposition;
      minposition += mindistanz;
   
   }// for i
   
   //NSLog(@"DatenLegende LegendeArray: %@",[[LegendeArray valueForKey:@"legendeposition"]description]);
   
   
   // Array mit Indexes im LegendeArray. Damit lassen sich die Elemente im Clusterarray identifizieren
   NSArray* LegendeIndexArray = [LegendeArray valueForKey:@"index"];
   //NSLog(@"DatenLegende LegendeIndexArray: %@",[LegendeIndexArray description]);
   
   for (int k=0;k<[ClusterArray count];k++)
   {
      float verschiebung =0;
      
      //NSLog(@"DatenLegende k: %d ClusterArray vor: %@",k,[[ClusterArray objectAtIndex:k ]description]);
      
      NSMutableArray* tempClusterArray = [ClusterArray objectAtIndex:k ];
      if ([tempClusterArray count])
      {
         // Abstand zum unteren Element oder Cluster:
         float tempabstandvor=0;
         if ([[tempClusterArray objectAtIndex:0]objectForKey:@"abstandvor"])
         {
            tempabstandvor = [[[tempClusterArray objectAtIndex:0]objectForKey:@"abstandvor"]floatValue];

         }
         
         //NSLog(@"Cluster %d tempabstandvor: %.2f",k,tempabstandvor);
         //NSLog(@"Cluster %d lastposition: %.2f",k,[[[tempClusterArray objectAtIndex:0]objectForKey:@"lastposition"]floatValue]);
         
         // Differenz zwischen legendeposition und wert des obersten Elements minus gleiche Differnz des untersten Elements ergibt doppelte Verschiebung
         verschiebung = ([[[tempClusterArray lastObject]objectForKey:@"legendeposition"]floatValue] - [[[tempClusterArray lastObject]objectForKey:@"wert"]floatValue])- ([[[tempClusterArray objectAtIndex:0]objectForKey:@"legendeposition"]floatValue] - [[[tempClusterArray objectAtIndex:0]objectForKey:@"wert"]floatValue]);
         verschiebung /=2;
         //NSLog(@"Cluster %d verschiebung raw: %.2f tempabstandvor: %.2f",k,verschiebung,tempabstandvor);
         if (verschiebung > tempabstandvor -mindistanz) // Verschiebung abzueglich zweimal halbe Minimaldistanz
         {
            //NSLog(@"Cluster verschiebung zu gross");
            verschiebung = tempabstandvor-mindistanz;
         }
         //NSLog(@"Cluster %d verschiebung nach korr: %.2f",k,verschiebung);
         for (int l=0;l<[tempClusterArray count];l++)
         {
            int tempindex = [[[tempClusterArray objectAtIndex:l]objectForKey:@"index"]intValue];
            float neueposition = [[[tempClusterArray objectAtIndex:l]objectForKey:@"legendeposition"]floatValue]-verschiebung;
            //[[tempClusterArray objectAtIndex:l]setObject:[NSNumber numberWithFloat:neueposition] forKey:@"legendeposition"];
            //NSLog(@"Cluster %d index: %d neueposition: %.2f",k,tempindex,neueposition);
            
            
            // legendeposition in LegendeArray>Objekt mit index tempindex korrigieren
            // wuerde auch mit Korrektur im tempClusterArray funktionieren
            NSUInteger changeindex = [LegendeIndexArray indexOfObject:[NSNumber numberWithInt:tempindex]];
            //NSLog(@"changeindex: %d",changeindex);
            
            //Korrektur
            [[LegendeArray objectAtIndex:changeindex]setObject:[NSNumber numberWithFloat:neueposition] forKey:@"legendeposition"];
         }
         
         
      }
      //NSLog(@"DatenLegende k: %d ClusterArray nach: %@",k,[[ClusterArray objectAtIndex:k ]description]);
   }
   //NSLog(@"DatenLegende LegendeArray nach korr: %@",[[LegendeArray valueForKey:@"legendeposition"]description]);

   
   
   //NSLog(@"DatenLegende ClusterArray: %@",[ClusterArray description]);
   //NSLog(@"DatenLegende LegendeArray: %@",[LegendeArray description]);
   
   
   
   

}



- (NSArray*)LegendeArray
{
   
   return LegendeArray;
}

@end
