(
SynthDef(\docp44441, { |freq=880, amp=0.1, out=0, gate=1, slur=0.25, moddepth=200, octavemod=2|
	var mod, son, env, trig;
	mod = Saw.ar(freq * octavemod);
	son = Saw.ar(Line.ar(0, 1, slur) * freq + (mod * moddepth));
	env = EnvGen.ar(Env.asr(0.01, 1, 0.01), gate);
	son = son * env;
	DetectSilence.ar(son, doneAction: 2); // Needed instead of in env cos of node-not-found messages
	Out.ar(out, (son * amp).dup);
}).add;
);

(
SynthDef(\booble44441, { |freq=880, amp=0.1, out=0, gate=1, slur=0.25, moddepth=200, octavemod=2, panwidth=1|
	var mod, son, env, trig, ratething;
	//ratething = exprand(5, 15);
	ratething = mod(freq * 0.06125 - 10, 25) + 10;
	son = LFPar.ar(Line.ar(0, 1, slur).round(0.06125) * freq * LFNoise0.kr(20).range(0.999, 1.001), 0, LFSaw.ar(0 - ratething * octavemod).range(0, 1).lag(0.01));
	son = (son * 2).tanh;
	env = EnvGen.ar(Env.asr(0.01, 1, 0.01), gate);
	son = son * env * 0.75;
	DetectSilence.ar(son, doneAction: 2); // Needed instead of in env cos of node-not-found messages
	Out.ar(out, Pan2.ar(son * amp, LFPar.ar(ratething * 0.5 * octavemod)));
}).add;
);

(
SynthDef(\whineflect44441, { |freq=880, basefreq=1760, amp=0.1, out=0, gate=1, slur=0.25, moddepth=200, octavemod=2|
	var mod, son, env, trig;
	mod = SinOsc.ar(freq * octavemod * 0.125);
	son = Saw.ar( LinXFade2.kr(basefreq, freq * 2, Line.kr(-1, 1, slur)) + (mod * moddepth * 0.25));
	son = HPF.ar(son, 5000);
	env = EnvGen.ar(Env.asr(0.01, 1, 0.01), gate);
	son = son * env;
	DetectSilence.ar(son, doneAction: 2); // Needed instead of in env cos of node-not-found messages
	Out.ar(out, (son * amp).dup);
}).add;
);

(
SynthDef(\chippychord44441, { |freq=880, amp=0.1, out=0, gate=1, slur=0.25, moddepth=200, octavemod=2, panwidth=1, modrate=0.0005|
	var mod, son, env, trig, livefreq, modindex;
	modindex = Phasor.kr(0, moddepth * modrate, 0, min(octavemod*2, 5));
	livefreq = freq * BufRd.kr(1, [1, 1.5, 2, 3, 4].as(LocalBuf), modindex, loop: 1, interpolation: 1);
	mod = Saw.ar(livefreq * octavemod);
	son = Saw.ar(livefreq);
	env = EnvGen.ar(Env.asr(0.01, 1, 0.01), gate);
	son = son * env;
	DetectSilence.ar(son, doneAction: 2); // Needed instead of in env cos of node-not-found messages
	Out.ar(out, Pan2.ar(son * amp * 0.7));
}).add;
/*
x = Synth(\chippychord44441);
*/
);

"whines";

