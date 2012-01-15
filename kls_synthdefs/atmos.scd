(
// This synthdef is adapted from code by Jonatan Liljedahl
SynthDef(\eerie44441, { |freq=300, amp=0.1, out=0, gate=1|
	var syn, env, son;
	syn = BPF.ar(Splay.ar({
			Saw.ar(Rand(0, 100)+freq+LFNoise1.kr(0.1,10),mul:LFNoise1.kr(0.2))
		}!12),1000);
	syn = LeakDC.ar(GVerb.ar(syn,4,20,drylevel:0)); //.sin;
	env = EnvGen.ar(Env.asr, gate);
	son = syn * env;
	DetectSilence.ar(son, doneAction: 2);
	Out.ar(out, son * amp);
}).add;
);


(
SynthDef(\chih4444ds1, { |out=0, amp = 0.1, pan=0, topfreq=15000, mix = 0.33, room = 0.5, damp = 0.5|
	var freq, env, son;
	freq = XLine.ar(500, topfreq, 0.01);
	env Ê= EnvGen.ar(Env.perc(0.01, 0.1));
	son = SinOsc.ar(freq, pi*0.5, env).dup;
	son = FreeVerb2.ar(son[0], son[1], mix, room, damp);
	DetectSilence.ar(son, doneAction: 2);
	Out.ar(out, Pan2.ar(son * amp, pan));
}).add;
);

"atmos";

