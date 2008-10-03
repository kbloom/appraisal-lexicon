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

#change the lexeme-sense and change the global attitude type at the same time
def j $thetext $newtype{
   $curtype=$newtype;
   q $thetext;
}

#change the lexeme-sense, using the current global attitude type
def q $thetext {
   cd $f//lexeme[phrase/text()=$thetext];
   list :d 4;
};

#update the current lexeme-sense to a new attitude type
def t $newtype {
   saveundo;
   set entry[base[@att="attitude" and @value=$curtype]]/base[@att="attitude"]/@value $newtype;
};
#make the current lexeme-sense negative
def neg {
   saveundo;
   set entry[base[@att="attitude" and @value=$curtype]]/base[@att="orientation"]/@value "negative";
};
#make the current lexeme-sense positive
def pos {
   saveundo;
   set entry[base[@att="attitude" and @value=$curtype]]/base[@att="orientation"]/@value "positive";
};
#delete the whole current lexeme
def dd{
   saveundo;
   delete .;
};
#delete a named lexeme
def d $thetext {
   saveundo;
   q $thetext;
   delete .;
};
#delete the current lexeme sense
def dte{
   saveundo;
   delete entry[base[@att="attitude" and @value=$curtype]];
};
#delete the named lexeme-sense (using the current global attitude type)
def de $thetext{
   saveundo;
   q $thetext;
   dte;
};
#delete the $thetext sense of the current lexeme
def dt $thetext{
   saveundo;
   delete entry[base[@att="attitude" and @value=$thetext]];
};
#open the current lexeme (all senses) in the editor
def e{
   my $pwd;
   $pwd := pwd;
   saveundo;
   edit .;
   cd xsh:evaluate($pwd);
};
#insert a new sense into the current lexeme, with the specified attitude type and orientation
def a $type $ori{
   saveundo;
   insert chunk xsh:sprintf('<entry domain="appraisal"><constraints></constraints><base att="attitude" value="%s"/><base att="force" value="median"/><base att="focus" value="median"/><base att="orientation" value="%s"/><base att="polarity" value="unmarked"/></entry>', $type, $ori) into .;
};
#save the file as combined.xml
def dosave{
   save --pipe "xmlstarlet fo > combined.xml" $f;
};
