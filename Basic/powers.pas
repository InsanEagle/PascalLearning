program powers;

var q, c, f, t, x: real;

procedure Powers (x: real; var q, c, f, t: real);
begin
    q:= x * x;
    c:= q * x;
    f:= c * x;
    t:= f * x;
end;

begin
    writeln('Type number to be powered');
    readln(x);
    Powers(x, q, c ,f ,t);
    writeln(x, q, c, f, t);
end.