var s:ansistring; //s 表示当前的字符串
    c:char;       //c 是当前读入的字符
    t:longint;    //t 表示当前 token
    // t=0 表示 目前还没有什么东西qwq
    // t=1 表示 [NAME] 或 [RESERVED]
    // t=2 表示 [NUMBER] （十进制）
    // t=3 表示 [NUMBER] （十六进制）
    // t=4 表示 [COMMENT]
    // t=5 表示 [STRING] 并且以单引号开头
    // t=6 表示 [STRING] 并且以双引号开头
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
    2,3:writeln('[NUMBER] ',s);
    4:writeln('[COMMENT] ',s);
    5:writeln('[STRING] ',s);
    6:writeln('[STRING] ',s);
  end;
end;
procedure fileinit; //调试用的
begin
  assign(output,'C:/output');
  rewrite(output);
  assign(input,'C:/input');
  reset(input);
end;
begin
  //fileinit;
  while not eof do
  begin
    read(c);
    case c of
      '\':case t of
            1,2,3,4:begin
                      stoptoken;
                      s:='';t:=0;
                    end;
            5,6:s:=s+c;
          end;
      '''':case t of
             0,1,2,3,4:begin
                         stoptoken;
                         s:='''';t:=5;
                       end;
             5:if (length(s)<>0) and (s[length(s)]<>'\') then
               begin
                 writeln('[STRING] ',s,'''');
                 s:='';t:=0;
               end
               else
                 s:=s+c;
             6:s:=s+c;
           end;
      '"':case t of
            0,1,2,3,4:begin
                        stoptoken;
                        s:='"';t:=6;
                      end;
            5:s:=s+c;
            6:if (length(s)<>0) and (s[length(s)]<>'\') then
              begin
                writeln('[STRING] ',s,'"');
                s:='';t:=0;
              end
              else
                s:=s+c;
          end;
      ' ':case t of
            1,2,3,4:begin
                      stoptoken;
                      s:='';t:=0;
                    end;
            5,6:s:=s+c;
          end;
      #10:begin
            stoptoken;
            s:='';t:=0;
            writeln('[EOL]');
          end;
      '0'..'9':case t of
                 1,2,3,5,6:s:=s+c;
                 0,4:begin
                       stoptoken;
                       s:=c;t:=2;
                     end;
               end;
      'e','E':case t of
                0:begin
                    s:=s+c;t:=1;
                  end;
                1,5,6:s:=s+c;
                2:if s[length(s)]<>'.' then
                    s:=s+c
                  else
                  begin
                    stoptoken;
                    s:=c;t:=1;
                  end;
                3,4:begin
                        stoptoken;
                        s:=c;t:=1;
                    end;
              end;
    end;
  end;
  stoptoken;
end.
