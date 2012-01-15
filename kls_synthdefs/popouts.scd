// popout synthdefs - these are momentary effects that silence-or-modify everything else
(
SynthDef(\popout4444ds1wee, { |out=0, gate=1, dur=1, amp=0.1, modfrom=1000, modto=10000|
	var moddepth, modrate, mod, son, env, trig;
	moddepth = ExpRand(0.0001, 1);
	modrate = ExpRand(0.1, 1000);
	mod = XLine.kr(modfrom, modto, dur)
		* LFPar.kr(modrate, Rand(0, pi)).range(1-moddepth, 1+moddepth);
	son = SinOsc.ar(mod);
	env = EnvGen.ar(Env.asr(0.01, 1, 0.01), gate, doneAction: 2);
	son = son * env;
	// HARDCODED OUTPUT TO ZERO! for popout effect
	ReplaceOut.ar(0, (son * amp).dup);
	// Also output as usual - irrelevant for the main mix, but useful if recording stems
	Out.ar(out, son * amp);
}).add;
);
(
SynthDef(\popout4444ds1stickglitch, { |out=0, gate=1, dur=1, amp=0.1, modfrom=1000, modto=10000, frac=0.3333333|
	// this was supposed to be a stick but it's a glitch
	var son, env;
	var recdur = dur * frac;
	var recframes = recdur * SampleRate.ir;
	var buf = LocalBuf(recframes, 2);
	// HARDCODED OUTPUT TO ZERO! for popout effect
	var in = In.ar(0, 2);
	RecordBuf.ar(in, buf, loop: 0);
	son = PlayBuf.ar(2, buf, loop: 1);
	env = EnvGen.ar(Env.asr(0.01, 1, 0.001), gate, doneAction: 2);
	// HARDCODED OUTPUT TO ZERO! for popout effect
	ReplaceOut.ar(0, (son * amp));
	// Also output as usual - irrelevant for the main mix, but useful if recording stems
	Out.ar(out, son * amp);
}).add;
);
(
SynthDef(\popout4444ds1stick, { |out=0, gate=1, dur=1, amp=0.1, modfrom=1000, modto=10000, frac=0.3333333|
	var son, recenv, env, loop;
	var recdur = dur * frac;
	// HARDCODED OUTPUT TO ZERO! for popout effect
	var in = In.ar(0, 2);
	recenv = EnvGen.ar(Env.asr(0.01, 0.95, 0.1), timeScale: recdur);
	//recdur.poll;
	in = in * recenv;
	loop = CombN.ar(in, recdur, recdur, 999);
	son = in + loop;
	env = EnvGen.ar(Env.asr(0.01, 1, 0.001), gate, doneAction: 2);
	// HARDCODED OUTPUT TO ZERO! for popout effect
	ReplaceOut.ar(0, son);
	// Also output as usual - irrelevant for the main mix, but useful if recording stems
	Out.ar(out, son);
}, [\ir, \kr, \ir, \ir, \ir, \ir, \ir]).add;
);
(
SynthDef(\popout4444ds1hpf, { |out=0, gate=1, dur=1, amp=0.1, modfrom=1000, modto=10000, frac=0.3333333|
	var son, recenv, env, loop;
	// HARDCODED OUTPUT TO ZERO! for popout effect
	var in = In.ar(0, 2);
	son = HPF.ar(in, XLine.ar(100, 10000, dur * 0.75)) * (in > 0.1);
	env = EnvGen.ar(Env.asr(0.01, 1, 0.001), gate, doneAction: 2);
	// HARDCODED OUTPUT TO ZERO! for popout effect
	ReplaceOut.ar(0, son);
	// Also output as usual - irrelevant for the main mix, but useful if recording stems
	Out.ar(out, son);
}, [\ir, \kr, \ir, \ir, \ir, \ir, \ir]).add;
);
(
SynthDef(\popout4444ds1slur, { |out=0, gate=1, dur=1, amp=0.1, modfrom=1000, modto=10000, frac=0.3333333|
	var son, recenv, env, loop;
	var delaylimit = dur * [1, 0.5].choose;
	// HARDCODED OUTPUT TO ZERO! for popout effect
	var in = In.ar(0, 2);
	son = DelayC.ar(in, delaylimit, Line.ar(0, delaylimit, dur).squared);
	env = EnvGen.ar(Env.asr(0.01, 1, 0.001), gate, doneAction: 2);
	// HARDCODED OUTPUT TO ZERO! for popout effect
	ReplaceOut.ar(0, son);
	// Also output as usual - irrelevant for the main mix, but useful if recording stems
	Out.ar(out, son);
}, [\ir, \kr, \ir, \ir, \ir, \ir, \ir]).add;
);

"popouts";

