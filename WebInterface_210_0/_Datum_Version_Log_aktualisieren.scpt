FasdUAS 1.101.10   ��   ��    k             l   � ����  O    �  	  k   � 
 
     l   ��  ��     activate     �    a c t i v a t e      l   ��������  ��  ��        r        m       �      o      ���� 0 filecontents fileContents      r        4    �� 
�� 
alis  l  
  ����  l  
  ����  I  
 ��   
�� .earsffdralis        afdr   f   
    �� !��
�� 
rtyp ! m    ��
�� 
ctxt��  ��  ��  ��  ��    o      ���� 0 
homeordner     " # " l   �� $ %��   $ 0 *display dialog "homeordner: " & homeordner    % � & & T d i s p l a y   d i a l o g   " h o m e o r d n e r :   "   &   h o m e o r d n e r #  ' ( ' r     ) * ) n     + , + m    ��
�� 
ctnr , o    ���� 0 
homeordner   * o      ���� 0 homeordnerpfad   (  - . - l   �� / 0��   / 2 ,set main to file "datum.c" of homeordnerpfad    0 � 1 1 X s e t   m a i n   t o   f i l e   " d a t u m . c "   o f   h o m e o r d n e r p f a d .  2 3 2 r    " 4 5 4 b      6 7 6 l    8���� 8 c     9 : 9 o    ���� 0 homeordnerpfad   : m    ��
�� 
TEXT��  ��   7 m     ; ; � < <  d a t u m . c 5 o      ���� 0 filepfad   3  = > = l  # #�� ? @��   ? , &display dialog "filepfad: " & filepfad    @ � A A L d i s p l a y   d i a l o g   " f i l e p f a d :   "   &   f i l e p f a d >  B C B l  # #�� D E��   D ! tell application "TextEdit"    E � F F 6 t e l l   a p p l i c a t i o n   " T e x t E d i t " C  G H G I  # (������
�� .miscactvnull��� ��� obj ��  ��   H  I J I r   ) 7 K L K l  ) 3 M���� M I  ) 3�� N O
�� .rdwropenshor       file N 4   ) -�� P
�� 
file P o   + ,���� 0 filepfad   O �� Q��
�� 
perm Q m   . /��
�� boovtrue��  ��  ��   L o      ���� 0 refnum RefNum J  R S R Q   8� T U V T k   ;� W W  X Y X r   ; D Z [ Z l  ; B \���� \ I  ; B�� ]��
�� .rdwrread****        **** ] o   ; >���� 0 refnum RefNum��  ��  ��   [ o      ���� 0 filecontents fileContents Y  ^ _ ^ l  E E��������  ��  ��   _  ` a ` l  E E�� b c��   b 7 1display dialog "inhalt: " & return & fileContents    c � d d b d i s p l a y   d i a l o g   " i n h a l t :   "   &   r e t u r n   &   f i l e C o n t e n t s a  e f e r   E O g h g n   E K i j i 4   F K�� k
�� 
cpar k m   I J����  j o   E F���� 0 filecontents fileContents h o      ���� 0 datum Datum f  l m l l  P P�� n o��   n &  display dialog "Datum: " & Datum    o � p p @ d i s p l a y   d i a l o g   " D a t u m :   "   &   D a t u m m  q r q r   P Y s t s I  P U������
�� .misccurdldt    ��� null��  ��   t o      ���� 	0 heute   r  u v u l  Z Z�� w x��   w &  display dialog "heute: " & heute    x � y y @ d i s p l a y   d i a l o g   " h e u t e :   "   &   h e u t e v  z { z r   Z e | } | n   Z a ~  ~ 1   ] a��
�� 
year  o   Z ]���� 	0 heute   } o      ���� 0 jahrtext   {  � � � r   f q � � � n   f m � � � m   i m��
�� 
mnth � o   f i���� 	0 heute   � o      ���� 0 	monattext   �  � � � l  r r�� � ���   � * $display dialog "monat: " & monattext    � � � � H d i s p l a y   d i a l o g   " m o n a t :   "   &   m o n a t t e x t �  � � � r   r � � � � n   r � � � � 7  } ��� � �
�� 
ctxt � m   � ������� � m   � ������� � l  r } ����� � b   r } � � � m   r u � � � � �  0 � n   u | � � � 1   x |��
�� 
day  � o   u x���� 	0 heute  ��  ��   � o      ���� 0 tag   �  � � � l  � ��� � ���   � " display dialog "tag: " & tag    � � � � 8 d i s p l a y   d i a l o g   " t a g :   "   &   t a g �  � � � r   � � � � � J   � � � �  � � � m   � ���
�� 
jan  �  � � � m   � ���
�� 
feb  �  � � � m   � ���
�� 
mar  �  � � � l 	 � � ����� � m   � ���
�� 
apr ��  ��   �  � � � m   � ���
�� 
may  �  � � � m   � ���
�� 
jun  �  � � � m   � ���
�� 
jul  �  � � � m   � ���
�� 
aug  �  � � � l 	 � � ����� � m   � ���
�� 
sep ��  ��   �  � � � m   � ���
�� 
oct  �  � � � m   � ���
�� 
nov  �  ��� � m   � ���
�� 
dec ��   � o      ���� 0 monatsliste MonatsListe �  � � � Y   � � ��� � ��� � Z   � � � ����� � =   � � � � � o   � ����� 0 	monattext   � n   � � � � � 4   � ��� �
�� 
cobj � o   � ����� 0 i   � o   � ����� 0 monatsliste MonatsListe � k   � � � �  � � � r   � � � � � n   � � � � � 7  � ��� � �
�� 
ctxt � m   � ������� � m   � ������� � l  � � ����� � b   � � � � � m   � � � � � � �  0 � o   � ����� 0 i  ��  ��   � o      ���� 	0 monat   �  ��� � l  � � � � � �  S   � � � - ' wenn true, wird die Schleife verlassen    � � � � N   w e n n   t r u e ,   w i r d   d i e   S c h l e i f e   v e r l a s s e n��  ��  ��  �� 0 i   � m   � �����  � m   � ����� ��   �  � � � l  � ��� � ���   � &  display dialog "monat: " & monat    � � � � @ d i s p l a y   d i a l o g   " m o n a t :   "   &   m o n a t �  � � � r   � � � � l 	 �
 ����� � l  �
 ����� � n  �
 � � � 7  �
