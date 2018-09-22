Impulse i => BiQuad f => dac;

//set filter's pole radius
.99 => f.prad;

//set equal gain zero's
1 => f.eqzs;

//initialize float variable
0.0 => float v;

while(true){    
        //set current sample/impulse
        1.0 => i.next;
        //sweep the filter resonant frequency
        Std.fabs(Math.sin(v)) * 4000.0 => f.pfreq;
    
        //increment v
        v + .1 => v;
    
        //advance time
        99::ms => now;
    }