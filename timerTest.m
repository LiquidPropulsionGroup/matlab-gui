clear;
t = timer('ExecutionMode', 'singleShot');

n = 5;
a = timer.empty(n,0);

for i = 1:n
   a(i)= timer( 'ExecutionMode', 'singleShot' );
end
