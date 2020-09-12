var s:ansistring; //s 表示当前的字符串
    c:char;       //c 是当前读入的字符
    t:longint;    //t 表示当前 token
    // t=0 表示 目前还没有什么东西qwq
    // t=1 表示 [NAME] 或 [RESERVED]
    // t=2 表示 [NUMBER]
    // t=3 表示 [COMMENT]
    // t=4 表示 [STRING] 并且以单引号开头
    // t=5 表示 [STRING] 并且以双引号开头
function is_reserved(s:ansistring):boolean;
begin
  s:=lowercase(s);
  exit((s='and') or (s='break') or (s='do') or (s='else') or (s='elseif')
    or (s='end') or (s='false') or (s='for') or (s='function') or (s='if')
    or (s='in') or (s='local') or (s='nil') or (s='not') or (s='or')
    or (s='repeat') or (s='return') or (s='then') or (s='true') or (s='until')
    or (s='while'));
end;
procedure stoptoken;
begin
  case t of
    1:if is_reserved(s) then
        writeln('[RESERVED] ',s)
      else
        writeln('[NAME] ', s);
    2:writeln('[NUMBER] ',s);
    3:writeln('[COMMENT] ',s);
    4:writeln('[STRING] ',s);
    5:writeln('[STRING] ',s);
  end;
end;
begin
  while not eof do
  begin
    read(c);
    case c of
      '''':case t of
             0,1,2,3:begin
                       stoptoken;
                       s:='''';
                       t:=4;
                     end;
             4:begin
                 writeln('[STRING] ',s,'''');
                 s:='';
                 t:=0;
               end;
             5:s:=s+c;
           end;
      '"':case t of
            0,1,2,3:begin
                      stoptoken;
                      s:='"';
                      t:=5;
                    end;
            4:s:=s+c;
            5:begin
                writeln('[STRING] ',s,'"');
                s:='';
                t:=0;
              end;
          end;
      ' ':case t of
            0,1,2,3:begin
                      stoptoken;
                      s:='';
                      t:=0;
                    end;
            4,5:s:=s+c;
          end;
    end;
  end;
end.