�� � �
�� 
cha  � m  ����  � m  	����  � l  � � ����� � c   � � � � � o   � ����� 0 jahrtext   � m   � ���
�� 
ctxt��  ��  ��  ��  ��  ��   � o      ���� 0 jahr   �  � � � l �� � ���   � ? 9display dialog "jahr: " & jahr & " jahrtext: " & jahrtext    � � � � r d i s p l a y   d i a l o g   " j a h r :   "   &   j a h r   &   "   j a h r t e x t :   "   &   j a h r t e x t �  � � � r   � � � n   � � � m  �
� 
nmbr � n   � � � 2 �~
�~ 
cha  � o  �}�} 0 datum Datum � o      �|�| 0 l   �  � � � l �{ � ��{   � 1 +set neuesDatum to text -l thru -13 of Datum    � � � � V s e t   n e u e s D a t u m   t o   t e x t   - l   t h r u   - 1 3   o f   D a t u m �    l 2 r  2 n  . 7 ".�z	

�z 
ctxt	 m  &(�y�y 
 m  )-�x�x  o  "�w�w 0 datum Datum o      �v�v 0 
neuesdatum 
neuesDatum $  Anfang bis und mit Leerschlag    � <   A n f a n g   b i s   u n d   m i t   L e e r s c h l a g  l 33�u�u   2 ,display dialog "neuesDatum A: " & neuesDatum    � X d i s p l a y   d i a l o g   " n e u e s D a t u m   A :   "   &   n e u e s D a t u m  r  3V b  3R b  3N b  3J b  3F b  3B b  3>  b  3:!"! o  36�t�t 0 
neuesdatum 
neuesDatum" m  69## �$$  @ "  o  :=�s�s 0 tag   m  >A%% �&&  . o  BE�r�r 	0 monat   m  FI'' �((  . o  JM�q�q 0 jahrtext   m  NQ)) �**  " o      �p�p 0 
neuesdatum 
neuesDatum +,+ l WW�o-.�o  - 0 *display dialog "neuesDatum: " & neuesDatum   . �// T d i s p l a y   d i a l o g   " n e u e s D a t u m :   "   &   n e u e s D a t u m, 010 l WW�n23�n  2 N Hset neuerText to paragraph 1 of fileContents & return & " " & neuesDatum   3 �44 � s e t   n e u e r T e x t   t o   p a r a g r a p h   1   o f   f i l e C o n t e n t s   &   r e t u r n   &   "   "   &   n e u e s D a t u m1 565 r  Wi787 b  We9:9 b  Wa;<; n  W]=>= 4  X]�m?
�m 
cpar? m  [\�l�l > o  WX�k�k 0 filecontents fileContents< o  ]`�j
�j 
ret : o  ad�i�i 0 
neuesdatum 
neuesDatum8 o      �h�h 0 	neuertext 	neuerText6 @A@ l jj�gBC�g  B 3 -set paragraph 2 of fileContents to neuesDatum   C �DD Z s e t   p a r a g r a p h   2   o f   f i l e C o n t e n t s   t o   n e u e s D a t u mA EFE l jj�fGH�f  G 9 3display dialog "neues Datum: " & return & neuerText   H �II f d i s p l a y   d i a l o g   " n e u e s   D a t u m :   "   &   r e t u r n   &   n e u e r T e x tF JKJ I ju�eLM
�e .rdwrseofnull���     ****L o  jm�d�d 0 refnum RefNumM �cN�b
�c 
set2N m  pq�a�a  �b  K OPO I v��`QR
�` .rdwrwritnull���     ****Q o  vy�_�_ 0 	neuertext 	neuerTextR �^S�]
�^ 
refnS o  |�\�\ 0 refnum RefNum�]  P T�[T I ���ZU�Y
�Z .rdwrclosnull���     ****U o  ���X�X 0 refnum RefNum�Y  �[   U R      �W�V�U
�W .ascrerr ****      � ****�V  �U   V I ���TV�S
�T .rdwrclosnull���     ****V o  ���R�R 0 refnum RefNum�S   S WXW l ���Q�P�O�Q  �P  �O  X YZY l ���N[\�N  [   Neue Version einsetzen   \ �]] .   N e u e   V e r s i o n   e i n s e t z e nZ ^_^ r  ��`a` m  ��bb �cc  a o      �M�M 0 filecontents fileContents_ ded r  ��fgf 4  ���Lh
�L 
alish l ��i�K�Ji l ��j�I�Hj I ���Gkl
�G .earsffdralis        afdrk  f  ��l �Fm�E
�F 
rtypm m  ���D
�D 
ctxt�E  �I  �H  �K  �J  g o      �C�C 0 
homeordner  e non l ���Bpq�B  p 0 *display dialog "homeordner: " & homeordner   q �rr T d i s p l a y   d i a l o g   " h o m e o r d n e r :   "   &   h o m e o r d n e ro sts r  ��uvu n  ��wxw m  ���A
�A 
ctnrx o  ���@�@ 0 
homeordner  v o      �?�? 0 homeordnerpfad  t yzy r  ��{|{ n  ��}~} 1  ���>
�> 
pnam~ o  ���=�= 0 homeordnerpfad  | o      �<�< 0 projektname Projektnamez � l ���;���;  � 2 ,display dialog "Projektname: " & Projektname   � ��� X d i s p l a y   d i a l o g   " P r o j e k t n a m e :   "   &   P r o j e k t n a m e� ��� r  ����� n ����� 1  ���:
�: 
txdl� 1  ���9
�9 
ascr� o      �8�8 0 olddels oldDels� ��� r  ����� m  ���� ���  _� n     ��� 1  ���7
�7 
txdl� 1  ���6
�6 
ascr� ��� l ���5�4�3�5  �4  �3  � ��� r  ����� n  ����� 2 ���2
�2 
citm� o  ���1�1 0 projektname Projektname� o      �0�0 0 zeilenliste Zeilenliste� ��� r  ����� n  ����� m  ���/
�/ 
nmbr� o  ���.�. 0 zeilenliste Zeilenliste� o      �-�- 0 	anzzeilen 	anzZeilen� ��� l ���,���,  � n hdisplay dialog "Zeilenliste: " & return & (Zeilenliste as list) & return & "Anzahl Zeilen: " & anzZeilen   � ��� � d i s p l a y   d i a l o g   " Z e i l e n l i s t e :   "   &   r e t u r n   &   ( Z e i l e n l i s t e   a s   l i s t )   &   r e t u r n   &   " A n z a h l   Z e i l e n :   "   &   a n z Z e i l e n� ��� l ���+�*�)�+  �*  �)  � ��� l ���(���(  � � �display dialog "Zeilenliste: " & return & item 1 of Zeilenliste & return & item 2 of Zeilenliste & return & item 3 of Zeilenliste & return & item 4 of Zeilenliste & return & item 5 of Zeilenliste   � ���� d i s p l a y   d i a l o g   " Z e i l e n l i s t e :   "   &   r e t u r n   &   i t e m   1   o f   Z e i l e n l i s t e   &   r e t u r n   &   i t e m   2   o f   Z e i l e n l i s t e   &   r e t u r n   &   i t e m   3   o f   Z e i l e n l i s t e   &   r e t u r n   &   i t e m   4   o f   Z e i l e n l i s t e   &   r e t u r n   &   i t e m   5   o f   Z e i l e n l i s t e� ��� r  ����� n  ����� 4  ���'�
�' 
cobj� l ����&�%� \  ����� o  ���$�$ 0 	anzzeilen 	anzZeilen� m  ���#�# �&  �%  � o  ���"�" 0 zeilenliste Zeilenliste� o      �!�! 0 version1 Version1� ��� r  ���� n  �	��� 4  	� �
�  
cobj� o  �� 0 	anzzeilen 	anzZeilen� o  ��� 0 zeilenliste Zeilenliste� o      �� 0 version2 Version2� ��� r  ��� o  �� 0 olddels oldDels� n     ��� 1  �
� 
txdl� 1  �
� 
ascr� ��� l ����  �  �  � ��� l ����  � 2 ,set main to file "datum.c" of homeordnerpfad   � ��� X s e t   m a i n   t o   f i l e   " d a t u m . c "   o f   h o m e o r d n e r p f a d� ��� r  #��� b  !��� l ���� c  ��� o  �� 0 homeordnerpfad  � m  �
� 
TEXT�  �  � m   �� ���  v e r s i o n . c� o      �� 0 filepfad  � ��� l $$����  � , &display dialog "filepfad: " & filepfad   � ��� L d i s p l a y   d i a l o g   " f i l e p f a d :   "   &   f i l e p f a d� ��� I $)���
� .miscactvnull��� ��� obj �  �  � ��� r  *8��� l *4���� I *4�
��
�
 .rdwropenshor       file� 4  *.�	�
�	 
file� o  ,-�� 0 filepfad  � ���
� 
perm� m  /0�
� boovtrue�  �  �  � o      �� 0 refnum RefNum� ��� Q  9����� k  <��� ��� r  <E��� l <C���� I <C��� 
� .rdwrread****        ****� o  <?���� 0 refnum RefNum�   �  �  � o      ���� 0 filecontents fileContents� ��� l FF������  � 7 1display dialog "inhalt: " & return & fileContents   � ��� b d i s p l a y   d i a l o g   " i n h a l t :   "   &   r e t u r n   &   f i l e C o n t e n t s� ��� l FF��������  ��  ��  � ��� r  FP��� n  FL��� 4  GL���
�� 
cpar� m  JK���� � o  FG���� 0 filecontents fileContents� o      ���� 0 alteversion  � � � l QQ����   . (display dialog "Version: " & alteversion    � P d i s p l a y   d i a l o g   " V e r s i o n :   "   &   a l t e v e r s i o n   r  Q` n  Q\	 m  X\��
�� 
nmbr	 n  QX

 2 TX��
�� 
cha  o  QT���� 0 alteversion   o      ���� 0 l    l at r  at n  ap 7 dp��
�� 
ctxt m  hj����  m  ko����  o  ad���� 0 alteversion   o      ���� 0 neueversion neueVersion $  Anfang bis und mit Leerschlag    � <   A n f a n g   b i s   u n d   m i t   L e e r s c h l a g  l uu��������  ��  ��    r  u� b  u� b  u� !  b  u�"#" b  u�$%$ b  u�&'& b  u�()( b  u*+* n  u{,-, 4  v{��.
�� 
cpar. m  yz���� - o  uv���� 0 filecontents fileContents+ o  {~��
�� 
ret ) o  ����� 0 neueversion neueVersion' m  ��// �00  @ "% o  ������ 0 version1 Version1# m  ��11 �22  .! o  ������ 0 version2 Version2 m  ��33 �44  " o      ���� 0 	neuertext 	neuerText 565 l ����78��  7 4 .set paragraph 2 of fileContents to neueVersion   8 �99 \ s e t   p a r a g r a p h   2   o f   f i l e C o n t e n t s   t o   n e u e V e r s i o n6 :;: l ����<=��  < : 4display dialog "neue Version: " & return & neuerText   = �>> h d i s p l a y   d i a l o g   " n e u e   V e r s i o n :   "   &   r e t u r n   &   n e u e r T e x t; ?@? I ����AB
�� .rdwrseofnull���     ****A o  ������ 0 refnum RefNumB ��C��
�� 
set2C m  ������  ��  @ DED I ����FG
�� .rdwrwritnull���     ****F o  ������ 0 	neuertext 	neuerTextG ��H��
�� 
refnH o  ������ 0 refnum RefNum��  E I��I I ����J��
�� .rdwrclosnull���     ****J o  ������ 0 refnum RefNum��  ��  � R      ������
�� .ascrerr ****      � ****��  ��  � k  ��KK LML l ����������  ��  ��  M N��N I ����O��
�� .rdwrclosnull���     ****O o  ������ 0 refnum RefNum��  ��  � PQP l ����������  ��  ��  Q RSR n  ��TUT I  ���������� $0 logaktualisieren LogAktualisieren��  ��  U  f  ��S VWV l ����������  ��  ��  W X��X I ����Y��
�� .aevtodocnull  �    alisY n  ��Z[Z 4  ����\
�� 
file\ m  ��]] �^^ , W e b i n t e r f a c e . x c o d e p r o j[ o  ������ 0 homeordnerpfad  ��  ��   	 m     __�                                                                                  MACS  alis    r  Macintosh HD               �� �H+   �:
Finder.app                                                      Ƙh        ����  	                CoreServices    ǿ�      ƘK�     �:  ��  ��  3Macintosh HD:System:Library:CoreServices:Finder.app    
 F i n d e r . a p p    M a c i n t o s h   H D  &System/Library/CoreServices/Finder.app  / ��  ��  ��    `a` l     ��������  ��  ��  a b��b i     cdc I      �������� $0 logaktualisieren LogAktualisieren��  ��  d O    �efe k   �gg hih I   	������
�� .miscactvnull��� ��� obj ��  ��  i jkj l  
 
��������  ��  ��  k lml r   
 non m   
 pp �qq  o o      ���� 0 filecontents fileContentsm rsr r    tut 4    ��v
�� 
alisv l   w����w l   x����x I   ��yz
�� .earsffdralis        afdry  f    z ��{��
�� 
rtyp{ m    ��
�� 
ctxt��  ��  ��  ��  ��  u o      ���� 0 
homeordner  s |}| l   ��~��  ~ 0 *display dialog "homeordner: " & homeordner    ��� T d i s p l a y   d i a l o g   " h o m e o r d n e r :   "   &   h o m e o r d n e r} ��� r     ��� n    ��� m    ��
�� 
ctnr� o    ���� 0 
homeordner  � o      ���� 0 homeordnerpfad  � ��� l  ! !������  �  open homeordnerpfad   � ��� & o p e n   h o m e o r d n e r p f a d� ��� l  ! !������  � 8 2display dialog "homeordnerpfad: " & homeordnerpfad   � ��� d d i s p l a y   d i a l o g   " h o m e o r d n e r p f a d :   "   &   h o m e o r d n e r p f a d� ��� l  ! !������  � 2 ,set main to file "datum.c" of homeordnerpfad   � ��� X s e t   m a i n   t o   f i l e   " d a t u m . c "   o f   h o m e o r d n e r p f a d� ��� r   ! (��� b   ! &��� l  ! $������ c   ! $��� o   ! "���� 0 homeordnerpfad  � m   " #��
�� 
TEXT��  ��  � m   $ %�� ���  L o g f i l e . t x t� o      ���� 0 filepfad  � ��� l  ) )������  � , &display dialog "filepfad: " & filepfad   � ��� L d i s p l a y   d i a l o g   " f i l e p f a d :   "   &   f i l e p f a d� ��� l  ) )������  � ! tell application "TextEdit"   � ��� 6 t e l l   a p p l i c a t i o n   " T e x t E d i t "� ��� I  ) .������
�� .miscactvnull��� ��� obj ��  ��  � ��� r   / ;��� l  / 9������ I  / 9����
�� .rdwropenshor       file� 4   / 3���
�� 
file� o   1 2���� 0 filepfad  � �����
�� 
perm� m   4 5��
�� boovtrue��  ��  ��  � o      ���� 0 refnum RefNum� ��� Q   <\���� k   ?O�� ��� r   ? F��� l  ? D������ I  ? D�����
�� .rdwrread****        ****� o   ? @���� 0 refnum RefNum��  ��  ��  � o      ���� 0 filecontents fileContents� ��� r   G P��� n   G N��� 4  K N���
�� 
cwor� m   L M����� l  G K��~�}� n   G K��� 4   H K�|�
�| 
cpar� m   I J�{�{ � o   G H�z�z 0 filecontents fileContents�~  �}  � o      �y�y 0 	lastdatum 	lastDatum� ��� l  Q Q�x���x  � 7 1display dialog "lastDatum: " & return & lastDatum   � ��� b d i s p l a y   d i a l o g   " l a s t D a t u m :   "   &   r e t u r n   &   l a s t D a t u m� ��� l  Q Q�w���w  � . (set Datum to paragraph 2 of fileContents   � ��� P s e t   D a t u m   t o   p a r a g r a p h   2   o f   f i l e C o n t e n t s� ��� l  Q Q�v���v  � &  display dialog "Datum: " & Datum   � ��� @ d i s p l a y   d i a l o g   " D a t u m :   "   &   D a t u m� ��� r   Q X��� I  Q V�u�t�s
�u .misccurdldt    ��� null�t  �s  � o      �r�r 	0 heute  � ��� l  Y Y�q���q  � &  display dialog "heute: " & heute   � ��� @ d i s p l a y   d i a l o g   " h e u t e :   "   &   h e u t e� ��� r   Y `��� n   Y ^��� 1   Z ^�p
�p 
year� o   Y Z�o�o 	0 heute  � o      �n�n 0 jahrtext  � ��� r   a h��� n   a f��� m   b f�m
�m 
mnth� o   a b�l�l 	0 heute  � o      �k�k 0 	monattext  � ��� l  i i�j���j  � * $display dialog "monat: " & monattext   � ��� H d i s p l a y   d i a l o g   " m o n a t :   "   &   m o n a t t e x t� ��� r   i ���� n   i ~��� 7  r ~�i��
�i 
ctxt� m   v z�h�h��� m   { }�g�g��� l  i r��f�e� b   i r� � m   i l �  0  n   l q 1   m q�d
�d 
day  o   l m�c�c 	0 heute  �f  �e  � o      �b�b 0 tag  �  l  � ��a�a   " display dialog "tag: " & tag    �		 8 d i s p l a y   d i a l o g   " t a g :   "   &   t a g 

 r   � � J   � �  m   � ��`
�` 
jan   m   � ��_
�_ 
feb   m   � ��^
�^ 
mar   l 	 � ��]�\ m   � ��[
�[ 
apr �]  �\    m   � ��Z
�Z 
may   m   � ��Y
�Y 
jun   m   � ��X
�X 
jul   m   � ��W
�W 
aug   !  l 	 � �"�V�U" m   � ��T
�T 
sep �V  �U  ! #$# m   � ��S
�S 
oct $ %&% m   � ��R
�R 
nov & '�Q' m   � ��P
�P 
dec �Q   o      �O�O 0 monatsliste MonatsListe ()( Y   � �*�N+,�M* Z   � �-.�L�K- =   � �/0/ o   � ��J�J 0 	monattext  0 n   � �121 4   � ��I3
�I 
cobj3 o   � ��H�H 0 i  2 o   � ��G�G 0 monatsliste MonatsListe. k   � �44 565 r   � �787 n   � �9:9 7  � ��F;<
�F 
ctxt; m   � ��E�E��< m   � ��D�D��: l  � �=�C�B= b   � �>?> m   � �@@ �AA  0? o   � ��A�A 0 i  �C  �B  8 o      �@�@ 	0 monat  6 B�?B l  � �CDEC  S   � �D - ' wenn true, wird die Schleife verlassen   E �FF N   w e n n   t r u e ,   w i r d   d i e   S c h l e i f e   v e r l a s s e n�?  �L  �K  �N 0 i  + m   � ��>�> , m   � ��=�= �M  ) GHG l  � ��<IJ�<  I &  display dialog "monat: " & monat   J �KK @ d i s p l a y   d i a l o g   " m o n a t :   "   &   m o n a tH LML r   � �NON l 	 � �P�;�:P l  � �Q�9�8Q n  � �RSR 7  � ��7TU
�7 
cha T m   � ��6�6 U m   � ��5�5 S l  � �V�4�3V c   � �WXW o   � ��2�2 0 jahrtext  X m   � ��1
�1 
ctxt�4  �3  �9  �8  �;  �:  O o      �0�0 0 jahr  M YZY l  � ��/[\�/  [ ? 9display dialog "jahr: " & jahr & " jahrtext: " & jahrtext   \ �]] r d i s p l a y   d i a l o g   " j a h r :   "   &   j a h r   &   "   j a h r t e x t :   "   &   j a h r t e x tZ ^_^ l  � ��.`a�.  ` , &set l to number of characters of Datum   a �bb L s e t   l   t o   n u m b e r   o f   c h a r a c t e r s   o f   D a t u m_ cdc l  � ��-ef�-  e 1 +set neuesDatum to text -l thru -13 of Datum   f �gg V s e t   n e u e s D a t u m   t o   t e x t   - l   t h r u   - 1 3   o f   D a t u md hih l  � ��,jk�,  j P Jset neuesDatum to text 1 thru 14 of Datum -- Anfang bis und mit Leerschlag   k �ll � s e t   n e u e s D a t u m   t o   t e x t   1   t h r u   1 4   o f   D a t u m   - -   A n f a n g   b i s   u n d   m i t   L e e r s c h l a gi mnm r   �opo b   �qrq b   �sts b   � �uvu b   � �wxw o   � ��+�+ 0 tag  x m   � �yy �zz  .v o   � ��*�* 	0 monat  t m   � {{ �||  .r o  �)�) 0 jahrtext  p o      �(�( 0 
neuesdatum 
neuesDatumn }~} l �'��'   0 *display dialog "neuesDatum: " & neuesDatum   � ��� T d i s p l a y   d i a l o g   " n e u e s D a t u m :   "   &   n e u e s D a t u m~ ��� Z  I���&�� = 	��� o  �%�% 0 
neuesdatum 
neuesDatum� o  �$�$ 0 	lastdatum 	lastDatum� l �#���#  � % display dialog "gleiches Datum"   � ��� > d i s p l a y   d i a l o g   " g l e i c h e s   D a t u m "�&  � k  I�� ��� l �"�!� �"  �!  �   � ��� r  5��� b  3��� b  /��� b  -��� b  )��� b  %��� b  !��� b  ��� b  ��� b  ��� m  �� ��� T * * * * * * * * * * * * * * * * * * * * * *                                        � o  �� 0 
neuesdatum 
neuesDatum� o  �
� 
ret � l 	���� o  �
� 
ret �  �  � o   �
� 
ret � o  !$�
� 
ret � l 	%(���� m  %(�� ��� , * * * * * * * * * * * * * * * * * * * * * *�  �  � o  ),�
� 
ret � o  -.�� 0 filecontents fileContents� o  /2�
� 
ret � o      �� 0 	neuertext 	neuerText� ��� I 6?���
� .rdwrseofnull���     ****� o  67�� 0 refnum RefNum� ���
� 
set2� m  :;��  �  � ��� I @I���
� .rdwrwritnull���     ****� o  @A�� 0 	neuertext 	neuerText� �
��	
�
 
refn� o  DE�� 0 refnum RefNum�	  �  � ��� I JO���
� .rdwrclosnull���     ****� o  JK�� 0 refnum RefNum�  �  � R      ���
� .ascrerr ****      � ****�  �  � I W\� ���
�  .rdwrclosnull���     ****� o  WX���� 0 refnum RefNum��  � ��� l ]]������  �  start   � ��� 
 s t a r t� ��� r  ]f��� J  ]b�� ���� m  ]`�� ���  x c o d e p r o j��  � o      ���� 0 filetype  � ��� l gg������  � ? 9set projektpfad to (path to alias (homeordner)) as string   � ��� r s e t   p r o j e k t p f a d   t o   ( p a t h   t o   a l i a s   ( h o m e o r d n e r ) )   a s   s t r i n g� ��� l gg������  � 0 *display dialog "projektpfad" & projektpfad   � ��� T d i s p l a y   d i a l o g   " p r o j e k t p f a d "   &   p r o j e k t p f a d� ��� l gg������  � 8 2display dialog "homeordnerpfad: " & homeordnerpfad   � ��� d d i s p l a y   d i a l o g   " h o m e o r d n e r p f a d :   "   &   h o m e o r d n e r p f a d� ��� l gg������  � > 8get name of folders of folder (homeordnerpfad as string)   � ��� p g e t   n a m e   o f   f o l d e r s   o f   f o l d e r   ( h o m e o r d n e r p f a d   a s   s t r i n g )� ��� l gy���� r  gy��� n  gu��� 1  qu��
�� 
pnam� n  gq��� 2 oq��
�� 
file� 4  go���
�� 
cfol� l kn������ c  kn��� o  kl���� 0 homeordnerpfad  � m  lm��
�� 
TEXT��  ��  � o      ���� 
0 inhalt  �  without invisibles   � ��� $ w i t h o u t   i n v i s i b l e s� ��� l zz������  � # display dialog inhalt as text   � ��� : d i s p l a y   d i a l o g   i n h a l t   a s   t e x t� ��� l zz������  � 7 1repeat with i from 1 to number of items of inhalt   � ��� b r e p e a t   w i t h   i   f r o m   1   t o   n u m b e r   o f   i t e m s   o f   i n h a l t� ���� X  z������ k  ���� ��� l ��������  � &  display dialog (dasFile) as text   � ��� @ d i s p l a y   d i a l o g   ( d a s F i l e )   a s   t e x t� ���� Z  ��������� E  ����� l �� ����  l ������ o  ������ 0 dasfile dasFile��  ��  ��  ��  � m  �� �  x c o d e p r o j� k  ��  r  �� b  ��	
	 l ������ c  �� o  ������ 0 homeordnerpfad   m  ����
�� 
ctxt��  ��  
 l ������ c  �� o  ������ 0 dasfile dasFile m  ����
�� 
ctxt��  ��   o      ���� 0 filepfad    l ������   &  display dialog (dasFile) as text    � @ d i s p l a y   d i a l o g   ( d a s F i l e )   a s   t e x t �� I ������
�� .aevtodocnull  �    alis 4  ����
�� 
file o  ������ 0 filepfad  ��  ��  ��  ��  ��  �� 0 dasfile dasFile� o  }����� 
0 inhalt  ��  f m     �                                                                                  MACS  alis    r  Macintosh HD               �� �H+   �:
Finder.app                                                      Ƙh        ����  	                CoreServices    ǿ�      ƘK�     �:  ��  ��  3Macintosh HD:System:Library:CoreServices:Finder.app    
 F i n d e r . a p p    M a c i n t o s h   H D  &System/Library/CoreServices/Finder.app  / ��  ��       ����   ������ $0 logaktualisieren LogAktualisieren
�� .aevtoappnull  �   � **** ��d�������� $0 logaktualisieren LogAktualisieren��  ��   ���������������������������������������� 0 filecontents fileContents�� 0 
homeordner  �� 0 homeordnerpfad  �� 0 filepfad  �� 0 refnum RefNum�� 0 	lastdatum 	lastDatum�� 	0 heute  �� 0 jahrtext  �� 0 	monattext  �� 0 tag  �� 0 monatsliste MonatsListe�� 0 i  �� 	0 monat  �� 0 jahr  �� 0 
neuesdatum 
neuesDatum�� 0 	neuertext 	neuerText�� 0 filetype  �� 
0 inhalt  �� 0 dasfile dasFile :��p���������������������������������������������������������������@����y{�����������������������������
�� .miscactvnull��� ��� obj 
�� 
alis
�� 
rtyp
�� 
ctxt
�� .earsffdralis        afdr
�� 
ctnr
�� 
TEXT
�� 
file
�� 
perm
�� .rdwropenshor       file
�� .rdwrread****        ****
�� 
cpar
�� 
cwor
�� .misccurdldt    ��� null
�� 
year
�� 
mnth
�� 
day ����
�� 
jan 
�� 
feb 
�� 
mar 
�� 
apr 
�� 
may 
�� 
jun 
�� 
jul 
�� 
aug 
�� 
sep 
�� 
oct 
�� 
nov 
�� 
dec �� 
�� 
cobj
�� 
cha �� 
�� 
ret 
�� 
set2
�� .rdwrseofnull���     ****
�� 
refn
�� .rdwrwritnull���     ****
�� .rdwrclosnull���     ****��  ��  
�� 
cfol
�� 
pnam
�� 
kocl
�� .corecnte****       ****
�� .aevtodocnull  �    alis�����*j O�E�O*�)��l /E�O��,E�O��&�%E�O*j O*�/�el E�O�j E�O��k/�i/E�O*j E�O�a ,E�O�a ,E�Oa �a ,%[�\[Za \Zi2E�Oa a a a a a a a a a a  a !a "vE�O 4ka "kh ��a #�/  a $�%[�\[Za \Zi2E�OY h[OY��O��&[a %\[Zm\Za &2E�O�a '%�%a (%�%E�O��  hY ;a )�%_ *%_ *%_ *%_ *%a +%_ *%�%_ *%E�O�a ,jl -O�a .�l /O�j 0W X 1 2�j 0Oa 3kvE^ O*a 4��&/�-a 5,E^ O <] [a 6a #l 7kh ] a 8 ��&] �&%E�O*�/j 9Y h[OY��U ������ !��
�� .aevtoappnull  �   � **** k    �""  ����  ��  ��    ���� 0 i  ! Z_ ��������~�}�|�{�z ;�y�x�w�v�u�t�s�r�q�p�o�n�m�l�k ��j�i�h�g�f�e�d�c�b�a�`�_�^�]�\�[�Z�Y ��X�W�V�U�T�S�R�Q#%')�P�O�N�M�L�K�J�I�Hb�G�F�E�D�C��B�A�@�?�>��=�<�;/13�:]�9�� 0 filecontents fileContents
�� 
alis
�� 
rtyp
� 
ctxt
�~ .earsffdralis        afdr�} 0 
homeordner  
�| 
ctnr�{ 0 homeordnerpfad  
�z 
TEXT�y 0 filepfad  
�x .miscactvnull��� ��� obj 
�w 
file
�v 
perm
�u .rdwropenshor       file�t 0 refnum RefNum
�s .rdwrread****        ****
�r 
cpar�q 0 datum Datum
�p .misccurdldt    ��� null�o 	0 heute  
�n 
year�m 0 jahrtext  
�l 
mnth�k 0 	monattext  
�j 
day �i���h 0 tag  
�g 
jan 
�f 
feb 
�e 
mar 
�d 
apr 
�c 
may 
�b 
jun 
�a 
jul 
�` 
aug 
�_ 
sep 
�^ 
oct 
�] 
nov 
�\ 
dec �[ �Z 0 monatsliste MonatsListe
�Y 
cobj�X 	0 monat  
�W 
cha �V �U 0 jahr  
�T 
nmbr�S 0 l  �R �Q 0 
neuesdatum 
neuesDatum
�P 
ret �O 0 	neuertext 	neuerText
�N 
set2
�M .rdwrseofnull���     ****
�L 
refn
�K .rdwrwritnull���     ****
�J .rdwrclosnull���     ****�I  �H  
�G 
pnam�F 0 projektname Projektname
�E 
ascr
�D 
txdl�C 0 olddels oldDels
�B 
citm�A 0 zeilenliste Zeilenliste�@ 0 	anzzeilen 	anzZeilen�? 0 version1 Version1�> 0 version2 Version2�= 0 alteversion  �< �; 0 neueversion neueVersion�: $0 logaktualisieren LogAktualisieren
�9 .aevtodocnull  �    alis������E�O*�)��l /E�O��,E�O��&�%E�O*j O*��/�el E` OU_ j E�O�a l/E` O*j E` O_ a ,E` O_ a ,E` Oa _ a ,%[�\[Za \Zi2E` Oa a  a !a "a #a $a %a &a 'a (a )a *a +vE` ,O :ka +kh  _ _ ,a -�/  a .�%[�\[Za \Zi2E` /OY h[OY��O_ �&[a 0\[Zm\Za 12E` 2O_ a 0-a 3,E` 4O_ [�\[Zk\Za 52E` 6O_ 6a 7%_ %a 8%_ /%a 9%_ %a :%E` 6O�a k/_ ;%_ 6%E` <O_ a =jl >O_ <a ?_ l @O_ j AW X B C_ j AOa DE�O*�)��l /E�O��,E�O�a E,E` FO_ Ga H,E` IOa J_ Ga H,FO_ Fa K-E` LO_ La 3,E` MO_ La -_ Mk/E` NO_ La -_ M/E` OO_ I_ Ga H,FO��&a P%E�O*j O*��/�el E` O �_ j E�O�a l/E` QO_ Qa 0-a 3,E` 4O_ Q[�\[Zk\Za R2E` SO�a k/_ ;%_ S%a T%_ N%a U%_ O%a V%E` <O_ a =jl >O_ <a ?_ l @O_ j AW X B C_ j AO)j+ WO��a X/j YUascr  ��ޭ