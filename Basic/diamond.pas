program diamond;

var 
    i, k, n, x: integer;

begin
// Entering odd x
writeln('Type odd height of diamond (>1)');
readln(x);
writeln(x mod 2);
while (x <= 0) or (x mod 2 = 0) do begin
    writeln('Your number is uncorrect. Type odd height of diamond (>1)');
    readln(x);  
end;
n := x div 2;
// Upper part
    for k := 1 to n + 1 do
    begin
        for i := 1 to n + 1 - k do
            write(' ');
        write('*');
        if k > 1 then
        begin
            for i := 1 to  2*k - 3 do 
                write(' ');
            write('*')
        end;
        writeln();
    end;  
// Lower part
for k := n downto 1 do
    begin
        for i := 1 to n + 1 - k do
            write(' ');
        write('*');
        if k > 1 then
        begin
            for i := 1 to  2*k - 3 do 
                write(' ');
            write('*')
        end;
        writeln();
    end;
end.




{ 
x = 7

   *             3-*-3              
  * *            2-*-1-*-2
 *   *           1-*-3-*-1
*     *          *-5-*
 *   *           1-*-3-*-1
  * *            2-*-1-*-2
   *             3-*-3
}