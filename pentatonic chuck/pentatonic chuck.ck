/*connect a plucked string to the soundcard out*/
Mandolin s1 => JCRev r => dac;
Mandolin s2 => r;

.6 => s1.gain;
.4 => s2.gain;
.9 => r.gain;
.2 => r.mix;

0 => int rest; // rest "note"

// MIDI note constants
60 => int c;     72 => int C;
61 => int cs;    73 => int Cs;
62 => int d;     74 => int D;
63 => int ds;    75 => int Ds;
64 => int e;     76 => int E;
65 => int f;     77 => int F;
66 => int fs;    78 => int Fs;
67 => int g;     79 => int G;
68 => int gs;    80 => int Gs;
69 => int a;     81 => int A;
70 => int as;    82 => int As;
71 => int b;     83 => int B;

// We use musical tempo, and symbolic durations
120 => int tempo; // Maelzel Metronome units (quarters per minute)
// integers 1,2,4,8 mean musical figures
dur duration[9];
240000::ms / ( 1 * tempo )  => duration[1]; // whole
240000::ms / ( 2 * tempo )  => duration[2]; // half
240000::ms / ( 4 * tempo )  => duration[4]; // quarter (crotchet)
240000::ms / ( 8 * tempo )  => duration[8]; // eighth (quaver)
240000::ms / ( 16 * tempo )  => duration[7]; // sixteenth
(duration[4] + duration[8]) => duration[5]; // dotted quarter
(duration[2] + duration[4]) => duration[3]; // dotted half

[[A,8],[A,8],[G,7],[G,7],[F,7],[F,7],[C,4],[e,4],
[a,4],[c,4],[e,7],[e,7],[a,8],[a,2],
[g,4],[b,4],[E,2],[G,7],[G,7],[G,7],[G,7],[E,2],
[A,8],[A,8],[G,7],[G,7],[F,7],[F,7],[C,4],[e,4],
[a,4],[c,4],[e,7],[e,7],[a,8],[a,2],
[g,4],[b,4],[E,2],[G,7],[G,7],[G,7],[G,7],[E,2],
[rest,1],[rest,1],
[C,7],[D,7],[E,7],[G,7],[A,8],[A,8],
[C,7],[D,7],[E,7],[G,7],[E,4],
[E,7],[G,7],[A,7],[b,7],[D,8],[E,8],
[E,7],[G,7],[A,7],[b,7],[C,4],
[C,7],[E,7],[G,7],[D,7],[b,8],[a,8],
[c,7],[d,7],[e,7],[g,7],[a,8],[a,8],
[e,8],[d,8],[b,7],[a,7],[a,7],[b,7],
[e,8],[d,8],[b,7],[a,7],[g,7],[e,7],
[C,7],[D,7],[E,7],[G,7],[A,8],[A,8],
[C,7],[D,7],[E,7],[G,7],[E,4],
[E,7],[G,7],[A,7],[b,7],[D,8],[E,8],
[E,7],[G,7],[A,7],[b,7],[C,4],
[b,4],[a,4],[g,7],[g,7],[fs,7],[f,7],[e,4],
[d,2],[c,2],
[A,8],[A,8],[G,7],[G,7],[F,7],[F,7],[C,4],[e,4],
[a,4],[c,4],[e,7],[e,7],[a,8],[a,2],
[g,4],[b,4],[E,2],[G,7],[G,7],[G,7],[G,7],[E,2],
[A,8],[A,8],[G,7],[G,7],[F,7],[F,7],[C,4],[e,4],
[a,4],[c,4],[e,7],[e,7],[a,8],[a,2],
[g,4],[b,4],[E,2],[G,7],[G,7],[G,7],[G,7],[E,2],
[F,4],[G,4],[B,2],
[A,7],[A,7],[A,7],[A,7],[A,3]] @=> int voice1[][];

[[a,2],[a,2],[a,2],[a,2],
[e,2],[e,2],[e,2],[e,2],
[a,2],[a,2],[a,2],[a,2],
[e,2],[e,2],[e,2],[e,2],
[a,2],[e,2],[g,2],[b,2],
[a,2],[a,2],[a,2],[a,2],
[e,2],[e,2],[e,2],[e,2],
[a,2],[a,2],[a,2],[a,2],
[e,2],[e,2],[e,2],[e,2],
[a,2],[a,2],[a,2],[a,2],
[e,2],[e,2],[e,2],[e,2],
[a,2],[a,2],[a,2],[a,2],
[e,2],[e,2],[e,2],[e,2],
[e,4],[g,4],[b,2],
[a,1]] @=> int voice2[][];

Event finish;

// Play a fragment
fun void playVoice(Mandolin m, int voice[][], int transport) {
    for( 0 => int i; i < voice.cap(); i++) {
        if ( voice[i][0] > 0 ) {
            Std.mtof( voice[i][0] + transport ) => m.freq;
            1.0 => m.pluck;
        }
        duration[voice[i][1]] => now;
    }
    finish.broadcast();
}

// Main: play the whole song
spork ~ playVoice(s1, voice1, 0);
spork ~ playVoice(s2, voice2, -12);
finish => now;