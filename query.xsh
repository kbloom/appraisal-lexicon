def saveundo{
   try{ $undo5:=get $undo4; $path5:=get $path4;} catch my $error {;}
   try{ $undo4:=get $undo3; $path4:=get $path3;} catch my $error {;}
   try{ $undo3:=get $undo2; $path3:=get $path2;} catch my $error {;}
   try{ $undo2:=get $undo1; $path2:=get $path1;} catch my $error {;}
   $undo1:=clone $f;
   $path1:=pwd;
};
def undo{
   $f := clone $undo1;
   my $newpath:= get $path1;
   try { $undo1 := get $undo2; $path1:= get $path2;} catch my $error {;}
   try { $undo2 := get $undo3; $path2:= get $path3;} catch my $error {;}
   try { $undo3 := get $undo4; $path3:= get $path4;} catch my $error {;}
   try { $undo4 := get $undo5; $path4:= get $path5;} catch my $error {;}
   cd $f;
   cd xsh:evaluate($newpath);
};
def j $thetext $newtype{
   $curtype=$newtype;
   q $thetext;
}
def q $thetext {
   cd $f//lexeme[phrase/text()=$thetext];
   list :d 4;
};
def fn {
   saveundo;
   set entry[base[@att="attitude" and @value=$curtype]]/base[@att="force"]/@value "low";
};
def fl {
   saveundo;
   set entry[base[@att="attitude" and @value=$curtype]]/base[@att="force"]/@value "low";
};
def fp {
   saveundo;
   set entry[base[@att="attitude" and @value=$curtype]]/base[@att="force"]/@value "high";
};
def t $newtype {
   saveundo;
   set entry[base[@att="attitude" and @value=$curtype]]/base[@att="attitude"]/@value $newtype;
};
def neg {
   saveundo;
   set entry[base[@att="attitude" and @value=$curtype]]/base[@att="orientation"]/@value "negative";
};
def pos {
   saveundo;
   set entry[base[@att="attitude" and @value=$curtype]]/base[@att="orientation"]/@value "positive";
};
def dd{
   saveundo;
   delete .;
};
def d $thetext {
   saveundo;
   q $thetext;
   delete .;
};
def dte{
   saveundo;
   delete entry[base[@att="attitude" and @value=$curtype]];
};
def de $thetext{
   saveundo;
   q $thetext;
   dte;
};
def dt $thetext{
   saveundo;
   delete entry[base[@att="attitude" and @value=$thetext]];
};
def e{
   my $pwd;
   $pwd := pwd;
   saveundo;
   edit .;
   cd xsh:evaluate($pwd);
};
def a $type $ori{
   saveundo;
   insert chunk xsh:sprintf('<entry domain="appraisal"><constraints></constraints><base att="attitude" value="%s"/><base att="force" value="median"/><base att="focus" value="median"/><base att="orientation" value="%s"/><base att="polarity" value="unmarked"/></entry>', $type, $ori) into .;
};
def dosave{
   save --pipe "xmlstarlet fo > combined.xml" $f;
};
