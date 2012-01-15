(
// high-pass FILTER for Pfx'ing bass in the build
SynthDef(\hpf44441, { arg out=0, cutoff=440, gate=1, dur=1;
	var env, realcutoff;
	env = Linen.kr(gate, 0.05, 1, 0.1, 2);
	//dur.poll;
	realcutoff = XLine.kr(10000, 10, dur);
	//realcutoff.poll;
	XOut.ar(out, env, HPF.ar(In.ar(out, 2), realcutoff));
}, [\kr, 0.1, 0, 0]).add;
);

"effects";

